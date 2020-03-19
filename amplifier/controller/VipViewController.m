//
//  VipViewController.m
//  amplifier
//
//  Created by 杨羽 on 2020/3/19.
//  Copyright © 2020 杨羽. All rights reserved.
//

#import "VipViewController.h"
#import "VipCollectionViewCell.h"
#import <UIColor+Utils.h>
#import "WebViewController.h"
#import <NOVIAP/NOVIAP.h>
#import <NOVIAP/NOVIAPUserDefaultProductStore.h>
#import "VipCollectionViewCell.h"



#define kMonthVIP @""
#define kYearVIP @""


@interface VipViewController () <UITextViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UITextView *textView;

@end

@implementation VipViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    [self.collectionView registerNib:[UINib nibWithNibName:@"VipCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"VipCollectionViewCellID"];
    
    
     self.textView.delegate = self;
    //    //        《隐私政策》和《用户协议》。
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:self.textView.text attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:12], NSForegroundColorAttributeName: [UIColor colorFromHexRGB:@"bdbdbd"]}];
        NSRange range1 = [attributedString.string rangeOfString:@"《隐私政策》"];
        if (range1.length > 0) {
            [attributedString addAttributes:@{NSForegroundColorAttributeName: [UIColor colorFromHexRGB:@"007aff"]} range:range1];
            [attributedString addAttributes:@{NSLinkAttributeName: @"privacy://"} range:range1];
        }
        
        NSRange range2 = [attributedString.string rangeOfString:@"《用户协议》"];
        if (range2.length > 0) {
            [attributedString addAttributes:@{NSForegroundColorAttributeName: [UIColor colorFromHexRGB:@"007aff"]} range:range2];
            [attributedString addAttributes:@{NSLinkAttributeName: @"protocol://"} range:range2];
        }
        self.textView.attributedText = attributedString;
}

- (IBAction)back:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)restore:(id)sender {
    [[NOVIAP shared] restore];
}

- (IBAction)bug:(id)sender {
}



-(BOOL)textView:(UITextView *)textView shouldInteractWithURL:(nonnull NSURL *)URL inRange:(NSRange)characterRange interaction:(UITextItemInteraction)interaction {
    
    // https://s.orzjun.com/web_html/signature_new_privacy.html
    //https://s.orzjun.com/web_html/signature_service_protocol.html
    
    if ([URL.scheme isEqualToString:@"privacy"]) {
        WebViewController *web = [[WebViewController alloc] init];
        web.titleStr = @"隐私政策";
        web.url = @"https://s.orzjun.com/web_html/signature_new_privacy.html";
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:web];
        [self presentViewController:nav animated:YES completion:nil];
    } else if ([URL.scheme isEqualToString:@"protocol"]) {
        WebViewController *web = [[WebViewController alloc] init];
        web.titleStr = @"用户协议";
        web.url = @"https://s.orzjun.com/web_html/signature_service_protocol.html";
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:web];
        [self presentViewController:nav animated:YES completion:nil];
    }
    
    
    return YES;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 4;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    VipCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"VipCollectionViewCellID" forIndexPath:indexPath];
    
    
    return cell;
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CGFloat width = collectionView.bounds.size.width;
    CGFloat margin = 12;
    NSInteger count = 3;
    width = (width - (count + 1) * margin) / count;
    return CGSizeMake(width, collectionView.bounds.size.height);
}

+ (BOOL)isBuy {
    return [[NOVIAPUserDefaultProductStore shared] isActivatedForRenewSubscriptionProduct:kMonthVIP];
}

@end
