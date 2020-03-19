//
//  PrivacyViewController.m
//  touxiang
//
//  Created by 杨羽 on 2020/2/14.
//  Copyright © 2020 adesk. All rights reserved.
//

#import "PrivacyViewController.h"
#import "WebViewController.h"
#import <UIColor+Utils.h>

@interface PrivacyViewController ()<UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UITextView *textView;

@end

@implementation PrivacyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    

        
    self.textView.delegate = self;
//    //        《隐私政策》和《用户协议》。
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:self.textView.text attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:15]}];
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
//
//            let attributedString = NSMutableAttributedString(string: textView.text, attributes: [.font : UIFont.systemFont(ofSize: 15.0)])
//
//            if let range = attributedString.string.range(of: "《隐私政策》")  {
//                attributedString.addAttribute(.foregroundColor, value: UIColor(named: "44CD88")!, range: NSRange(range, in: attributedString.string))
//                attributedString.addAttribute(.link, value: "privacy://", range: NSRange(range, in: attributedString.string))
//            }
//
//            if let range = attributedString.string.range(of: "《用户协议》")  {
//                attributedString.addAttribute(.foregroundColor, value: UIColor(named: "44CD88")!, range: NSRange(range, in: attributedString.string))
//                attributedString.addAttribute(.link, value: "protocol://", range: NSRange(range, in: attributedString.string))
//            }
//
//            textView.attributedText = attributedString
            
/**
 
 
 */
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
    
    /**

     if let scheme = URL.scheme, scheme == "privacy" {
         Logger.log("privacy")
         let web = WebViewController()
         web.navTitle = "隐私政策"
         web.url = "https://s.novapps.com/web_html/in_input_new_privacy.html?v=1"
         let nav = NavigationController(rootViewController: web)
         self.present(nav, animated: true, completion: nil)
         return true
     }
     
     if let scheme = URL.scheme, scheme == "protocol" {
         Logger.log("protocol")
         let web = WebViewController()
         web.navTitle = "用户协议"
         web.url = "https://s.novapps.com/web_html/in_input_service_protocol.html"
         let nav = NavigationController(rootViewController: web)
         self.present(nav, animated: true, completion: nil)
         return true
     }
     */
    return YES;
}


- (IBAction)agree:(id)sender {
#if DEBUG
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"kUserPrivacyAgree"];

#else
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"kUserPrivacyAgree"];

#endif
    [self dismissViewControllerAnimated:NO completion:nil];
    
}

- (IBAction)disagree:(id)sender {
    
    
//    [[UIApplication sharedApplication] performSelector:@selector(suspend)];
    
//    [NSThread sleepForTimeInterval:1];
    
//    exit(0);
    
    
    UIAlertController *moreAlert = [UIAlertController alertControllerWithTitle:@"您必须同意《隐私政策》和《用户协议》才能继续使用" message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"我知道了" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    [moreAlert addAction:action];
    [self presentViewController:moreAlert animated:YES completion:nil];
}

@end
