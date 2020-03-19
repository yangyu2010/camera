//
//  VipCollectionViewCell.m
//  amplifier
//


//  Created by 杨羽 on 2020/3/19.
//  Copyright © 2020 杨羽. All rights reserved.
//

#import "VipCollectionViewCell.h"
#import <UIColor+Utils.h>

@interface VipCollectionViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UILabel *lblPrice;
@property (weak, nonatomic) IBOutlet UILabel *lblOldPrice;

@property (weak, nonatomic) IBOutlet UILabel *lblMonth;
@property (weak, nonatomic) IBOutlet UIView *bgView;

@end

@implementation VipCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    
       _bgView.layer.shadowColor = [UIColor blackColor].CGColor;
       _bgView.layer.shadowOffset = CGSizeZero;
       _bgView.layer.shadowOpacity = 0.1;
       _bgView.layer.shadowRadius = 3;
       _bgView.layer.cornerRadius = 8;

}


- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    
    if (selected) {
        _bgView.backgroundColor = [[UIColor colorFromHexRGB:@"ffeecf"] colorWithAlphaComponent:1];;
        _bgView.layer.borderColor = [UIColor colorFromHexRGB:@"daaf5c"].CGColor;
        _bgView.layer.borderWidth = 2.0;
    } else {
        _bgView.backgroundColor = [UIColor whiteColor];
        _bgView.layer.borderColor = nil;
        _bgView.layer.borderWidth = 0;
    }
}


@end
