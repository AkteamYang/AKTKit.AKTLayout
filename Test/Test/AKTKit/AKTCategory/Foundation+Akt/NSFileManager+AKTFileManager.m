//
//  NSFileManager+AKTFileManager.m
//  Export
//
//  Created by YaHaoo on 16/1/21.
//  Copyright © 2016年 CoolHear. All rights reserved.
//

#import "NSFileManager+AKTFileManager.h"

@implementation NSFileManager (AKTFileManager)
/*
 * Create file path from type (if the path exist we'll remove it and create new or just use the old, it depends on the type)
 */
+ (NSString *)aktCreateDirectoryAtPath:(NSString *)path withType:(AKTFilePathCreateType)type error:(NSError **)error
{
    NSFileManager *manager = [NSFileManager  defaultManager];
    switch (type) {
        case AKTFilePathCreateType_BrandNew:
            [manager removeItemAtPath:path error:error];
            [manager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:error];
            break;
        case AKTFilePathCreateType_UseExistingIfNeeded:
        {
            BOOL dir;
            BOOL b = [manager fileExistsAtPath:path isDirectory:&dir];
            if (b == YES && dir == YES) {
                nil;
            }else{
                [manager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:error];
            }
            break;
        }
        default:
            break;
    }
    return path;
}

/*
 * Create file from type (if the path exist we'll remove it and create new or just use the old, it depends on the type)
 */
+ (NSString *)aktCreateFileAtPath:(NSString *)path withType:(AKTFilePathCreateType)type error:(NSError **)error
{
    NSFileManager *manager = [NSFileManager  defaultManager];
    switch (type) {
        case AKTFilePathCreateType_BrandNew:
            [manager removeItemAtPath:path error:error];
            [manager createFileAtPath:path contents:nil attributes:nil];
            break;
        case AKTFilePathCreateType_UseExistingIfNeeded:
        {
            BOOL dir;
            BOOL b = [manager fileExistsAtPath:path isDirectory:&dir];
            if (b == YES && dir == NO) {
                nil;
            }else{
                [manager createFileAtPath:path contents:nil attributes:nil];
            }
            break;
        }
        default:
            break;
    }
    return path;
}
@end
