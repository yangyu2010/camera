//
//  CameraViewController.m
//  amplifier
//
//  Created by 杨羽 on 2020/3/15.
//  Copyright © 2020 杨羽. All rights reserved.
//

#import "CameraViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "PhotoViewController.h"



#define KScreenWidth  [UIScreen mainScreen].bounds.size.width
#define KScreenHeight  [UIScreen mainScreen].bounds.size.height



@interface CameraViewController () <UIGestureRecognizerDelegate>


/// liangdu
@property (weak, nonatomic) IBOutlet UISlider *slider2;

/// suofang
@property (weak, nonatomic) IBOutlet UISlider *slider1;

@property (weak, nonatomic) IBOutlet UIView *backView;


//捕获设备，通常是前置摄像头，后置摄像头，麦克风（音频输入）
@property(nonatomic)AVCaptureDevice *device;

//AVCaptureDeviceInput 代表输入设备，他使用AVCaptureDevice 来初始化
@property(nonatomic)AVCaptureDeviceInput *input;

//当启动摄像头开始捕获输入
@property(nonatomic)AVCaptureMetadataOutput *output;

//照片输出流
@property (nonatomic)AVCaptureStillImageOutput *ImageOutPut;

//session：由他把输入输出结合在一起，并开始启动捕获设备（摄像头）
@property(nonatomic)AVCaptureSession *session;

//图像预览层，实时显示捕获的图像
@property(nonatomic)AVCaptureVideoPreviewLayer *previewLayer;


//聚焦
@property (nonatomic)UIView *focusView;
//是否开启闪光灯
@property (nonatomic)BOOL isflashOn;

/**
            *  记录开始的缩放比例
            */
@property(nonatomic,assign)CGFloat beginGestureScale;

/**
          * 最后的缩放比例
          */
@property(nonatomic,assign)CGFloat effectiveScale;


@end

@implementation CameraViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.beginGestureScale =  1.0;
    self.effectiveScale = 1.0;
    
    self.slider2.transform = CGAffineTransformMakeRotation(-M_PI_2);
    
    [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
        //分线程
        dispatch_async(dispatch_get_main_queue(), ^{
            if (granted) {
                [self customCamera];
                [self initSubViews];
                
                [self focusAtPoint:CGPointMake(0.5, 0.5)];
                
//                AVCaptureConnection *videoConnection = [self.ImageOutPut connectionWithMediaType:AVMediaTypeVideo];
//                self.slider1.maximumValue = 10;
//                self.slider1.minimumValue = 1;
            } else {
                [self asyncPushAuthAlert:@"相机"];
            }
        });
    }];

}





- (IBAction)setting:(id)sender {
}

- (IBAction)flash:(id)sender {
    
    if ([_device lockForConfiguration:nil]) {
        if (_isflashOn) {
            if ([_device isFlashModeSupported:AVCaptureFlashModeOff]) {
                [_device setFlashMode:AVCaptureFlashModeOff];
                _isflashOn = NO;
            }
        }else{
            if ([_device isFlashModeSupported:AVCaptureFlashModeOn]) {
                [_device setFlashMode:AVCaptureFlashModeOn];
                _isflashOn = YES;
            }
        }
        
        [_device unlockForConfiguration];
    }
}

- (IBAction)change:(id)sender {
    
    //获取摄像头的数量
      NSUInteger cameraCount = [[AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo] count];
      //摄像头小于等于1的时候直接返回
      if (cameraCount <= 1) return;
      
      AVCaptureDevice *newCamera = nil;
      AVCaptureDeviceInput *newInput = nil;
      //获取当前相机的方向(前还是后)
      AVCaptureDevicePosition position = [[self.input device] position];
      
      //为摄像头的转换加转场动画
      CATransition *animation = [CATransition animation];
      animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
      animation.duration = 0.5;
      animation.type = @"oglFlip";
      
      if (position == AVCaptureDevicePositionFront) {
          //获取后置摄像头
          newCamera = [self cameraWithPosition:AVCaptureDevicePositionBack];
          animation.subtype = kCATransitionFromLeft;
      }else{
          //获取前置摄像头
          newCamera = [self cameraWithPosition:AVCaptureDevicePositionFront];
          animation.subtype = kCATransitionFromRight;
      }
      
      [self.previewLayer addAnimation:animation forKey:nil];
      //输入流
      newInput = [AVCaptureDeviceInput deviceInputWithDevice:newCamera error:nil];
    
      
      if (newInput != nil) {
          
          [self.session beginConfiguration];
          //先移除原来的input
          [self.session removeInput:self.input];
          
          if ([self.session canAddInput:newInput]) {
              [self.session addInput:newInput];
              self.input = newInput;
              
          } else {
              //如果不能加现在的input，就加原来的input
              [self.session addInput:self.input];
          }
          
          [self.session commitConfiguration];
          
      }
}



- (IBAction)take:(id)sender {
    
    PhotoViewController *vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"PhotoViewController"];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    nav.modalPresentationStyle = UIModalPresentationFullScreen;

    [self presentViewController:nav animated:YES completion:nil];
//    [self.navigationController pushViewController:vc animated:YES];
    
//   AVCaptureConnection * videoConnection = [self.ImageOutPut connectionWithMediaType:AVMediaTypeVideo];
//   if (videoConnection ==  nil) {
//       return;
//   }
//
//    [videoConnection setVideoScaleAndCropFactor:self.effectiveScale];
//
//   [self.ImageOutPut captureStillImageAsynchronouslyFromConnection:videoConnection completionHandler:^(CMSampleBufferRef imageDataSampleBuffer, NSError *error) {
//
//       if (imageDataSampleBuffer == nil) {
//           return;
//       }
//
//       NSData *imageData =  [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
////       [self saveImageWithImage:];
//       UIImage *image = [UIImage imageWithData:imageData];
//       [self saveImage:image];
//
//
//
//   }];
}

- (void)saveImage:(UIImage *)image {
    NSArray *paths =NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    
    NSString *filePath = [[paths objectAtIndex:0]stringByAppendingPathComponent:
                          [NSString stringWithFormat:@"demo1.png"]];  // 保存文件的名称
    NSLog(@"NSSearchPathForDirectoriesInDomains:\n%@", filePath);

    BOOL result =[UIImagePNGRepresentation(image)writeToFile:filePath   atomically:YES]; // 保存成功会返回YES
    if (result == YES) {
        NSLog(@"保存成功");
    }
    
}

 
- (IBAction)suofang:(UISlider *)sender {
    
    
    AVCaptureConnection * videoConnection = [self.ImageOutPut connectionWithMediaType:AVMediaTypeVideo];
    if (videoConnection ==  nil) {
        return;
    }
    
    [self.previewLayer setAffineTransform:CGAffineTransformMakeScale(sender.value, sender.value)];
    
    [videoConnection setVideoScaleAndCropFactor:sender.value];
    
//    videoConnection.videoMaxScaleAndCropFactor
//    sender.value * 1 / videoConnection.videoMaxScaleAndCropFactor;
    
    // 0  1
    // 1  videoMaxScaleAndCropFactor
    
//    CGFloat scale = 1;
//    if (sender.value > 0) {
//        scale = sender.value * videoConnection.videoMaxScaleAndCropFactor;
//    }
     
    
    
}
- (IBAction)liangdu:(UISlider *)sender {
    [self cameraBackgroundDidChangeISO:sender.value];
}

#pragma mark- 检测相机权限
- (BOOL)checkCameraPermission {
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (authStatus == AVAuthorizationStatusAuthorized) {
        return YES;
    }
   
    return NO;
}


- (void)asyncPushAuthAlert:(NSString *)authName {
    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:authName message:@"下一步操作需要此权限" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okBtn = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil];
        UIAlertAction *go = [UIAlertAction actionWithTitle:@"设置" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString] options:@{} completionHandler:nil];
        }];
        
        [alert addAction:okBtn];
        [alert addAction:go];
        [self.navigationController presentViewController:alert animated:YES completion:nil];
    });
}



- (void)customCamera
{
    //使用AVMediaTypeVideo 指明self.device代表视频，默认使用后置摄像头进行初始化
    self.device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    //使用设备初始化输入
    self.input = [[AVCaptureDeviceInput alloc]initWithDevice:self.device error:nil];
    //生成输出对象
    self.output = [[AVCaptureMetadataOutput alloc]init];
    
    self.ImageOutPut = [[AVCaptureStillImageOutput alloc]init];
    //生成会话，用来结合输入输出
    self.session = [[AVCaptureSession alloc]init];
    if ([self.session canSetSessionPreset:AVCaptureSessionPreset1280x720]) {
        
        [self.session setSessionPreset:AVCaptureSessionPreset1280x720];
        
    }
    
    if ([self.session canAddInput:self.input]) {
        [self.session addInput:self.input];
        
    }
   
    if ([self.session canAddOutput:self.ImageOutPut]) {
        [self.session addOutput:self.ImageOutPut];
    }
    
    //使用self.session，初始化预览层，self.session负责驱动input进行信息的采集，layer负责把图像渲染显示
    self.previewLayer = [[AVCaptureVideoPreviewLayer alloc]initWithSession:self.session];
    self.previewLayer.frame = CGRectMake(0, 0, KScreenWidth, KScreenHeight);
    self.previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
//    [self.view.layer addSublayer:self.previewLayer];
//    [self.view.layer insertSublayer:self.previewLayer atIndex:0];
    [self.backView.layer insertSublayer:self.previewLayer atIndex:0];
    
    //开始启动
    [self.session startRunning];
    
    //修改设备的属性，先加锁
    if ([self.device lockForConfiguration:nil]) {
        
        //闪光灯自动
        if ([self.device isFlashModeSupported:AVCaptureFlashModeAuto]) {
            [self.device setFlashMode:AVCaptureFlashModeAuto];
        }
        
        //自动白平衡
        if ([self.device isWhiteBalanceModeSupported:AVCaptureWhiteBalanceModeAutoWhiteBalance]) {
            [self.device setWhiteBalanceMode:AVCaptureWhiteBalanceModeAutoWhiteBalance];
        }
        
        //解锁
        [self.device unlockForConfiguration];
        
        
    }
    
}


- (void)initSubViews {
    
    self.focusView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 80, 80)];
    self.focusView.layer.borderWidth = 1.0;
    self.focusView.layer.borderColor = [UIColor greenColor].CGColor;
    [self.backView addSubview:self.focusView];
    self.focusView.hidden = YES;
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(focusGesture:)];
    [self.backView addGestureRecognizer:tapGesture];
    
    
    UIPinchGestureRecognizer *pinch = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handlePinchGesture:)];
    [self.backView addGestureRecognizer:pinch];
    pinch.delegate = self;
    
    
}

//缩放手势 用于调整焦距
- (void)handlePinchGesture:(UIPinchGestureRecognizer *)recognizer {


    BOOL allTouchesAreOnThePreviewLayer = YES;
    NSUInteger numTouches = [recognizer numberOfTouches], i;
    for ( i = 0; i < numTouches; ++i ) {
        CGPoint location = [recognizer locationOfTouch:i inView:self.backView];
        CGPoint convertedLocation = [self.previewLayer convertPoint:location fromLayer:self.previewLayer.superlayer];
        if ( ! [self.previewLayer containsPoint:convertedLocation] ) {
            allTouchesAreOnThePreviewLayer = NO;
            break;
        }
    }
    
    if ( allTouchesAreOnThePreviewLayer ) {
        self.effectiveScale = self.beginGestureScale * recognizer.scale;
        if (self.effectiveScale < 1.0){
            self.effectiveScale = 1.0;
        }
        NSLog(@"%f-------------->%f------------recognizerScale%f",self.effectiveScale,self.beginGestureScale,recognizer.scale);

        CGFloat maxScaleAndCropFactor = [[self.ImageOutPut connectionWithMediaType:AVMediaTypeVideo] videoMaxScaleAndCropFactor];
    
        NSLog(@"%f",maxScaleAndCropFactor);
        if (self.effectiveScale > maxScaleAndCropFactor)
        {
            self.effectiveScale = maxScaleAndCropFactor;
        }
        
        [CATransaction begin];
        [CATransaction setAnimationDuration:.025];
        [self.previewLayer setAffineTransform:CGAffineTransformMakeScale(self.effectiveScale, self.effectiveScale)];
        [CATransaction commit];
    }
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    if ([gestureRecognizer isKindOfClass:[UIPinchGestureRecognizer class]]) {
        self.beginGestureScale = self.effectiveScale;
    }
    return YES;
}


- (void)focusGesture:(UITapGestureRecognizer*)gesture{
    CGPoint point = [gesture locationInView:gesture.view];
    [self focusAtPoint:point];
}

- (void)focusAtPoint:(CGPoint)point{
    CGSize size = self.backView.bounds.size;
    // focusPoint 函数后面Point取值范围是取景框左上角（0，0）到取景框右下角（1，1）之间,按这个来但位置就是不对，只能按上面的写法才可以。前面是点击位置的y/PreviewLayer的高度，后面是1-点击位置的x/PreviewLayer的宽度
    CGPoint focusPoint = CGPointMake( point.y /size.height ,1 - point.x/size.width );
    
    if ([self.device lockForConfiguration:nil]) {
        
        if ([self.device isFocusModeSupported:AVCaptureFocusModeAutoFocus]) {
            [self.device setFocusPointOfInterest:focusPoint];
            [self.device setFocusMode:AVCaptureFocusModeAutoFocus];
        }
        
        if ([self.device isExposureModeSupported:AVCaptureExposureModeAutoExpose ]) {
            [self.device setExposurePointOfInterest:focusPoint];
            //曝光量调节
            [self.device setExposureMode:AVCaptureExposureModeAutoExpose];
        }
        
        [self.device unlockForConfiguration];
        _focusView.center = point;
        _focusView.hidden = NO;
        [UIView animateWithDuration:0.3 animations:^{
            _focusView.transform = CGAffineTransformMakeScale(1.25, 1.25);
        }completion:^(BOOL finished) {
            [UIView animateWithDuration:0.5 animations:^{
                _focusView.transform = CGAffineTransformIdentity;
            } completion:^(BOOL finished) {
                _focusView.hidden = YES;
            }];
        }];
    }
    
}

- (AVCaptureDevice *)cameraWithPosition:(AVCaptureDevicePosition)position{
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for ( AVCaptureDevice *device in devices )
        if ( device.position == position ) return device;
    return nil;
}


// 调节ISO，光感度 0.0-1.0
- (void)cameraBackgroundDidChangeISO:(CGFloat)iso {
    AVCaptureDevice *captureDevice = [self.input device];
    NSError *error;
    if ([captureDevice lockForConfiguration:&error]) {
        CGFloat minISO = captureDevice.activeFormat.minISO;
        CGFloat maxISO = captureDevice.activeFormat.maxISO;
        CGFloat currentISO = (maxISO - minISO) * iso + minISO;
        [captureDevice setExposureModeCustomWithDuration:AVCaptureExposureDurationCurrent ISO:currentISO completionHandler:nil];
        [captureDevice unlockForConfiguration];
    }else{
        // Handle the error appropriately.
    }
}

@end
