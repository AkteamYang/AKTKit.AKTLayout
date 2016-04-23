//
//  AKTAsyncTask.m
//  Pursue
//
//  Created by YaHaoo on 16/3/26.
//  Copyright © 2016年 YaHaoo. All rights reserved.
//

#import "AKTAsyncTask.h"
#import "AKTPublic.h"

@implementation AKTAsyncTaskInfo
@synthesize ownerKey = _ownerKey;
#pragma mark - property settings
//|---------------------------------------------------------
- (void)setTaskOwner:(id)taskOwner {
    _taskOwner = taskOwner;
    if (_taskOwner) {
        _ownerKey = [NSString stringWithFormat:@"%@%p",[_taskOwner class],_taskOwner];
    }
}

- (void)setOwnerKey:(NSString *)ownerKey {
    if (self.taskOwner) {
        return;
    }
    _ownerKey = ownerKey;
}

- (NSString *)ownerKey {
    if (_ownerKey == nil) {
        _ownerKey = @"default";
    }
    return _ownerKey;
}
@end
@implementation AKTAsyncTask
#pragma mark - life cycle
//|---------------------------------------------------------
/*
 * New an task instance
 * @info: Configuration of tasks
 * @info: 任务的配置信息
 * @return：AKTAsyncTask instance
 * @return：AKTAsyncTask实例
 */
- (id)initWithInfo:(AKTAsyncTaskInfo *)info {
    self = [super init];
    if (self) {
        if (info.taskOperation == nil) {
            return nil;
        }
        _taskInfo = info;
    }
    return self;
}
@end
