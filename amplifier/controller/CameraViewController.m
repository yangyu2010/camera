//
//  CameraViewController.m
//  amplifier
//
//  Created by 杨羽 on 2020/3/15.
//  Copyright © 2020 杨羽. All rights reserved.
//

#import "CameraViewController.h"

@interface CameraViewController ()


@property (weak, nonatomic) IBOutlet UISlider *slider2;


@end

@implementation CameraViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    NSLog(@"viewDidLoad111 %f", 270.0/180*M_PI);
    

//    [self.slider2 removeConstraints:self.slider2.constraints];
//    [self.slider2 setTranslatesAutoresizingMaskIntoConstraints:YES];
//    self.slider2.transform = CGAffineTransformRotate(self.slider2.transform,270.0/180*M_PI);

    self.slider2.transform = CGAffineTransformMakeRotation(-M_PI_2);
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
