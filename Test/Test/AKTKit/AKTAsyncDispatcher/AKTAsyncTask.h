//
//  AKTAsyncTask.h
//  Pursue
//
//  Created by YaHaoo on 16/3/26.
//  Copyright © 2016年 YaHaoo. All rights reserved.
//

#import <Foundation/Foundation.h>
@class AKTAsyncTaskModeGroup;

//--------------------Structs statement, globle variables...--------------------
typedef NS_ENUM(NSInteger, AKTAsyncTaskMode) {
    // Asynchronous execution and disorderly data return.
    // 异步执行，数据返回无序
    AKTAsyncTaskMode_Default,
    // Asynchronous execution, but the results outputed is ordered. The mode applies to a large number of ordered tasks and have no dependencies between them. Such as: streaming media transcoding and preservation of data.
    // 异步执行，但结果有序输出，适用于大量有序任务，并且任务间无依赖关系例如：流媒体的数据转码与保存
    AKTAsyncTaskMode_Sequential,
    // The latest task will be priority to perform, old task will be abandoned.
    // 最新的任务将被优先执行，旧的任务将被抛弃
    AKTAsyncTaskMode_LatestTask
};
typedef NS_ENUM(NSInteger, AKTAsyncTaskPriority) {
    // The priority for task performing will be gained from system by dispatcher.
    // 调度器将要从系统中获得用于执行任务的优先级
    AKTAsyncTaskPriority_High       = DISPATCH_QUEUE_PRIORITY_HIGH,
    AKTAsyncTaskPriority_Default    = DISPATCH_QUEUE_PRIORITY_DEFAULT,
    AKTAsyncTaskPriority_Low        = DISPATCH_QUEUE_PRIORITY_LOW,
    AKTAsyncTaskPriority_Background = DISPATCH_QUEUE_PRIORITY_BACKGROUND INT16_MIN
};
//-------------------- E.n.d -------------------->Structs statement, globle variables...

/*
 * Used to temporarily store task information
 * 用来临时存储任务信息
 */
@interface AKTAsyncTaskInfo : NSObject
//> Owner of the task, It can be a view/label/string... Tasks have the same owner will be assigned to a group. If not set, or the system assigns the default holder.
//> 任务的持有者，可以是view/label/string...有相同持有者的任务将会被分配到同一个组，如果不设置，则系统设置默认持有者
//> @owner: Owner of the task
//> @owner: 任务的持有者
@property (weak, nonatomic) id taskOwner;
//> 如果设置了"taskOwner"该属性将被自动设置
@property (strong, nonatomic) NSString *ownerKey;
//> Task mode will affect the task execution strategy. Details please refer to the enumeration information of "AKTAsyncTaskMode"
//> 任务模式将影响到任务执行的策略, 详情请参考枚举信息: "AKTAsyncTaskMode"
//> @mode: Task mode
//> @mode：任务模式
@property (assign, nonatomic) AKTAsyncTaskMode taskMode;
// Thread priority for task execution
// 任务执行的线程优先级
@property (assign, nonatomic) AKTAsyncTaskPriority priority;
//> Task for performing
//> 要执行的任务
//> Task to deal with things, Insert your task handling code here！
//> 任务要处理的事情,插入你的任务处理代码
//> @operationBlock：Block for handling, blocks can be concurrent, The block has a id return which will be use in "resultBlock". Do not we get back the results directly but get the results in "resultBlock" which purpose is to ensure that in the case of concurrent the results we get back is ordered. Of course, the premise is that you have transferred the mission mode to "AKTAsyncTaskMode_Sequential". The results we get directly are unordered. If the task is in other mode you can ignore  the process of backing results from "resultBlock".
//> @operationBlock：处理代码块，block是并发的, block将返回一个结果，该结果将在"resultBlock"里面被用到，我们不直接取回结果而是在"resultBlock"里面取回结果的目的就是为了保证，在并发的情况下，我们取回的到的结果是有序的,直接取回的结果是无序的,当然前提是你已经将任务模式调到"AKTAsyncTaskMode_Sequential"。如果是其他模式则可以忽略回传结果和从"resultBlock"这一过程。
//> @id: Result for handling
//> @id: 处理结果
@property (strong, nonatomic) id(^taskOperation)();
//> Result of performing a task
//> 任务执行的结果
//> After return the results you can retrieve the ordered result here
//> 在回传结果后你可以从这里取回有序的结果
//> @resultBlock：Block for handling result. Try not to put time-consuming code into results outputing block, or will low performance.
//> @resultBlock：结果处理代码块，结果处理代码块中尽量不要放耗时的代码，不然将会拉低性能表现。
//> @(id result): Data returned by "operationBlock".
//> @(id result): 由"operationBlock"返回的数据。
@property (strong, nonatomic) void(^taskResult)(id result);
@end

/*
 * AKTAsyncTask
 */
@interface AKTAsyncTask : NSObject
@property (readonly, strong, nonatomic) AKTAsyncTaskInfo *taskInfo;
//> Results after the task runs
//> 任务运行的结果
@property (strong, nonatomic) id result;
//> The reference of the group that the task was assigned to.
//> 任务被分配到的那个组的引用
@property (weak, nonatomic) NSMutableArray *modeGroup_OwnerGroup;
//> The reference of the group that the task was assigned to.
//> 任务被分配到的那个modeGroup的引用
@property (weak, nonatomic) AKTAsyncTaskModeGroup *modeGroup;
//> The task has been executed but not output result (Not perform resultBlock)
//> 任务已执行但是未输出结果(未运行resultBlock)
@property (assign, nonatomic) BOOL runOver;
#pragma mark - life cycle
//|---------------------------------------------------------
/*
 * New an task instance
 * @info: Configuration of tasks
 * @info: 任务的配置信息
 * @return：AKTAsyncTask instance
 * @return：AKTAsyncTask实例
 */
- (id)initWithInfo:(AKTAsyncTaskInfo *)info;
@end
