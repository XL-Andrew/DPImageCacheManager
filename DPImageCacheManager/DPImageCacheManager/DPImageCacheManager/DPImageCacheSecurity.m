//
//  DPImageCacheSecurity.m
//  DPImageCacheManager
//
//  Created by Andrew on 2018/1/30.
//  Copyright © 2018年 Andrew. All rights reserved.
//

#import "DPImageCacheSecurity.h"

//记录全部图片信息，用于图片加载失败恢复
#define IMAGE_CACHE_SECRUITY_FILE_NAME @"DPImageCacheSecruityFile"

@implementation DPImageCacheSecurity

/*
 图片存入保险文件
 */
+ (void)saveImageCacheSecurityWithURL:(NSString *)imageURL orImage:(UIImage *)saveImage image_id:(NSString *)image_id
{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSMutableDictionary *cacheDic = [NSMutableDictionary dictionaryWithContentsOfFile:[self imageCacheSecruityFilePath]];
        if (imageURL.length > 0) {
            //存储图片url
            [cacheDic setObject:imageURL?:@"" forKey:image_id?:@""];
        } else {
            //压缩图片
            UIImage *compressedImage = [DPImageCacheUtils compressedWithOriginalImage:saveImage];
            //存储图片Base64
            NSString *saveImageBase64String = [NSString stringWithFormat:@"data:image/jpeg;base64,%@", [UIImagePNGRepresentation(compressedImage) base64EncodedStringWithOptions:0]];
            [cacheDic setObject:saveImageBase64String forKey:image_id?:@""];
        }
        
        //写入plist文件
        [cacheDic writeToFile:[self imageCacheSecruityFilePath] atomically:YES];
    });
    
}

//获取保险文件中的图片
+ (UIImage *)getImageFromImageCacheSecurityWithImage_id:(NSString *)image_id
{
    NSMutableDictionary *cacheDic = [NSMutableDictionary dictionaryWithContentsOfFile:[self imageCacheSecruityFilePath]];
    NSString *imageCacheString = [cacheDic objectForKey:image_id?:@""];
    if ([imageCacheString hasPrefix:@"http"]) {
        
        UIImage *netImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imageCacheString]]];
        return [DPImageCacheUtils compressedWithOriginalImage:netImage];
    } else if (imageCacheString.length > 0){
        
        NSData *decodeData = [NSData dataWithBase64String:imageCacheString];
        return [UIImage imageWithData:decodeData];
    } else {
        return nil;
    }
}

//保险文件路径
+ (NSString *)imageCacheSecruityFilePath
{
    //plist文件路径
    NSString *allCacheTablePath = [[DPImageCacheUtils documentSandboxPath] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.plist",IMAGE_CACHE_SECRUITY_FILE_NAME]];
    
    NSFileManager *fileManger = [NSFileManager defaultManager];
    if (![fileManger fileExistsAtPath:allCacheTablePath]) {
        if (![fileManger fileExistsAtPath:[DPImageCacheUtils documentSandboxPath]]) {//如果文件路径不存在
            [fileManger createDirectoryAtPath:[DPImageCacheUtils documentSandboxPath] withIntermediateDirectories:YES attributes:nil error:nil];
        }
        //写入新文件
        [@{} writeToFile:allCacheTablePath atomically:YES];
    }
    return allCacheTablePath;
}


@end
