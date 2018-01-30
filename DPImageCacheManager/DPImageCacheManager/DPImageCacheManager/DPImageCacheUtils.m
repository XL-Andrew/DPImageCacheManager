//
//  DPImageCacheUtils.m
//  DPImageCacheManager
//
//  Created by Andrew on 2018/1/30.
//  Copyright © 2018年 Andrew. All rights reserved.
//

#import "DPImageCacheUtils.h"

@implementation DPImageCacheUtils

+ (UIImage *)compressedWithOriginalImage:(UIImage *)originalImage
{
    // 源图片的分辨率
    CGSize sourceImgSize = originalImage.size;
    CGFloat sourceImgWidth = sourceImgSize.width;
    CGFloat sourceImgHeight = sourceImgSize.height;
    
    // 压缩图片的分辨率
    CGFloat compressImgWidth = 800;
    CGFloat compressImgHeight = (800 / sourceImgWidth) * sourceImgHeight;
    
    // 压缩图片
    // 把预设的图片分辨率设置为当前图片上下文
    UIGraphicsBeginImageContext(CGSizeMake(compressImgWidth, compressImgHeight));
    // drawInRect 改变图片的像素
    [originalImage drawInRect:CGRectMake(0, 0, compressImgWidth, compressImgHeight)];
    // 从当前图片上下文中创建新图片
    UIImage *compressImg = UIGraphicsGetImageFromCurrentImageContext();
    // 使当前图片上下文出堆栈
    UIGraphicsEndImageContext();
    
    return compressImg;
}

/**
 Document路径
 */
+ (NSString *)documentSandboxPath;
{
    return [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"DPImageCache"]?:@"";
}

@end
