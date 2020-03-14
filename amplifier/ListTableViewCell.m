//
//  ListTableViewCell.m
//  amplifier
//
//  Created by 杨羽 on 2020/3/14.
//  Copyright © 2020 杨羽. All rights reserved.
//

#import "ListTableViewCell.h"

@interface ListTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *lbl1;
@property (weak, nonatomic) IBOutlet UILabel *lbl2;
@property (weak, nonatomic) IBOutlet UILabel *lbl3;

@end

@implementation ListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setDict:(NSDictionary *)dict {
    _dict = dict;
    
    NSString *status = @"true";
    if ([dict[@"accepted"] integerValue] == 0) {
        status = @"false";
    }
    self.lbl1.text = [NSString stringWithFormat:@"Status: %@", status];
    self.lbl2.text = [NSString stringWithFormat:@"Reason: %@", dict[@"reason"]];
    self.lbl3.text = [NSString stringWithFormat:@"Time: %@", dict[@"time"]]; 

}



@end
