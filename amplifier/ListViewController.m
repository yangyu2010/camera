//
//  ListViewController.m
//  amplifier
//
//  Created by 杨羽 on 2020/3/14.
//  Copyright © 2020 杨羽. All rights reserved.
//

#import "ListViewController.h"
#import <AFNetworking/AFNetworking.h>
#import <UIColor+Utils.h>
#import <MBProgressHUD/MBProgressHUD.h>
#import <Toast.h>
#import <MJRefresh/MJRefresh.h>
#import "MJRefreshAutoNormalFooter.h"
#import "MJRefreshNormalHeader.h"

#import "ListTableViewCell.h"

@interface ListViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *arrDatas;


@property (nonatomic, assign) NSInteger page;


@end

@implementation ListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"ListTableViewCell" bundle:nil] forCellReuseIdentifier:@"ListTableViewCellID"];
    
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
//    [self.tableView.mj_footer beginRefreshing];
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadData)];

    self.arrDatas = [NSMutableArray array];
    [self loadData];
}

- (void)loadData {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    _page = 1;
    
    NSString *url = [NSString stringWithFormat:@"http://94.191.30.13/notification/list?pageSize=10&pageNum=%ld", (long)_page];
    [manager GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if ([responseObject[@"code"] integerValue] == 200) {
            NSArray *arr = responseObject[@"data"][@"items"];
            if (arr.count > 0) {
                [self.arrDatas removeAllObjects];
                [self.arrDatas addObjectsFromArray:arr];
                [self.tableView reloadData];
            }
            if ([responseObject[@"data"][@"isMore"] integerValue] == 0) {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            } else {
                
            }
            [self.tableView.mj_header endRefreshing];
        } else {
            [self.view makeToast:responseObject[@"enMsg"]];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self.view makeToast:error.localizedDescription];
    }];
}

- (void)loadMoreData {
    _page += 1;
    
    NSString *url = [NSString stringWithFormat:@"http://94.191.30.13/notification/list?pageSize=10&pageNum=%ld", (long)_page];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];

    [manager GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {

        if ([responseObject[@"code"] integerValue] == 200) {
            NSArray *arr = responseObject[@"data"][@"items"];
            if (arr.count > 0) {
                [self.arrDatas addObjectsFromArray:arr];
                [self.tableView reloadData];
            }
        } else {
            [self.view makeToast:responseObject[@"enMsg"]];
        }
        
        if ([responseObject[@"data"][@"isMore"] integerValue] == 0) {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        } else {
            [self.tableView.mj_footer endRefreshing];

        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self.tableView.mj_footer endRefreshing];

        [self.view makeToast:error.localizedDescription];
    }];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.arrDatas.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ListTableViewCellID" forIndexPath:indexPath];
    if (self.arrDatas.count > 0) {
        cell.dict = self.arrDatas[indexPath.item];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 130;
}

@end
