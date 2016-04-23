//
//  NSFileManager+AKTFileManager.h
//  Export
//
//  Created by YaHaoo on 16/1/21.
//  Copyright © 2016年 CoolHear. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, AKTFilePathCreateType) {
    AKTFilePathCreateType_BrandNew,
    AKTFilePathCreateType_UseExistingIfNeeded
};

@interface NSFileManager (AKTFileManager)
/*
 * Create file path from type (if the path exist we'll remove it and create new or just use the old, it depends on the type)
 */
+ (NSString *)aktCreateDirectoryAtPath:(NSString *)path withType:(AKTFilePathCreateType)type error:(NSError **)error;

/*
 * Create file from type (if the path exist we'll remove it and create new or just use the old, it depends on the type)
 */
+ (NSString *)aktCreateFileAtPath:(NSString *)path withType:(AKTFilePathCreateType)type error:(NSError **)error;
@end
