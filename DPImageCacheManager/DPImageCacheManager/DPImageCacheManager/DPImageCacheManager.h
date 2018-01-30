//
//  DPImageCacheManager.h
//  DPImageCacheManager
//
//  Created by Andrew on 2018/1/30.
//  Copyright © 2018年 Andrew. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface DPImageCacheManager : NSObject

@property (nonatomic, copy, readonly) NSString *identifier;

+ (instancetype)sharedImageCacheManager;

/**
 设置图片本地存储
 
 @param saveImage   需要保存的原图
 @param image_id    图片唯一识别标识
 @param identifier  用于分区存储与管理(可不填，默认不分区)
 */
- (void)saveLocalImageCacheWithImage:(UIImage *)saveImage image_id:(NSString *)image_id identifier:(NSString *)identifier;

/**
 设置网络图片本地存储
 
 @param imageURL    图片URL地址
 @param image_id    图片唯一识别标识
 @param identifier  用于分区存储与管理(可不填，默认不分区)
 */
- (void)saveNetImageCacheWithURL:(NSString *)imageURL image_id:(NSString *)image_id identifier:(NSString *)identifier;

/**
 获取本地已存图片

 @param image_id 图片唯一识别标识
 @param completionHandler 获取回调
 */
- (void)getLocalImageWithImage_id:(NSString *)image_id completionHandler:(void (^)(UIImage * localCacheImage))completionHandler;

/**
 删除某一分区下的缓存图片
 
 @param identifier 用于分区存储与管理(可不填，默认不分区)
 */
- (void)removeLocalImageIdentifier:(NSString *)identifier;

@end
