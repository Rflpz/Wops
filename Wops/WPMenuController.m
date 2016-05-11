//
//  WPMenuController.m
//  Wops
//
//  Created by Rafael Lopez on 4/20/16.
//  Copyright © 2016 Rflpz. All rights reserved.
//

#import "WPMenuController.h"
#import "WPTrackController.h"
#import "WPFriendsController.h"
#import "WPConfigurationController.h"
@interface WPMenuController ()
@property (weak, nonatomic) IBOutlet UIButton *btnTracking;
@property (weak, nonatomic) IBOutlet UIButton *btnFriends;
@property (weak, nonatomic) IBOutlet UIButton *btnLogout;

@end

@implementation WPMenuController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"WOPS";
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc]
                                   initWithImage:[[self imageWithImage:[UIImage imageNamed:@"config_wops.png"] scaledToSize:CGSizeMake(37,37)] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]
                                   style:UIBarButtonItemStyleDone
                                   target:self
                                   action:@selector(goConfig)];
    self.navigationItem.leftBarButtonItem = leftButton;
    self.view.backgroundColor = [self colorFromHexString:@"#0097A7"];
    self.navigationItem.titleView = [[UIImageView alloc]initWithImage:[[self imageWithImage:[UIImage imageNamed:@"shield_wops.png"] scaledToSize:CGSizeMake(60,60)] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [_btnFriends setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _btnFriends.backgroundColor = [self colorFromHexString:@"#7C4DFF"];
    _btnFriends.layer.cornerRadius = 30;
    _btnFriends.clipsToBounds = YES;
    [[_btnFriends layer] setBorderWidth:0.8f];
    [[_btnFriends layer] setBorderColor:[self colorFromHexString:@"#7C4DFF"].CGColor];
    
    [_btnTracking setTitleColor:[self colorFromHexString:@"#0097A7"] forState:UIControlStateNormal];
    _btnTracking.backgroundColor = [UIColor whiteColor];
    _btnTracking.layer.cornerRadius = 30;
    _btnTracking.clipsToBounds = YES;
    [[_btnTracking layer] setBorderWidth:0.8f];
    [[_btnTracking layer] setBorderColor:[self colorFromHexString:@"#0097A7"].CGColor];
    
    [_btnLogout setTitleColor:[self colorFromHexString:@"#0097A7"] forState:UIControlStateNormal];
    _btnLogout.backgroundColor = [UIColor whiteColor];
    _btnLogout.layer.cornerRadius = 30;
    _btnLogout.clipsToBounds = YES;
    [[_btnLogout layer] setBorderWidth:0.8f];
    [[_btnLogout layer] setBorderColor:[self colorFromHexString:@"#0097A7"].CGColor];

}
- (IBAction)goLogout:(id)sender {
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    [user setObject:@"0" forKey:@"login"];
    [user synchronize];
    [self.navigationController popToRootViewControllerAnimated:YES];
}
- (IBAction)goFriends:(id)sender {
    WPFriendsController *friendsController = [[WPFriendsController alloc] initWithNibName:@"WPFriendsController" bundle:nil];
    [self.navigationController pushViewController:friendsController animated:YES];
}
- (IBAction)goTracking:(id)sender {
    WPTrackController *trackController = [[WPTrackController alloc]initWithNibName:@"WPTrackController" bundle:nil];
    [self.navigationController pushViewController:trackController animated:YES];
}
-(void)goConfig{
    WPConfigurationController *configController = [[WPConfigurationController alloc]initWithNibName:@"WPConfigurationController" bundle:nil];
    [self.navigationController pushViewController:configController animated:YES];
}
- (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}
- (UIColor *)colorFromHexString:(NSString *)hexString {
    unsigned rgbValue = 0;
    NSScanner *scanner = [NSScanner scannerWithString:hexString];
    [scanner setScanLocation:1]; // bypass '#' character
    [scanner scanHexInt:&rgbValue];
    return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16)/255.0 green:((rgbValue & 0xFF00) >> 8)/255.0 blue:(rgbValue & 0xFF)/255.0 alpha:1.0];
}


@end
