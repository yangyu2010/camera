//
//  TextViewController.m
//  amplifier
//
//  Created by 杨羽 on 2020/3/18.
//  Copyright © 2020 杨羽. All rights reserved.
//

#import "TextViewController.h"

@interface TextViewController ()

@property (weak, nonatomic) IBOutlet UITextView *textView;
//@property (weak, nonatomic) IBOutlet UILabel *lbl;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *consBottomView;

@end

@implementation TextViewController

- (void)viewDidLoad {
    [super viewDidLoad];

//    self.lbl.text = self.texts;
    self.textView.text = self.texts;
//
//
//    [self.view setNeedsLayout];
//    [self.view layoutIfNeeded];
//    i
    
}

- (IBAction)copy:(id)sender {
}

- (IBAction)font:(UISlider *)sender {
}

@end
