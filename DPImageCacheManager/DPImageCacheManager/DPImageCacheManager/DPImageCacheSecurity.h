//
//  DPImageCacheSecurity.h
//  DPImageCacheManager
//
//  Created by Andrew on 2018/1/30.
//  Copyright © 2018年 Andrew. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DPImageCacheSecurity : NSObject

/**
 图片存入保险文件

 @param imageURL    图片URL（优先存储方案）
 @param saveImage   图片base64存储
 @param image_id    图片唯一识别标识
 */
+ (void)saveImageCacheSecurityWithURL:(NSString *)imageURL orImage:(UIImage *)saveImage image_id:(NSString *)image_id;

/**
 获取保险文件中的图片

 @param image_id 图片唯一识别标识
 @return 保险文件中的图片
 */
+ (UIImage *)getImageFromImageCacheSecurityWithImage_id:(NSString *)image_id;

/**
 获取保险文件路径

 @return 保险文件路径
 */
+ (NSString *)imageCacheSecruityFilePath;

@end
