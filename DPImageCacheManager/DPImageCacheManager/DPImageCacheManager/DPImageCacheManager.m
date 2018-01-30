//
//  DPImageCacheManager.m
//  DPImageCacheManager
//
//  Created by Andrew on 2018/1/30.
//  Copyright © 2018年 Andrew. All rights reserved.
//

#import "DPImageCacheManager.h"
#import "DPImageCacheComparisonTable.h"
#import "DPImageCacheSecurity.h"

static dispatch_group_t completionGroup() {
    static dispatch_group_t dp_completionGroup;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dp_completionGroup = dispatch_group_create();
    });
    
    return dp_completionGroup;
}

static dispatch_queue_t completionQueue() {
    static dispatch_queue_t dp_completionQueue;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dp_completionQueue = dispatch_queue_create("com.andrew.completionqueue", DISPATCH_QUEUE_CONCURRENT);
    });
    
    return dp_completionQueue;
}

@implementation DPImageCacheManager

static DPImageCacheManager *_instance;
+ (instancetype)sharedImageCacheManager
{
    static dispatch_once_t onceToken_FileManager;
    dispatch_once(&onceToken_FileManager, ^{
        _instance = [[self alloc]init];
    });
    return _instance;
}

/*
 图片缓存增删改查
 */

//保存图片
- (void)saveLocalImageCacheWithImage:(UIImage *)saveImage image_id:(NSString *)image_id identifier:(NSString *)identifier
{
    [self setLocalImageCacheWithURL:nil orImage:saveImage image_id:image_id identifier:identifier];
}

//保存图片
- (void)saveNetImageCacheWithURL:(NSString *)imageURL image_id:(NSString *)image_id identifier:(NSString *)identifier
{
    [self setLocalImageCacheWithURL:imageURL orImage:nil image_id:image_id identifier:identifier];
}

//保存图片
- (void)setLocalImageCacheWithURL:(NSString *)imageURL orImage:(UIImage *)saveImage image_id:(NSString *)image_id identifier:(NSString *)identifier
{
    WS(weakSelf)
    
    self.identifier = identifier;
    
    //存储对照表文件
    [DPImageCacheComparisonTable saveImageCacheComparisonImage_id:image_id identifier:self.identifier];
    
    //存储保险文件
    [DPImageCacheSecurity saveImageCacheSecurityWithURL:imageURL orImage:saveImage image_id:image_id];
    
    UIImage __block *ksaveImage = saveImage;
    
    dispatch_group_async(completionGroup(), completionQueue(), ^{
        if (imageURL.length > 0 && imageURL) {
            ksaveImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imageURL]]];
        }
        
        //图片压缩
        ksaveImage = [DPImageCacheUtils compressedWithOriginalImage:ksaveImage];
        [UIImagePNGRepresentation(ksaveImage) writeToFile:[weakSelf getCacheImagePathWithImage_id:image_id] atomically:YES];
    });
    
}

//获取图片
- (void)getLocalImageWithImage_id:(NSString *)image_id completionHandler:(void (^)(UIImage * localCacheImage))completionHandler
{
    UIImage __block *localCacheImage = nil;
    dispatch_group_notify(completionGroup(), dispatch_get_main_queue(), ^ {
        //从本地路径获取图片
        localCacheImage = [UIImage imageWithContentsOfFile:[self getCacheImagePathWithImage_id:image_id]];
        
        //如果获取不到，将从保险文件中获取
        if (!localCacheImage) {
            localCacheImage = [DPImageCacheSecurity getImageFromImageCacheSecurityWithImage_id:image_id];
        }
        completionHandler(localCacheImage);
    });
}

//删除图片
- (void)removeLocalImageIdentifier:(NSString *)identifier
{
    self.identifier = identifier;
    
    WS(weakSelf)
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        NSFileManager *fileManger = [NSFileManager defaultManager];
        
        //获取分区下的全部图片标识名称
        NSMutableArray *locationArr = [NSMutableArray arrayWithArray:[DPImageCacheComparisonTable getImageCacheComparisonArrayWithIdentifier:self.identifier]];
        [locationArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            //删除图片缓存文件
            [fileManger removeItemAtPath:[weakSelf getCacheImagePathWithImage_id:obj] error:nil];
        }];
        //删除图片对照表文件
        [fileManger removeItemAtPath:[DPImageCacheComparisonTable imageCacheComparisonPlistTablePathWithIdentifier:self.identifier] error:nil];
    });
}

- (void)removeAllLocalImageCache
{
    WS(weakSelf)
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        NSFileManager *fileManger = [NSFileManager defaultManager];
        
        //获取分区下的全部图片标识名称
        NSDictionary *allLocalImageCacheDic = [NSDictionary dictionaryWithContentsOfFile:[DPImageCacheSecurity imageCacheSecruityFilePath]];
        
        [allLocalImageCacheDic.allKeys enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            //删除图片缓存文件
            [fileManger removeItemAtPath:[weakSelf getCacheImagePathWithImage_id:obj] error:nil];
        }];
        //删除图片对照表文件
        [fileManger removeItemAtPath:[DPImageCacheSecurity imageCacheSecruityFilePath] error:nil];
    });
}

- (void)setIdentifier:(NSString *)identifier
{
    if (!_identifier) {
        _identifier = @"defaultCacheFile";
    }
}

//获取缓存图片路径
- (NSString *)getCacheImagePathWithImage_id:(NSString *)image_id
{
    return [[DPImageCacheUtils documentSandboxPath] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.jpeg",image_id]?:@""];
}

@end
