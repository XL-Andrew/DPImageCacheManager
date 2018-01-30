//
//  DPImageCacheUtils.h
//  DPImageCacheManager
//
//  Created by Andrew on 2018/1/30.
//  Copyright © 2018年 Andrew. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DPImageCacheUtils : NSObject

/**
 图片压缩
 (如果图片大于1M，那压缩目标就是1M，但不一定达到目标。小于1M的图会尽其所能的压缩)

 @param originalImage 需要被压缩的原图
 @return 压缩后的图片
 */
+ (UIImage *)compressedWithOriginalImage:(UIImage *)originalImage;

/**
 Document路径
 */
+ (NSString *)documentSandboxPath;

@end
