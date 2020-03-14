//
//  PushViewController.m
//  amplifier
//
//  Created by 杨羽 on 2020/3/14.
//  Copyright © 2020 杨羽. All rights reserved.
//

#import "PushViewController.h"
#import <AFNetworking/AFNetworking.h>
#import <UIColor+Utils.h>
#import <MBProgressHUD/MBProgressHUD.h>
#import <Toast.h>

@interface PushViewController ()

@property (weak, nonatomic) IBOutlet UIButton *btn;

@end

@implementation PushViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[ UIColor colorFromHexRGB:@"e00075"]} forState:UIControlStateSelected];
    
    self.btn.layer.masksToBounds = YES;
    self.btn.layer.cornerRadius = 8;
    self.btn.layer.borderWidth = 2;
    self.btn.layer.borderColor = [UIColor colorFromHexRGB:@"e00075"].CGColor;
}

- (IBAction)action:(id)sender {
    NSString *token = [[NSUserDefaults standardUserDefaults] valueForKey:@"deviceToken"];

    if (token.length == 0) {
        [self.view makeToast:@"设备token未获取到, 不能推送!"];
        return;
    }
    
//    NSString *token = @"abc";
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSDictionary *dict = @{
        @"token": token,
    };
    
    [manager POST:@"http://94.191.30.13/notification/send" parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
//        if ([responseObject[@"code"] integerValue] == 0) {
//            self.arrDatas = responseObject[@"res"];
//            [self.collectionView reloadData];
//        } else {
//            [self.view makeToast:responseObject[@"msg"]];
//        }
        [self.view makeToast:responseObject[@"enMsg"]];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self.view makeToast:error.localizedDescription];

    }];
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
