//
//  WPLoginController.m
//  Wops
//
//  Created by Rafael Lopez on 4/20/16.
//  Copyright © 2016 Rflpz. All rights reserved.
//

#import "WPLoginController.h"
#import "WPRegisterController.h"
#import "WPTrackController.h"
#import "AFNetworking.h"
#import "KVNProgress.h"
@interface WPLoginController ()
@property (weak, nonatomic) IBOutlet UIButton *btnSingIn;
@property (weak, nonatomic) IBOutlet UIButton *btnSignUp;
@property (weak, nonatomic) IBOutlet UILabel *lblUser;
@property (weak, nonatomic) IBOutlet UILabel *lblPassword;
@property (strong, nonatomic) NSUserDefaults *user;

@end

@implementation WPLoginController
//e7ab85
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"LOGIN";
    [self.navigationItem setHidesBackButton:YES];
    self.navigationController.navigationBar.barTintColor = [self colorFromHexString:@"#FFFFFF"];
    self.navigationController.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:[self colorFromHexString:@"#212121"], NSForegroundColorAttributeName, [UIFont fontWithName:@"" size:20], NSFontAttributeName, nil];
    self.navigationController.navigationBar.translucent = NO;
    self.view.backgroundColor = [self colorFromHexString:@"#0097A7"];
    
    [_btnSingIn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _btnSingIn.backgroundColor = [self colorFromHexString:@"#7C4DFF"];
    _btnSingIn.layer.cornerRadius = 30;
    _btnSingIn.clipsToBounds = YES;
    [[_btnSingIn layer] setBorderWidth:0.8f];
    [[_btnSingIn layer] setBorderColor:[self colorFromHexString:@"#7C4DFF"].CGColor];
    
    [_btnSignUp setTitleColor:[self colorFromHexString:@"#0097A7"] forState:UIControlStateNormal];
    _btnSignUp.backgroundColor = [UIColor whiteColor];
    _btnSignUp.layer.cornerRadius = 30;
    _btnSignUp.clipsToBounds = YES;
    [[_btnSignUp layer] setBorderWidth:0.8f];
    [[_btnSignUp layer] setBorderColor:[self colorFromHexString:@"#0097A7"].CGColor];
    
    _lblUser.textColor = [self colorFromHexString:@"#B2EBF2"];
    _lblPassword.textColor = [self colorFromHexString:@"#B2EBF2"];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    _user = [NSUserDefaults standardUserDefaults];

    if (![[_user valueForKey:@"login"]isEqualToString:@"0"]) {
        WPTrackController *trackerController = [[WPTrackController alloc]initWithNibName:@"WPTrackController" bundle:nil];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.navigationController pushViewController:trackerController animated:YES];
        });
    }
}
- (UIColor *)colorFromHexString:(NSString *)hexString {
    unsigned rgbValue = 0;
    NSScanner *scanner = [NSScanner scannerWithString:hexString];
    [scanner setScanLocation:1]; // bypass '#' character
    [scanner scanHexInt:&rgbValue];
    return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16)/255.0 green:((rgbValue & 0xFF00) >> 8)/255.0 blue:(rgbValue & 0xFF)/255.0 alpha:1.0];
}
- (IBAction)sign:(id)sender {
    [KVNProgress showWithStatus:@"Verifying :)"];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer  serializer];
    manager.requestSerializer =  [AFHTTPRequestSerializer serializer];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:@"rflpzdev@gmail.com" forKey:@"email"];
    [params setObject:@"polaco79" forKey:@"password"];
    
    [manager POST:@"http://wops.com.mx/sistema/index.php/mobiles/login" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [[NSOperationQueue mainQueue] addOperationWithBlock:^ {
            NSDictionary *responseData;
            NSError *error = nil;
            if (responseObject != nil) {
                responseData = [NSJSONSerialization JSONObjectWithData:responseObject
                                                               options:NSJSONReadingMutableContainers
                                                                 error:&error];
            }
            if (!responseData) {
                NSLog(@"Error");
                
            }else{
                NSLog(@"%@",responseData);
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    
                    if ([responseData valueForKey:@"error"]) {
                        [KVNProgress showErrorWithStatus:@"Verify your credentials :(" completion:^(void){
                            [KVNProgress dismiss];
                        }];
                    }else{
                        [KVNProgress showSuccessWithStatus:@"Done!" completion:^(void){
                            NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
                            [user setObject:responseData forKey:@"user"];
                            [user setObject:@"1" forKey:@"login"];
                            WPTrackController *trackerController = [[WPTrackController alloc]initWithNibName:@"WPTrackController" bundle:nil];
                            [self.navigationController pushViewController:trackerController animated:YES];
                        }];
                    }
                });
            }
        }];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        [KVNProgress showErrorWithStatus:@"Verify your internet connection" completion:^(void){
            [KVNProgress dismiss];
        }];
    }];
}
- (IBAction)goToSignUp:(id)sender {
    WPRegisterController *registerController = [[WPRegisterController alloc]initWithNibName:@"WPRegisterController" bundle:nil];
    [self.navigationController pushViewController:registerController animated:YES];
}
- (IBAction)validateUser:(id)sender {
    WPTrackController *trackController = [[WPTrackController alloc]initWithNibName:@"WPTrackController" bundle:nil];
    [self.navigationController pushViewController:trackController animated:YES];
}
- (IBAction)hideKeyboard:(id)sender {
    [self resignFirstResponder];
}
- (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}
@end
