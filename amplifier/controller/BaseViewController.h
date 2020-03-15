//
//  BaseViewController.h
//  signature
//
//  Created by 杨羽 on 2020/3/4.
//  Copyright © 2020 杨羽. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BaseViewController : UIViewController

- (void)asyncPushAuthAlert:(NSString *)authName;

@end

NS_ASSUME_NONNULL_END
