//
//  WPFriendCell.m
//  Wops
//
//  Created by Rafael Lopez on 4/21/16.
//  Copyright © 2016 Rflpz. All rights reserved.
//

#import "WPFriendCell.h"

@implementation WPFriendCell

@synthesize lblNameUser = _lblNameUser;
@synthesize lblPhoneUser =  _lblPhoneUser;
@synthesize lblEmailUser = _lblEmailUser;
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
