//
//  LocalLibraryViewController.m
//  DPImageCacheManager
//
//  Created by Andrew on 2018/1/30.
//  Copyright © 2018年 Andrew. All rights reserved.
//

#import "LocalLibraryViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <MobileCoreServices/MobileCoreServices.h>

// STEP 1 导入头文件
#import "DPImageCacheManager.h"

@interface LocalLibraryViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate>
{
    UIImageView *demoImageView;
}
@end

@implementation LocalLibraryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    demoImageView = [[UIImageView alloc]initWithFrame:CGRectMake(20, 20 + 64, self.view.bounds.size.width - 40, self.view.bounds.size.width - 40)];
    demoImageView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self.view addSubview:demoImageView];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(20, self.view.bounds.size.width + 64, self.view.bounds.size.width - 40, 40);
    button.backgroundColor = [UIColor redColor];
    [button setTitle:@"选取照片" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(choosePhoto) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
}

- (void)choosePhoto
{
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc]init];
    imagePickerController.delegate = self;
    imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imagePickerController.allowsEditing = YES;
    imagePickerController.mediaTypes = @[(NSString *)kUTTypeImage];
    [self presentViewController:imagePickerController animated:YES completion:nil];
}



- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *editedImage = info[UIImagePickerControllerEditedImage];
    
    // STEP 2 存储图片
    [[DPImageCacheManager sharedImageCacheManager] saveLocalImageCacheWithImage:editedImage image_id:@"kjh32jhjjhg6234jhg52j34h5g" identifier:nil];
    
    // STEP 3 异步获取图片
    [[DPImageCacheManager sharedImageCacheManager]getLocalImageWithImage_id:@"kjh32jhjjhg6234jhg52j34h5g" completionHandler:^(UIImage *localCacheImage) {
        demoImageView.image = localCacheImage;
    }];
    
    [picker dismissViewControllerAnimated:YES completion:nil];
//    demoImageView.image = [[DPImageCacheManager sharedImageCacheManager] getLocalImageWithImage_id:@"kjh32jhjjhg6234jhg52j34h5g"];
}

//点击Cancel按钮后执行方法
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
