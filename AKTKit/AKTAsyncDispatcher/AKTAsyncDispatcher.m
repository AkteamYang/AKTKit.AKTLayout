//
//  AKTAsyncDispatch.m
//  Pursue
//
//  Created by YaHaoo on 16/3/26.
//  Copyright © 2016年 YaHaoo. All rights reserved.
//

#import "AKTAsyncDispatcher.h"
// import-<frameworks.h>
// import-"models.h"
#import "AKTPublic.h"
// import-"views & controllers.h"

//--------------# Macro #--------------
#define AD_ConcurrentLimit_Global 32
#define AD_ConcurrentLimit_Layout 64
#define AD_BacklogLimit 64
//--------------# E.n.d #--------------#>Macro

/*
 * Task has three different mode, task with different mode will be assigned to different group.
 * 任务有三种模式，不同模式的任务将被分配到不用的组。
 */
@interface AKTAsyncTaskModeGroup : NSObject
@property (strong, nonatomic) NSMutableArray     *defaultGroup;
@property (strong, nonatomic) NSMutableArray     *sequentialGroup;
@property (strong, nonatomic) NSMutableArray     *latestTaskGroup;
@property (copy, nonatomic  ) NSString           *ownerKey;
@property (weak, nonatomic  ) AKTAsyncDispatcher *dispatcher;
// Number of unempty groups.
// 不为空的组的数量
@property (assign, nonatomic) NSInteger          unemptyGroupCount;
/*
 * Add task to the group in modeGroup.
 * 向modeGroup的组中添加任务
 * @task: Task need to be added
 * @task: 需要添加的任务
 * @group: destination group
 * @group: 目标组
 */
- (void)modeGroupAddTask:(AKTAsyncTask *)task toGroup:(NSMutableArray *)group;

/*
 * Remove task from the group in modeGroup.
 * 从modeGroup的组中移除任务
 * @task: Task need to be removed
 * @task: 需要移除的任务
 * @group: destination group
 * @group: 目标组
 */
- (void)modeGroupRemoveTask:(AKTAsyncTask *)task fromGroup:(NSMutableArray *)group;

/*
 * Remove all of tasks from the group in modeGroup.
 * 从modeGroup的组中移除所有任务
 * @group: destination group
 * @group: 目标组
 */
- (void)modeGroupRemoveTasksAllfromGroup:(NSMutableArray *)group;
@end
@implementation AKTAsyncTaskModeGroup
#pragma mark - property settings
//|---------------------------------------------------------
/*
 * Initialize defaultGroup
 * 初始化 defaultGroup
 */
- (NSMutableArray *)defaultGroup {
    if (_defaultGroup == nil) {
        _defaultGroup = [NSMutableArray array];
    }
    return _defaultGroup;
}

/*
 * Initialize equentialGroup
 * 初始化 equentialGroup
 */
- (NSMutableArray *)sequentialGroup {
    if (_sequentialGroup == nil) {
        _sequentialGroup = [NSMutableArray array];
    }
    return _sequentialGroup;
}

/*
 * Initialize latestTaskGroup
 * 初始化 latestTaskGroup
 */
- (NSMutableArray *)latestTaskGroup {
    if (_latestTaskGroup == nil) {
        _latestTaskGroup = [NSMutableArray array];
    }
    return _latestTaskGroup;
}

/*
 * Set "unemptyGroupCount"
 * 给"unemptyGroupCount"赋值
 */
- (void)setUnemptyGroupCount:(NSInteger)unemptyGroupCount {
    if(_unemptyGroupCount == unemptyGroupCount) {
        return;
    }
    NSNumber *num = [self.dispatcher valueForKeyPath:@"validModeGroupCount"];
    NSInteger validModeGroupCount = num.integerValue;
    if (_unemptyGroupCount == 0 && unemptyGroupCount>0) {
        // Changes from 0 to non-0，The modeGroup start running.
        // 由0变非0, 该modeGroup开始运行
        validModeGroupCount++;
    }else if(_unemptyGroupCount >0 && unemptyGroupCount == 0){
        // Changes from non-0 to 0, The modeGroup stop running.
        // 由非0变为0，该modeGroup停止运行,
        validModeGroupCount--;
    }
    [self.dispatcher setValue:@(validModeGroupCount) forKeyPath:@"validModeGroupCount"];
    _unemptyGroupCount = unemptyGroupCount;
}
#pragma mark - state & task control
//|---------------------------------------------------------
/*
 * Add task to the group in modeGroup.
 * 向modeGroup的组中添加任务
 * @task: Task need to be added
 * @task: 需要添加的任务
 * @group: destination group
 * @group: 目标组
 */
- (void)modeGroupAddTask:(AKTAsyncTask *)task toGroup:(NSMutableArray *)group {
    if (group.count == 0) {
        self.unemptyGroupCount++;
    }
    [group addObject:task];
}

/*
 * Remove task from the group in modeGroup.
 * 从modeGroup的组中移除任务
 * @task: Task need to be removed
 * @task: 需要移除的任务
 * @group: destination group
 * @group: 目标组
 */
- (void)modeGroupRemoveTask:(AKTAsyncTask *)task fromGroup:(NSMutableArray *)group {
    if ([group containsObject:task] == NO) {
        return;
    }
    [group removeObject:task];
    if (group.count == 0) {
        self.unemptyGroupCount--;
    }
}

/*
 * Remove all of tasks from the group in modeGroup.
 * 从modeGroup的组中移除所有任务
 * @group: destination group
 * @group: 目标组
 */
- (void)modeGroupRemoveTasksAllfromGroup:(NSMutableArray *)group {
    if (group.count<=0) {
        return;
    }
    [group removeAllObjects];
    self.unemptyGroupCount--;
}
@end

/*
 * Asynchronous task dispatcher
 * 异步任务调度器
 */
@interface AKTAsyncDispatcher ()
//> The task is not started
//> 没有开始执行的任务
@property (strong, nonatomic) NSMutableArray       *taskStack;
//> "resultBlock"s we unperformed in suspended state.
//> 由于暂停而没有输出的结果
@property (strong, nonatomic) NSMutableArray       *suspendResultStack;
//> A task added in suspended state.
//> 暂停时添加的任务
@property (strong, nonatomic) void(^suspendTask)(AKTAsyncTaskInfo *taskInfo);
//> According to the holder of the task, We group the task being performed to modeGroup. According to the task type task modeGrpup divided tasks into three groups
//> 将任务依据任务的持有者进行分组到modeGroup, modeGroup根据任务类型将任务又分成三组
@property (strong, nonatomic) NSMutableDictionary  *taskModeGroups;
//> Effective number of modeGroups
//> 有效的modeGroup的数量
@property (assign, nonatomic) NSInteger            validModeGroupCount;
//> Single concurrent semaphore for latest task mode.
//> 最新任务模式下用于限制单并发信号量
@property (strong, nonatomic) dispatch_semaphore_t semaphoreForLatestMode;
//> Semaphore for limiting the maximum count of "taskStack"
//> 任务堆栈积压数量限制信号量
@property (assign, nonatomic) NSInteger concurrentLimit;
//> Whether have backlog tasks. When the not started tasks exceed a certain amount the dispatcher will into the state of backlog.
//> 任务栈是否处于积压状态，当未开始任务超过一定数量时进入积压状态
@property (assign, nonatomic) BOOL                 backlogStatus;
//> A queue for dispatcher
//> 用于任务调度的队列
@property (strong, nonatomic) dispatch_queue_t     dispatcherQueue;
//> A queue for assigning tasks
//> 用于任务分配队列
@property (strong, nonatomic) dispatch_queue_t     assignQueue;
//> The current dispatcher is in a canceled state, unable to add a new task on this state.
//> 当前调度器是否处于取消任务状态，取消状态是无法添加新任务的
@property (assign, nonatomic) BOOL                 cancel;
//> The current dispatcher is in a suspended state
//> 当前调度器是否处于暂停任务状态
@property (assign, nonatomic) BOOL                 suspend;
//> It will be invoked after the completion of all tasks canceled.
//> 在取消完所有任务之后会调用
@property (strong, nonatomic) void (^canceledBlock)();
@end
@implementation AKTAsyncDispatcher
@synthesize status = _status;
#pragma mark - life cycle
//|---------------------------------------------------------
/*
 * Init
 * @name: The name of the dispatcher
 * @name: 调度器名称
 */
- (instancetype)initWithName:(NSString *)name {
    self = [super init];
    if (self) {
        // initialize perperties
        _status                             = AKTAsyncDispatcherStatus_Idle;
        self.taskStack                      = [NSMutableArray array];
        self.suspendResultStack             = [NSMutableArray array];
        self.taskModeGroups                 = [NSMutableDictionary dictionary];
        self.semaphoreForLatestMode         = dispatch_semaphore_create(1);
        _concurrentLimit                    = AD_ConcurrentLimit_Global;
        self.dispatcherQueue                = dispatch_queue_create(name.UTF8String, NULL);
        self.assignQueue = dispatch_queue_create(@"com.aktAsyncDispatcher.taskAssign".UTF8String, NULL);
    }
    return self;
}
#pragma mark - property settings
//|---------------------------------------------------------
/*
 * Setter method of "validModeGroupCount"
 * "validModeGroupCount"的setter方法
 */
- (void)setValidModeGroupCount:(NSInteger)validModeGroupCount {
    if (_validModeGroupCount==0 && validModeGroupCount>0) {
        // There are tasks running, Running state.
        // 有任务进行，运行状态
        _status = AKTAsyncDispatcherStatus_Running;
        //        mAKT_Log(@"Dispatcher run");
    }else if(_validModeGroupCount>0 && validModeGroupCount==0) {
        // On idle status
        // 处于空闲状态
        _status = AKTAsyncDispatcherStatus_Idle;
        //        mAKT_Log(@"Dispatcher idel");
        // If the external command to cancel the tasks, then all tasks are canceled at this time.
        // 如果外部取消所有任务，在此时任务全部取消完毕
        if (self.cancel) {
            self.cancel = NO;
            if (self.canceledBlock) {
                void (^block)() = self.canceledBlock;
                self.canceledBlock = nil;
                dispatch_async(dispatch_get_main_queue(), ^{
                    block();
                });
            }
        }
    }
    _validModeGroupCount = validModeGroupCount;
}

/*
 * The number of unperformed tasks.
 * 未执行任务数
 */
- (NSInteger)restTast {
    return self.taskStack.count;
}

/*
 * Getter method of "status"
 * "status"get方法
 */
- (AKTAsyncDispatcherStatus)status {
    if (self.suspend) {
        return AKTAsyncDispatcherStatus_Suspend;
    }else{
        return _status;
    }
}

- (void)setConcurrentLimit:(NSInteger)concurrentLimit {
    NSInteger oldLimit = _concurrentLimit;
    _concurrentLimit = concurrentLimit;
//    NSLog(@"%ld",concurrentLimit);
    // 限制数增加时，自动开始新的任务
    if (concurrentLimit>oldLimit) {
        [self runTask:self.taskStack.firstObject];
    }
}
#pragma mark - dispatcher configuration
//|---------------------------------------------------------
/*
 * Suspend
 * 暂停任务
 * @complete: Pause task completely
 * @complete: 完全暂停任务
 * @note Pause occurs, the current task to continue, but "AKTAsyncTask" will not perform "resultBlock" to return data. When the mission resumed, continues the last unfinished data return and start a new task.
 * There are two different approaches when you add a new task in the suspended state：
 * 1.If the added task mode is "AKTAsyncTaskMode_LatestTask", The task will replace last one which is not performed.
 * 2.Other task mode, the new task will be abandoned.
 * @备注 发生暂停时，当前任务继续执行，但是"AKTAsyncTask"不会执行"resultBlock"返回数据，如果任务恢复，则继续上一次未完成的数据返回并开始新的任务。
 * 在暂停状态下添加新任务时有两种不同的处理方式：
 * 1.如果被添加的任务模式是"AKTAsyncTaskMode_LatestTask", 则该任务将会替换任务上一个未执行任务。
 * 2.其他任务模式下，新任务将被抛弃。
 */
- (void)suspend:(void(^)())complete {
    dispatch_async(self.assignQueue, ^{
        if (self.cancel) {
            mAKT_Log(@"on cancl want to suspend!");
            [self cancelWithComplete:^{
                [self suspend:complete];
            }];
            return;
        }
        if(self.suspend){
            dispatch_async(dispatch_get_main_queue(), ^{
                if (complete) {
                    complete();
                }
            });
            return;
        }
        self.suspend = YES;
        [self.suspendResultStack removeAllObjects];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (complete) {
                complete();
            }
        });
    });
}

/*
 * Resume unfinished tasks
 * 恢复未完成的任务
 */
- (void)resume:(void(^)())complete {
    dispatch_async(self.assignQueue, ^{
        if (self.suspend) {
            for (int i=0; i<self.suspendResultStack.count/2; i++) {
                void(^block)(id) = self.suspendResultStack[i*2];
                id result = [self.suspendResultStack[i*2+1] unsignedLongValue] == ~0ul? nil:self.suspendResultStack[i*2+1];
                block(result);
            }
            self.suspend = NO;
            [self addTask:self.suspendTask];
            self.suspendTask = nil;
            dispatch_async(dispatch_get_main_queue(), ^{
                if (complete) {
                    complete();
                }
            });
            return;
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            if (complete) {
                complete();
            }
        });
    });
}

/*
 * Cancle task
 * 取消任务
 * @complete: When canceled the tasks successfully the block will be invoked.
 * @complete: 成功地取消了任务时，block将被调用
 * @note: Stop the new task, finish the execution of the current task, not occur data return, but dispatcher will initiate a callback for canceling tasks successfully.
 * @备注：停止新任务，执行完当前任务，不发生数据返回，调度器发起一个取消成功回调
 */
- (void)cancelWithComplete:(void(^)())complete {
    dispatch_async(self.assignQueue, ^{
        switch (self.status) {
            case AKTAsyncDispatcherStatus_Idle:
            {
                self.cancel = NO;
                if (complete) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        complete();
                    });
                }
                return;
            }
                break;
            case AKTAsyncDispatcherStatus_Suspend:
            {
                self.cancel = YES;
                [self.suspendResultStack removeAllObjects];
                self.suspendTask = nil;
                [self resume:^{
                    [self cancelWithComplete:complete];
                }];
            }
                break;
            case AKTAsyncDispatcherStatus_Running:
            {
                self.cancel = YES;
                self.canceledBlock = complete;
            }
                break;
            default:
                break;
        }
    });
}

/*
 * Add task into dispatcher
 * 添加任务
 * @addTask: The info of the task which will be add into dispatcher.
 * @addTask：即将被添加到调度器中的任务的信息
 */
- (void)addTask:(void(^)(AKTAsyncTaskInfo *taskInfo))addTask {
    if (addTask == nil) {
        return;
    }
    dispatch_async(self.assignQueue, ^{
        // Dispatcher add task
        // 添加任务
        if (self.status == AKTAsyncDispatcherStatus_Suspend) {
            // Running in the same thread with method:"resume" to ensure that the variable is not modified during a visit.
            // 与method:"resume"操作在同一个线程中执行，保证变量在访问时不会被修改
            AKTAsyncTaskInfo *info = [AKTAsyncTaskInfo new];
            if (addTask) {
                addTask(info);
                // 1.If the added task mode is "AKTAsyncTaskMode_LatestTask", The task will replace last one which is not performed.
                // 2.Other task mode, the new task will be abandoned.
                // 1.如果被添加的任务模式是"AKTAsyncTaskMode_LatestTask", 则该任务将会替换任务上一个未执行任务。
                // 2.其他任务模式下，新任务将被抛弃。
                if (info.taskMode == AKTAsyncTaskMode_LatestTask) {
                    self.suspendTask = addTask;
                }
            }
        }else{
            [self dispatcherAddTask:addTask];
        }
    });
}

#pragma mark - special dispatchers
//|---------------------------------------------------------
/*
 * Dispatcher for layout calculation
 * 布局计算用途的调度器
 * @note: It's a singleton instance. The tasks you add will be performed in global queue. So don't add UI related tasks.
 * @备注: 单例对象，所有的任务将在全局队列中执行，请不要添加UI相关的任务
 */
void aktDispatcher_layoutCalculation_add(void(^addTask)(AKTAsyncTaskInfo *taskInfo)) {
    [aktDispatcher_get_layoutCalculation() addTask:addTask];
}

/*
 * Get layout calculation dispatcher.
 * 获取布局计算调度器
 */
AKTAsyncDispatcher *aktDispatcher_get_layoutCalculation() {
    // If you have not yet created create a instance
    // 如果尚未创建则创建一个实例
    static AKTAsyncDispatcher *layoutCalcutaltionDispatcher = nil;
    @synchronized(AKTAsyncDispatcher.class) {
        if (layoutCalcutaltionDispatcher == nil) {
            layoutCalcutaltionDispatcher = [[AKTAsyncDispatcher alloc]initWithName:@"com.aktAsyncDispatcher.layoutCalculation"];
        }
        layoutCalcutaltionDispatcher.concurrentLimit = AD_ConcurrentLimit_Layout;
    }
    return layoutCalcutaltionDispatcher;
}

/*
 * General purpose dispatcher
 * 普通用途的调度器
 * @note: It's a singleton instance
 * @备注: 单例对象
 */
void aktDispatcher_global_add(void(^addTask)(AKTAsyncTaskInfo *taskInfo)) {
    [aktDispatcher_get_global() addTask:addTask];
}

/*
 * Get global dispatcher.
 * 获取全局调度器
 */
AKTAsyncDispatcher *aktDispatcher_get_global() {
    // If you have not yet created create a instance
    // 如果尚未创建则创建一个实例
    static AKTAsyncDispatcher *globalDispatcher = nil;
    @synchronized(AKTAsyncDispatcher.class) {
        if (globalDispatcher == nil) {
            globalDispatcher = [[AKTAsyncDispatcher alloc]initWithName:@"com.aktAsyncDispatcher.global"];
        }
    }
    return globalDispatcher;
}
#pragma mark - assigning & dispatching tasks
//|---------------------------------------------------------
/*
 * Add task to dispatcher
 * 添加任务到调度器
 * @addTask: We can set task info in the block
 * @addTask: 可以在这个block里设置任务的信息
 */
- (void)dispatcherAddTask:(void(^)(AKTAsyncTaskInfo *taskInfo))addTask {
    @autoreleasepool {
        if (self.cancel == YES) {
            mAKT_Log(@"The dispatcher is on canceling!");
            return;
        }
        if (addTask == nil) {
            mAKT_Log(@"The task info was nil!");
            return;
        }
        AKTAsyncTaskInfo *info = [AKTAsyncTaskInfo new];
        addTask(info);
        AKTAsyncTask *task = [[AKTAsyncTask alloc]initWithInfo:info];
        if (task == nil) {
            mAKT_Log(@"The task is invalide because the operationBlock you seted was nil!");
            return;
        }
        // Assign tasks to different groups
        // 分配任务到不同的组
        BOOL assigned = [self assignToGroupWithTask:task];
        if (assigned == NO) {
            return ;
        }
        [self.taskStack addObject:task];
        // Start tasks
        // 开始执行任务
        // 如果并发限制大于0，则可以立即开始任务，否则交由调度器自动开始任务
        if (self.concurrentLimit > 0) {
            [self runTask:self.taskStack.firstObject];
        }
    }
}

- (void)runTask:(AKTAsyncTask *)task {
    if (!task) {
        return;
    }
    // Under the latest mission mode, single-task concurrent manner
    // 最新任务模式下，任务以单并发方式执行
    // The task had entered the execute queue. The task remove from "taskStack"
    // 任务进入执行队列, 任务从未执行列表中移除
    [self taskStackRemoveTask:task];
    self.concurrentLimit--;
    if (task.taskInfo.taskMode == AKTAsyncTaskMode_LatestTask) {
        dispatch_async(dispatch_get_global_queue(task.taskInfo.priority, 0), ^{
            dispatch_semaphore_wait(self.semaphoreForLatestMode, DISPATCH_TIME_FOREVER);
            [self performTask:task];
            dispatch_semaphore_signal(self.semaphoreForLatestMode);
        });
    }else{
        // The task had entered the execute queue. The task remove from "taskStack"
        // 任务进入执行队列, 任务从未执行列表中移除
        dispatch_async(dispatch_get_global_queue(task.taskInfo.priority, 0), ^{
            [self performTask:task];
        });
    }
}
/*
 * Assign tasks to different groups
 * 分配任务到不同的组
 * @task: AKTAsyncTask
 * @task: 任务
 */
- (BOOL)assignToGroupWithTask:(nonnull AKTAsyncTask *)task {
    @autoreleasepool {
        if (task.taskInfo.taskOperation == nil) {
            mAKT_Log(@"The operationBlock you added was nil. Coundn't assign task!");
            return NO;
        }
        //        va_start(v, task);
        // Getting the modeGroup according to the type of the owner.
        // 根据所有者类型获取modeGroup
        AKTAsyncTaskModeGroup *modeGroup;
        modeGroup = self.taskModeGroups[task.taskInfo.ownerKey];
        if (modeGroup == nil) {
            modeGroup = [AKTAsyncTaskModeGroup new];
            [self.taskModeGroups setObject:modeGroup forKey:task.taskInfo.ownerKey];
            modeGroup.ownerKey = task.taskInfo.ownerKey;
        }
        task.modeGroup = modeGroup;
        modeGroup.dispatcher = self;
        // Classification
        // 分组
        switch (task.taskInfo.taskMode) {
            case AKTAsyncTaskMode_Default:
            {
                // Add to the default mode group
                // 添加到默认模式组
                [modeGroup modeGroupAddTask:task toGroup:modeGroup.defaultGroup];
                task.modeGroup_OwnerGroup = modeGroup.defaultGroup;
                break;
            }
            case AKTAsyncTaskMode_Sequential:
            {
                // Add to the sequential mode group
                // 添加到有序模式组
                [modeGroup modeGroupAddTask:task toGroup:modeGroup.sequentialGroup];
                task.modeGroup_OwnerGroup = modeGroup.sequentialGroup;
                break;
            }
            case AKTAsyncTaskMode_LatestTask:
            {
                // Add to the latestTask mode group
                // 添加到最新任务模式组
                [modeGroup modeGroupAddTask:task toGroup:modeGroup.latestTaskGroup];
                task.modeGroup_OwnerGroup = modeGroup.latestTaskGroup;
                break;
            }
            default:
                break;
        }
        return YES;
    }
}

/*
 * Perform tasks. Tasks running in the limited global queue. The limit is the maximum number of concurrent.
 * 执行任务, 任务在有限制的全局队列中运行, 我们限制了线程的并发数
 * @task：task can't be nil
 * @task：任务不可为空
 */
- (void)performTask:(nonnull AKTAsyncTask *)task {
    @autoreleasepool {
        __block AKTAsyncTask *newTask = task;
        // Overdue tasks not performed in the latest mode
        // 在最新模式下不执行过期的任务
        __block BOOL b = NO;
        dispatch_sync(self.assignQueue, ^{
            if (newTask.taskInfo.taskMode == AKTAsyncTaskMode_LatestTask) {
                NSInteger count = newTask.modeGroup_OwnerGroup.count;
                if (count>1) {
                    // 删除旧任务的执行block
                    newTask.taskInfo.taskOperation = nil;
                    newTask.taskInfo.taskResult    = nil;
                }
            }
            // In the event of cancellation task
            // 如果发生了任务取消
            if (self.cancel == YES) {
                // 恢复并发限制计数
                self.concurrentLimit++;
                [newTask.modeGroup modeGroupRemoveTask:newTask fromGroup:newTask.modeGroup_OwnerGroup];
                b = YES;
                return;
            }
        });
        if (b) {
            return;
        }
        
        // Run the task and mark complete
        // 运行任务并标记完成
        if (newTask.taskInfo.taskOperation) {
            newTask.result = newTask.taskInfo.taskOperation();
        }
        newTask.runOver = YES;
        dispatch_async(self.assignQueue, ^{
            // Output the result.
            // 输出结果
            switch (newTask.taskInfo.taskMode) {
                    // The default task mode is executed asynchronously, disordered return data
                    // 默认任务模式异步执行，无序返回数据
                case AKTAsyncTaskMode_Default:
                {
                    [newTask.modeGroup modeGroupRemoveTask:newTask fromGroup:newTask.modeGroup_OwnerGroup];
                    if (self.cancel == NO) {
                        [self performResultBlock:newTask.taskInfo.taskResult result:newTask.result];
                    }
                    // 恢复并发限制计数
                    self.concurrentLimit++;
                    break;
                }
                    // Asynchronous execution, but the results outputed is ordered.
                    // 异步执行，但结果有序输出
                case AKTAsyncTaskMode_Sequential:
                {
                    // 恢复并发限制计数
                    self.concurrentLimit++;
                    [self sequentialModeOutputResultWithTask:newTask];
                    break;
                }
                    // The latest task will be priority to perform, old task will be abandoned.
                    // 最新的任务将被优先执行，旧的任务将被抛弃
                case AKTAsyncTaskMode_LatestTask:
                {
                    [newTask.modeGroup modeGroupRemoveTask:newTask fromGroup:newTask.modeGroup_OwnerGroup];
                    if (self.cancel == NO) {
                        [self performResultBlock:newTask.taskInfo.taskResult result:newTask.result];
                    }
                    // 恢复并发限制计数
                    self.concurrentLimit++;
                    break;
                }
                default:
                    break;
            }
        });
    }
}

/*
 * Perform "resultBlock", If dispatcher is in suspended state the "resutBlock" will be performed after the dispatcher is resumed.
 * 运行"resultBlock", 如果调度器处于暂停模式，等到调度器恢复再输出结果.
 * @resultBlock: "resultBlcok" for a task
 * @resultBlock: 任务的"resultBlock"， When storing we replace nil with "@(~0ul)".
 * @result: The result will be output. if result is equal to nil we'll use "@(~0ul)"
 * @result: 将要被输出的结果, 如果result == nil则用@(~0ul)存储
 */
- (void)performResultBlock:(void(^)(id))resultBlock result:(id)result {
    if (resultBlock) {
        if (self.suspend == YES) {
            [self.suspendResultStack addObject:resultBlock];
            [self.suspendResultStack addObject:result? result:@(~0ul)];
            return ;
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            resultBlock(result);
        });
    }
}
/*
 * Results output on sequential mode
 * 序列化输出模式下的结果输出
 */
- (void)sequentialModeOutputResultWithTask:(AKTAsyncTask *)task {
    if (task.modeGroup_OwnerGroup == nil) {
        // Tasks on sequential and default mode may have already been executed: for example: tasks on sequential mode, there are A / B / C three tasks. "A" is in the process of outputing the final result, "B" is also end executing and output the final result, Duo to all tasks's output operations are performed in "assignQueue", so "B"'s output operation should wait "A" end executing output operation. But A will automatically detect whether the next task is on complete state which means that the task end executing "operationBlock" but not executing "resultBlock", if on complete state "A" will perform the "resultBlock" of the next task("B"), wait for the completion of all operations of "A", "B" start "resultBlock", But the operation is redundant, as it has been executed, So at this time to exit, do nothing.
        // 序列化和默认模式下的任务有可能已经被执行过：例如：序列化模式任务中,有A/B/C三个任务。A在执行最后输出任务过程中，B也执行完任务并输出，由于所有输出任务都在assignQueue中执行，所以要等A执行完才能执行。但是A会自动检测下一个任务是否是完成状态，如果是完成状态则执行下一个任务的输出操作，等待A的所有任务执行完毕，B开始执行输出任务，此时B的输出任务是多余的，因为已经被执行过了，此时B已经不在任务组中，所以此时直接退出，不执行任何操作。
        return;
    }
    if (task.modeGroup_OwnerGroup.firstObject == task){
        if (self.cancel == NO) {
            [self performResultBlock:task.taskInfo.taskResult result:task.result];
        }
        NSMutableArray *arr = task.modeGroup_OwnerGroup;
        [task.modeGroup modeGroupRemoveTask:task fromGroup:task.modeGroup_OwnerGroup];
        task.modeGroup_OwnerGroup = nil;
        task = arr.firstObject;
        if (task && task.runOver == YES) {
            [self sequentialModeOutputResultWithTask:task];
        }
    }
}
#pragma mark - state control for dispatcher
//|---------------------------------------------------------
/*
 * Remove the task has started.
 * 移除已开始的任务
 */
- (void)taskStackRemoveTask:(AKTAsyncTask *)task {
    [self.taskStack removeObject:task];
}
@end
