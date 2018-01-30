//
//  DPImageCacheComparisonTable.m
//  DPImageCacheManager
//
//  Created by Andrew on 2018/1/30.
//  Copyright © 2018年 Andrew. All rights reserved.
//

#import "DPImageCacheComparisonTable.h"

//plist文件名称
#define CACHE_IMAGE_PLIST_NAME @"DPImageCacheComparisonTable"

@implementation DPImageCacheComparisonTable

+ (void)saveImageCacheComparisonImage_id:(NSString *)image_id identifier:(NSString *)identifier
{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        //文件存储
        NSMutableArray *locationArr = [NSMutableArray arrayWithContentsOfFile:[DPImageCacheComparisonTable imageCacheComparisonPlistTablePathWithIdentifier:identifier]];
        [locationArr addObject:[NSString stringWithFormat:@"%@",image_id]];
        [locationArr writeToFile:[DPImageCacheComparisonTable imageCacheComparisonPlistTablePathWithIdentifier:identifier] atomically:YES];
    });
}

+ (NSArray *)getImageCacheComparisonArrayWithIdentifier:(NSString *)identifier
{
    return [NSArray arrayWithContentsOfFile:[DPImageCacheComparisonTable imageCacheComparisonPlistTablePathWithIdentifier:identifier]];
}

+ (NSString *)imageCacheComparisonPlistTablePathWithIdentifier:(NSString *)identifier
{
    //plist文件路径
    NSString *plistTablePath = [[DPImageCacheUtils documentSandboxPath] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@_%@.plist",CACHE_IMAGE_PLIST_NAME, identifier]];
    
    NSFileManager *fileManger = [NSFileManager defaultManager];
    if (![fileManger fileExistsAtPath:plistTablePath]) {
        if (![fileManger fileExistsAtPath:[DPImageCacheUtils documentSandboxPath]]) {//如果文件路径不存在
            [fileManger createDirectoryAtPath:[DPImageCacheUtils documentSandboxPath] withIntermediateDirectories:YES attributes:nil error:nil];
        }
        //写入新文件
        [@[] writeToFile:plistTablePath atomically:YES];
    }
    return plistTablePath;
}

@end
