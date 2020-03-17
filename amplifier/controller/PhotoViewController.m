//
//  PhotoViewController.m
//  amplifier
//
//  Created by 杨羽 on 2020/3/16.
//  Copyright © 2020 杨羽. All rights reserved.
//

#import "PhotoViewController.h"


@interface PhotoViewController ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *consNavViewTop;

@end

@implementation PhotoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    self.consNavViewTop.constant = self;
}



- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    self.consNavViewTop.constant = self.view.safeAreaInsets.top;
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
