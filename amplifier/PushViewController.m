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
