//
//  WebViewController.m
//  touxiang
//
//  Created by 杨羽 on 2020/2/14.
//  Copyright © 2020 adesk. All rights reserved.
//

#import "WebViewController.h"
//#import "webkit"
#import <WebKit/WebKit.h>



@interface WebViewController ()
{
    WKWebView *_web;
}
@end

@implementation WebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    

    self.navigationItem.title = self.titleStr;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_back"] style:UIBarButtonItemStylePlain target:self action:@selector(actionBack)];

    
    WKWebView *web = [[WKWebView alloc] init];
    web.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:web];
    _web = web;
    
    
    NSURLRequest *re = [NSURLRequest requestWithURL:[NSURL URLWithString:self.url]];
    [web loadRequest:re];
}


- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews ];
    
    _web.frame = self.view.bounds;
}


- (void)actionBack {

    if (self.navigationController.childViewControllers.count > 1) {
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    }
}

/*
 
 
 func showBackButton() {
         let item = UIBarButtonItem(image: UIImage(named: "nav_back"), style: .plain, target: self, action: #selector(actionBack))
         self.navigationItem.leftBarButtonItem = item
     }
     
     @objc private func actionBack() {
         if let nav = self.navigationController,
             nav.children.count > 1 {
             nav.popViewController(animated: true)
         } else {
             self.navigationController?.dismiss(animated: true, completion: nil)
         }
 //        self.navigationController?.popViewController(animated: true)
     }
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
