//
//  WPFriendCell.h
//  Wops
//
//  Created by Rafael Lopez on 4/21/16.
//  Copyright © 2016 Rflpz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WPFriendCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lblNameUser;
@property (weak, nonatomic) IBOutlet UILabel *lblEmailUser;
@property (weak, nonatomic) IBOutlet UILabel *lblPhoneUser;

@end
