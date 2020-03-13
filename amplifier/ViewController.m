//
//  ViewController.m
//  amplifier
//
//  Created by 杨羽 on 2020/3/12.
//  Copyright © 2020 杨羽. All rights reserved.
//

#import "ViewController.h"
#import <AipOcrSdk/AipOcrSdk.h>
#import <GPUImage/GPUImage.h>

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *imgView;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    

//    UIImageOrientationUp,            // default orientation
//    UIImageOrientationDown,          // 180 deg rotation
//    UIImageOrientationLeft,          // 90 deg CCW
//    UIImageOrientationRight,         // 90 deg CW
//    UIImageOrientationUpMirrored,    // as above but image mirrored along other axis. horizontal flip
//    UIImageOrientationDownMirrored,  // horizontal flip
//    UIImageOrientationLeftMirrored,  // vertical flip
//    UIImageOrientationRightMirrored, // vertical flip
    
    
    NSLog(@"imageOrientation %ld", (long)self.imgView.image.imageOrientation);
    
}


- (IBAction)blackwhite:(id)sender {


    UIImage *inputImage = self.imgView.image;
           
    // 生成GPUImagePicture
    GPUImagePicture *sourcePicture = [[GPUImagePicture alloc] initWithImage:inputImage smoothlyScaleOutput:YES];
           
    // 随便用一个滤镜
    GPUImageAverageLuminanceThresholdFilter *sepiaFilter = [[GPUImageAverageLuminanceThresholdFilter alloc] init];
    //    [(GPUImageLuminanceThresholdFilter *)_sepiaFilter setThreshold:0.44];
    //    [(GPUImageAdaptiveThresholdFilter *)_sepiaFilter setBlurRadiusInPixels:10.0];
    [(GPUImageAverageLuminanceThresholdFilter *)sepiaFilter setThresholdMultiplier:0.8];
    //    [_sepiaFilter setIntensity:1.0];
    //    [(GPUImageMonochromeFilter *)_sepiaFilter setColor:(GPUVector4){1.0f, 1.0f, 1.0f, 1.f}];

    [sourcePicture addTarget:sepiaFilter];

    [sourcePicture processImage];
           
           
           
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 保存到相册
        UIImage *keepImage = [sepiaFilter imageByFilteringImage:inputImage];
        if (keepImage) {
            [self saveImage:keepImage];
            self.imgView.image = keepImage;
        }
    });

    
}

- (UIImage *)normalizedImage:(UIImage *)img {
    if (img.imageOrientation == UIImageOrientationUp) return img;

    UIGraphicsBeginImageContextWithOptions(img.size, NO, img.scale);
    [img drawInRect:(CGRect){0, 0, img.size}];
    UIImage *normalizedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return normalizedImage;
}


- (void)saveImage:(UIImage *)image {
    NSArray *paths =NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    
    NSString *filePath = [[paths objectAtIndex:0]stringByAppendingPathComponent:
                          [NSString stringWithFormat:@"demo-IMG_2704-GPUImageAverageLuminanceThresholdFilter0.8.png"]];  // 保存文件的名称
    NSLog(@"NSSearchPathForDirectoriesInDomains:\n%@", filePath);

    BOOL result =[UIImagePNGRepresentation(image)writeToFile:filePath   atomically:YES]; // 保存成功会返回YES
    if (result == YES) {
        NSLog(@"保存成功");
    }
    
}


- (IBAction)ocr:(id)sender {
    
     [[AipOcrService shardService] authWithAK:@"cersK9LgZssgvfAncLMS5X4Y" andSK:@"7XoDo3MGkabHTrBfUmECmHo6l5MrOKZv"];

     
     NSDictionary *options = @{
         @"language_type": @"CHN_ENG",
         @"detect_direction": @"true",
     };
     
     //NSString *path = [[NSBundle mainBundle] pathForResource:@"1.png" ofType:nil];
    // UIImage *image = [UIImage imageWithContentsOfFile:path];
     
//     UIImage *image = [UIImage imageNamed:@"222"];
    
    UIImage *image = self.imgView.image;
     
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
         
         NSLog(@"%@", message);
         
         
     } failHandler:^(NSError *err) {
         NSLog(@"%@", err.localizedDescription);
     }];
}


- (void)baiduocr {

}


@end
