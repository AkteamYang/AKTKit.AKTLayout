//
//  AKTAsyncDispatch.h
//  Pursue
//
//  Created by YaHaoo on 16/3/26.
//  Copyright © 2016年 YaHaoo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AKTAsyncTask.h"

//--------------------Structs statement, globle variables...--------------------
typedef NS_ENUM(NSInteger, AKTAsyncDispatcherStatus) {
    // Idle
    // 空闲状态，无任务
    AKTAsyncDispatcherStatus_Idle = 0,
    // Has tasks but pause
    // 有任务但是暂停中
    AKTAsyncDispatcherStatus_Suspend,
    // Running
    // 正在运行
    AKTAsyncDispatcherStatus_Running
};
//-------------------- E.n.d -------------------->Structs statement, globle variables...

@interface AKTAsyncDispatcher : NSObject
//> The rest of the tast. Don't include unperformed tasks
//> 未执行的任务数量，不包括正在执行的任务
@property (readonly, assign, nonatomic) NSInteger restTast;
//> Status of tast dispatcher
//> 任务调度器状态
@property (readonly, assign, nonatomic) AKTAsyncDispatcherStatus status;

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
- (void)suspend:(void(^)())complete;

/*
 * Resume unfinished tasks
 * 恢复未完成的任务
 */
- (void)resume:(void(^)())complete;

/*
 * Cancle task
 * 取消任务
 * @complete: When canceled the tasks successfully the block will be invoked.
 * @complete: 成功地取消了任务时，block将被调用
 * @note: Stop the new task, finish the execution of the current task, not occur data return, but dispatcher will initiate a callback for canceling tasks successfully.
 * @备注：停止新任务，执行完当前任务，不发生数据返回，调度器发起一个取消成功回调
 */
- (void)cancelWithComplete:(void(^)())complete;

/*
 * Add task into dispatcher
 * 添加任务
 * @addTask: The info of the task which will be add into dispatcher.
 * @addTask：即将被添加到调度器中的任务的信息
 */
- (void)addTask:(void(^)(AKTAsyncTaskInfo *taskInfo))addTask;

#pragma mark - create dispatchers
//|---------------------------------------------------------
/*
 * Get layout calculation dispatcher.
 * 获取布局计算调度器
 */
AKTAsyncDispatcher *aktDispatcher_get_layoutCalculation();

/*
 * Dispatcher for layout calculation
 * 布局计算用途的调度器
 * @note: It's a singleton instance. The tasks you add will be performed in global queue. So don't add UI related tasks.
 * @备注: 单例对象，所有的任务将在全局队列中执行，请不要添加UI相关的任务
 */
void aktDispatcher_layoutCalculation_add(void(^addTask)(AKTAsyncTaskInfo *taskInfo));

/*
 * Get global dispatcher.
 * 获取全局调度器
 */
AKTAsyncDispatcher *aktDispatcher_get_global();

/*
 * General purpose dispatcher
 * 普通用途的调度器
 * @note: It's a singleton instance
 * @备注: 单例对象
 */
void aktDispatcher_global_add(void(^addTask)(AKTAsyncTaskInfo *taskInfo));
@end
