//
//  AppDelegate.m
//  amplifier
//
//  Created by 杨羽 on 2020/3/12.
//  Copyright © 2020 杨羽. All rights reserved.
//

#import "AppDelegate.h"
#import <AipOcrSdk/AipOcrSdk.h>

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    [[AipOcrService shardService] authWithAK:@"cersK9LgZssgvfAncLMS5X4Y" andSK:@"7XoDo3MGkabHTrBfUmECmHo6l5MrOKZv"];

    
    return YES;
}



@end
