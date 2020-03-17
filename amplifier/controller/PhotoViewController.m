//
//  PhotoViewController.m
//  amplifier
//
//  Created by 杨羽 on 2020/3/16.
//  Copyright © 2020 杨羽. All rights reserved.
//

#import "PhotoViewController.h"


@interface PhotoViewController () <UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *consNavViewTop;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
//@property (weak, nonatomic) IBOutlet UIImageView *imgView;

@property (strong, nonatomic) UIImageView *imgView;

//@property (strong, nonatomic) UIImage *img;
@property (weak, nonatomic) IBOutlet UISlider *sliderSuofang;
@property (weak, nonatomic) IBOutlet UISlider *sliderLiangdu;


@end

@implementation PhotoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //初始化imageview，设置图片
    self.imgView = [[UIImageView alloc]init];
    self.imgView.image = [UIImage imageNamed:@"111"];
    self.imgView.frame = CGRectMake(0, 0, self.imgView.image.size.width, self.imgView.image.size.height);
//    self.imgView.frame = self.scrollView.bounds;
    [self.scrollView addSubview:self.imgView];
    
    
    self.scrollView.delegate = self;
//    self.scrollView.minimumZoomScale = 1;
//    self.scrollView.maximumZoomScale = 5;
    self.scrollView.contentSize = self.imgView.image.size;
//    [self.scrollView setZoomScale:1 animated:NO];
    
    float xRate = self.scrollView.bounds.size.width / self.imgView.bounds.size.width;
    float yRate = self.scrollView.bounds.size.height / self.imgView.bounds.size.height;
    self.scrollView.minimumZoomScale = MIN(MIN(xRate, yRate), 1);
    self.scrollView.maximumZoomScale = 3.0;
    self.scrollView.bouncesZoom = YES;

    self.scrollView.zoomScale = self.scrollView.minimumZoomScale;
//    self.imgView.center = self.scrollView.center;
    
    self.sliderSuofang.minimumValue = self.scrollView.minimumZoomScale;
    self.sliderSuofang.maximumValue = self.scrollView.maximumZoomScale;
    self.sliderSuofang.value = self.scrollView.minimumZoomScale;
}



- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    self.consNavViewTop.constant = self.view.safeAreaInsets.top;
}


- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.imgView;
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale {
    NSLog(@"scrollViewDidEndZooming %f", scale);
    
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    CGFloat offsetX = (GetViewWidth(scrollView) > scrollView.contentSize.width) ? (GetViewWidth(scrollView) - scrollView.contentSize.width) * 0.5 : 0.0;
    CGFloat offsetY = (GetViewHeight(scrollView) > scrollView.contentSize.height) ? (GetViewHeight(scrollView) - scrollView.contentSize.height) * 0.5 : 0.0;
    self.imgView.center = CGPointMake(scrollView.contentSize.width * 0.5 + offsetX, scrollView.contentSize.height * 0.5 + offsetY);
}


static inline CGFloat GetViewWidth(UIView *view) {
    return view.frame.size.width;
}

static inline CGFloat GetViewHeight(UIView *view) {
    return view.frame.size.height;
}
- (IBAction)back:(id)sender {
}
- (IBAction)text:(id)sender {
}
- (IBAction)save:(id)sender {
}

- (IBAction)suofang:(UISlider *)sender {
    [self.scrollView setZoomScale:sender.value animated:NO];
}


- (IBAction)liangdu:(id)sender {
}

- (IBAction)left:(id)sender {
}

- (IBAction)blackwhite:(id)sender {
}
- (IBAction)right:(id)sender {
}


@end
