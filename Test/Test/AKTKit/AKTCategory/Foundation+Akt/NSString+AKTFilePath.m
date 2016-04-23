//
//  NSString+AKTFilePath.m
//  Export
//
//  Created by YaHaoo on 16/1/21.
//  Copyright © 2016年 CoolHear. All rights reserved.
//

#import "NSString+AKTFilePath.h"
#import "CommonCrypto/CommonDigest.h"

@implementation NSString (AKTFilePath)
/*
 * Return corresponding absolute path according to path type
 */
+ (NSString *)aktFilePathWithType:(AKTFilePathRelativePathType)relativePathType
{
    NSString *path;
    switch (relativePathType) {
        case AKTFilePathRelativePathType_Documents:
            path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES).firstObject;
            break;
        case AKTFilePathRelativePathType_Home:
            path = NSHomeDirectory();
            break;
        case AKTFilePathRelativePathType_Library:
            path = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory,NSUserDomainMask, YES).firstObject;
            break;
        case AKTFilePathRelativePathType_Library_Caches:
            path = NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask, YES).firstObject;
            break;
        case AKTFilePathRelativePathType_Library_Preferences:
            path = [NSString aktFilePathWithType:AKTFilePathRelativePathType_Library].addPath(@"Preferences");
            break;
        case AKTFilePathRelativePathType_MainBundle:
            path = [[NSBundle mainBundle] bundlePath];
            break;
        case AKTFilePathRelativePathType_Tmp:
            path = NSTemporaryDirectory();
            break;
        default:
            break;
    }
    return path;
}

/*
 * Add path with path component
 */
- (NSString *(^)(NSString *))addPath
{
    return ^NSString *(NSString *addPath) {
        return [self stringByAppendingString:[NSString stringWithFormat:@"/%@",addPath]];
    };
}

/*
 * Appent string
 */
- (NSString *(^)(NSObject *objStr))add
{
    return ^NSString *(NSObject *objStr) {
        return [self stringByAppendingString:[NSString stringWithFormat:@"%@",objStr.description]];
    };
}

/*
 * String match format
 * 字符串是否匹配格式
 */
- (BOOL)predicateWithFormat:(NSString *)format {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", format];
    return [predicate evaluateWithObject:self];
}

/*
 * MD5 stirng.
 */
+(NSString *)md5:(NSString *)inPutText {
    const char *cStr = [inPutText UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(cStr, (CC_LONG)strlen(cStr), result);
    return [[NSString stringWithFormat:@"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
             result[0], result[1], result[2], result[3],
             result[4], result[5], result[6], result[7],
             result[8], result[9], result[10], result[11],
             result[12], result[13], result[14], result[15]
             ] lowercaseString];
}
@end
