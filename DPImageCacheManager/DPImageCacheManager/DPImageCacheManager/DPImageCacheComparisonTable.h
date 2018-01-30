//
//  DPImageCacheComparisonTable.h
//  DPImageCacheManager
//
//  Created by Andrew on 2018/1/30.
//  Copyright © 2018年 Andrew. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DPImageCacheComparisonTable : NSObject

/**
 存储图片唯一标识至对照表文件

 @param image_id 图片唯一识别标识
 @param identifier 用于分区存储与管理(可不填，默认不分区)
 */
+ (void)saveImageCacheComparisonImage_id:(NSString *)image_id identifier:(NSString *)identifier;

/**
 获取某分区下的全部图片标识名称

 @param identifier 用于分区存储与管理(可不填，默认不分区)
 @return 全部图片标识名称
 */
+ (NSArray *)getImageCacheComparisonArrayWithIdentifier:(NSString *)identifier;

/**
 对照表文件路径

 @param identifier 用于分区存储与管理(可不填，默认不分区)
 @return 对照表文件路径
 */
+ (NSString *)imageCacheComparisonPlistTablePathWithIdentifier:(NSString *)identifier;

@end
