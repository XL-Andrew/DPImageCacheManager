//
//  NetImageViewController.m
//  DPImageCacheManager
//
//  Created by Andrew on 2018/1/30.
//  Copyright © 2018年 Andrew. All rights reserved.
//

#import "NetImageViewController.h"
#import "DPImageCacheManager.h"

@interface NetImageViewController ()
{
    UIImageView *demoImageView;
    UITextField *urlTF;
}
@end

@implementation NetImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    demoImageView = [[UIImageView alloc]initWithFrame:CGRectMake(20, 20 + 64, self.view.bounds.size.width - 40, self.view.bounds.size.width - 40)];
    demoImageView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self.view addSubview:demoImageView];
    
    urlTF = [[UITextField alloc]initWithFrame:CGRectMake(20, self.view.bounds.size.width + 64, self.view.bounds.size.width - 40 - 80, 40)];
    urlTF.layer.borderColor = [UIColor blackColor].CGColor;
    urlTF.text = @"https://gss3.bdstatic.com/7Po3dSag_xI4khGkpoWK1HF6hhy/baike/c0%3Dbaike116%2C5%2C5%2C116%2C38/sign=1ed205deba3533fae1bb9b7cc9ba967a/b812c8fcc3cec3fdfb092ba5dd88d43f8794272e.jpg";
    urlTF.layer.borderWidth = 0.5;
    [self.view addSubview:urlTF];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(self.view.bounds.size.width - 40 - 60, self.view.bounds.size.width + 64, 80, 40);
    button.backgroundColor = [UIColor redColor];
    [button setTitle:@"获取" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(choosePhoto) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

- (void)choosePhoto
{
    [[DPImageCacheManager sharedImageCacheManager] saveNetImageCacheWithURL:urlTF.text image_id:@"asd76789a987d6f8a7sd679fa876sdf" identifier:@"first"];
    
    [[DPImageCacheManager sharedImageCacheManager]getLocalImageWithImage_id:@"asd76789a987d6f8a7sd679fa876sdf" completionHandler:^(UIImage *localCacheImage) {
        demoImageView.image = localCacheImage;
    }];
    
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
