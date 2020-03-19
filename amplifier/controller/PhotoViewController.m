//
//  PhotoViewController.m
//  amplifier
//
//  Created by 杨羽 on 2020/3/16.
//  Copyright © 2020 杨羽. All rights reserved.
//

#import "PhotoViewController.h"
#import <GPUImage/GPUImage.h>

#import <MBProgressHUD.h>
#import <Toast/Toast.h>
#import <AipOcrSdk/AipOcrSdk.h>
#import "TextViewController.h"
#import "VipViewController.h"


@interface PhotoViewController () <UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *consNavViewTop;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
//@property (weak, nonatomic) IBOutlet UIImageView *imgView;

@property (strong, nonatomic) UIImageView *imgView;

//@property (strong, nonatomic) UIImage *img;
@property (weak, nonatomic) IBOutlet UISlider *sliderSuofang;
@property (weak, nonatomic) IBOutlet UISlider *sliderLiangdu;

@property (strong, nonatomic) UIImage *originImage;
//brightness
@property (assign, nonatomic) CGFloat brightness;


@end

@implementation PhotoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    self.brightness = -1;
    self.brightness = [UIScreen mainScreen].brightness;
    self.sliderLiangdu.value =[UIScreen mainScreen].brightness;
    
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


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    self.navigationController.navigationBarHidden = NO;
    
    
    
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [UIScreen mainScreen].brightness = self.brightness;
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
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)text:(id)sender {

    
    
    
    
    BOOL isBuy = [VipViewController isBuy];
    if (isBuy == NO) {
        VipViewController *vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"VipViewController"];
        vc.modalPresentationStyle = UIModalPresentationFullScreen;
        [self presentViewController:vc animated:YES completion:nil];
        
        return;
    }
         
         NSDictionary *options = @{
             @"language_type": @"CHN_ENG",
             @"detect_direction": @"true",
         };
         
         //NSString *path = [[NSBundle mainBundle] pathForResource:@"1.png" ofType:nil];
        // UIImage *image = [UIImage imageWithContentsOfFile:path];
         
    //     UIImage *image = [UIImage imageNamed:@"222"];
        
        UIImage *image = self.imgView.image;
         
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];

    
         [[AipOcrService shardService] detectTextFromImage:image withOptions:options successHandler:^(id result) {
             NSLog(@"%@", result);
             

             NSMutableString *message = [NSMutableString string];
             
             if(result[@"words_result"]){
                 if([result[@"words_result"] isKindOfClass:[NSDictionary class]]){
                     [result[@"words_result"] enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
                         if([obj isKindOfClass:[NSDictionary class]] && [obj objectForKey:@"words"]){
                             [message appendFormat:@"%@: %@\n", key, obj[@"words"]];
                         }else{
                             [message appendFormat:@"%@: %@\n", key, obj];
                         }
                         
                     }];
                 }else if([result[@"words_result"] isKindOfClass:[NSArray class]]){
                     for(NSDictionary *obj in result[@"words_result"]){
                         if([obj isKindOfClass:[NSDictionary class]] && [obj objectForKey:@"words"]){
                             [message appendFormat:@"%@\n", obj[@"words"]];
                         }else{
                             [message appendFormat:@"%@\n", obj];
                         }
                         
                     }
                 }
                 
             }else{
                 [message appendFormat:@"%@", result];
             }
             
             dispatch_async(dispatch_get_main_queue(), ^{
                 [MBProgressHUD hideHUDForView:self.view animated:YES];
                 if (message.length == 0) {
                     [self.view makeToast:@"未识别到文字"];
                 } else {
                     TextViewController *vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"TextViewController"];
                     vc.texts = message;
                     [self.navigationController pushViewController:vc animated:YES];
                 }
             });
             NSLog(@"%@", message);
             
             
         } failHandler:^(NSError *err) {
             dispatch_async(dispatch_get_main_queue(), ^{
                 [MBProgressHUD hideHUDForView:self.view animated:YES];
                 [self.view makeToast:err.localizedDescription];

             });
             
             NSLog(@"%@", err.localizedDescription);
         }];
}
- (IBAction)save:(id)sender {
    UIImageWriteToSavedPhotosAlbum(self.imgView.image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);

}

-(void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    NSString *msg = nil ;
    if(error){
        msg = @"保存图片失败" ;

    }else{
        msg = @"保存图片成功" ;
        
        
        
//        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
//
//        // Set the custom view mode to show any view.
//        hud.mode = MBProgressHUDModeCustomView;
//        // Set an image view with a checkmark.
////        UIImage *image = [[UIImage imageNamed:@"icon_complete"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
//
//        UIImage *image = [UIImage imageNamed:@"icon_complete"];
//        hud.customView = [[UIImageView alloc] initWithImage:image];
//        // Looks a bit nicer if we make it square.
//        hud.square = YES;
//        // Optional label text.
//        hud.label.text = @"图片已保存到相册";
//
//        [hud hideAnimated:YES afterDelay:2.f];
    }
    
    [self.view makeToast:msg];

}


- (IBAction)suofang:(UISlider *)sender {
    [self.scrollView setZoomScale:sender.value animated:NO];
}


- (IBAction)liangdu:(UISlider *)sender {
    [UIScreen mainScreen].brightness = sender.value;
    
}

- (IBAction)left:(id)sender {
    
    [UIView animateWithDuration:1.0 animations:^{
        //获取到上次旋转后transform来进行操作即可,平移,缩放同理
        self.scrollView.transform = CGAffineTransformRotate(self.scrollView.transform, -M_PI_4 / 2);
    }];
    
    
}

- (IBAction)blackwhite:(id)sender {
    
    if (self.originImage) {
        self.imgView.image = self.originImage;
        self.originImage = nil;
    } else {
        self.originImage = self.imgView.image;
        
        
        
        UIImage *inputImage = self.imgView.image;
                      
           // 生成GPUImagePicture
           GPUImagePicture *sourcePicture = [[GPUImagePicture alloc] initWithImage:inputImage smoothlyScaleOutput:YES];
           GPUImageGrayscaleFilter *filter = [[GPUImageGrayscaleFilter alloc] init];
           [sourcePicture addTarget:filter];
           [sourcePicture processImage];
                  
                  [MBProgressHUD showHUDAddedTo:self.view animated:YES];

           dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
               [MBProgressHUD hideHUDForView:self.view animated:YES];

               
               // 保存到相册
               UIImage *keepImage = [filter imageByFilteringImage:inputImage];
               if (keepImage) {
        //           [self saveImage:keepImage];
                   self.imgView.image = keepImage;
               }
           });

    }
    
    
    
}


- (IBAction)right:(id)sender {
    
    [UIView animateWithDuration:1.0 animations:^{
        //获取到上次旋转后transform来进行操作即可,平移,缩放同理
        self.scrollView.transform = CGAffineTransformRotate(self.scrollView.transform, M_PI_4 / 2);
    }];
    
}


@end
