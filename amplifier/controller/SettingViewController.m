//
//  SettingViewController.m
//  amplifier
//
//  Created by 杨羽 on 2020/3/19.
//  Copyright © 2020 杨羽. All rights reserved.
//

#import "SettingViewController.h"
#import "VipViewController.h"

@interface SettingViewController ()

@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}


- (IBAction)vip:(id)sender {
    VipViewController *vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"VipViewController"];
    vc.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:vc animated:YES completion:nil];
    
}


- (IBAction)feedback:(id)sender {
}



- (IBAction)help:(id)sender {
}

- (IBAction)flash:(UISwitch *)sender {
}


- (IBAction)privacy:(id)sender {
}



- (IBAction)protocol:(id)sender {
}


@end
