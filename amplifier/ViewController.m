//
//  ViewController.m
//  amplifier
//
//  Created by 杨羽 on 2020/3/12.
//  Copyright © 2020 杨羽. All rights reserved.
//

#import "ViewController.h"
#import <AipOcrSdk/AipOcrSdk.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[AipOcrService shardService] authWithAK:@"cersK9LgZssgvfAncLMS5X4Y" andSK:@"7XoDo3MGkabHTrBfUmECmHo6l5MrOKZv"];

    
    
    NSDictionary *options = @{
        @"language_type": @"CHN_ENG",
        @"detect_direction": @"true",
    };
    
    //NSString *path = [[NSBundle mainBundle] pathForResource:@"1.png" ofType:nil];
   // UIImage *image = [UIImage imageWithContentsOfFile:path];
    
    UIImage *image = [UIImage imageNamed:@"222"];
    
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


@end
