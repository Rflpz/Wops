//
//  WPRegisterController.m
//  Wops
//
//  Created by Rafael Lopez on 4/20/16.
//  Copyright © 2016 Rflpz. All rights reserved.
//

#import "WPRegisterController.h"
#import "AFNetworking.h"
#import "KVNProgress.h"
#import "WPTrackController.h"
#import "MMNumberKeyboard.h"

@interface WPRegisterController ()<MMNumberKeyboardDelegate>
@property (weak, nonatomic) IBOutlet UIButton *btnSignUp;
@property (weak, nonatomic) IBOutlet UILabel *lblUsername;
@property (weak, nonatomic) IBOutlet UILabel *lblPassword;
@property (weak, nonatomic) IBOutlet UILabel *lblName;
@property (weak, nonatomic) IBOutlet UILabel *lblPhone;
@property (weak, nonatomic) IBOutlet UITextField *txtUser;
@property (weak, nonatomic) IBOutlet UITextField *txtPassword;
@property (weak, nonatomic) IBOutlet UITextField *txtName;
@property (weak, nonatomic) IBOutlet UITextField *txtPhone;

@end

@implementation WPRegisterController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"SIGN UP";
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc]
                                   initWithImage:[[self imageWithImage:[UIImage imageNamed:@"back_wops.png"] scaledToSize:CGSizeMake(35,35)] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]
                                   style:UIBarButtonItemStyleDone
                                   target:self
                                   action:@selector(goBack)];
    self.navigationItem.leftBarButtonItem = leftButton;
    
    self.view.backgroundColor = [self colorFromHexString:@"#0097A7"];
    [_btnSignUp setTitleColor:[self colorFromHexString:@"#0097A7"] forState:UIControlStateNormal];
    _btnSignUp.backgroundColor = [UIColor whiteColor];
    _btnSignUp.layer.cornerRadius = 30;
    _btnSignUp.clipsToBounds = YES;
    [[_btnSignUp layer] setBorderWidth:0.8f];
    [[_btnSignUp layer] setBorderColor:[self colorFromHexString:@"#0097A7"].CGColor];
    
    _lblPassword.textColor = [self colorFromHexString:@"#B2EBF2"];
    _lblName.textColor = [self colorFromHexString:@"#B2EBF2"];
    _lblUsername.textColor = [self colorFromHexString:@"#B2EBF2"];
    _lblPhone.textColor = [self colorFromHexString:@"#B2EBF2"];
    MMNumberKeyboard *keyboard = [[MMNumberKeyboard alloc] initWithFrame:CGRectZero];
    keyboard.allowsDecimalPoint = NO;
    keyboard.delegate = self;
    _txtPhone.inputView = keyboard;
}
-(void)goBack{
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)registerUser:(id)sender {
    [KVNProgress showWithStatus:@"Wait a minute :)"];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer  serializer];
    manager.requestSerializer =  [AFHTTPRequestSerializer serializer];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
//    [params setObject:_txtName.textColor forKey:@"name"];
//    [params setObject:_txtUser.text forKey:@"email"];
//    [params setObject:_txtPhone.text forKey:@"numero"];
//    [params setObject:_txtPassword.text forKey:@"password"];
    [params setObject:@"Rafael" forKey:@"name"];
    [params setObject:@"rflpzdev@zavordigital.com" forKey:@"email"];
    [params setObject:@"3121032965" forKey:@"numero"];
    [params setObject:@"polaco78" forKey:@"password"];
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    [params setObject:[user valueForKeyPath:@"token"] forKey:@"token"];

    [manager POST:@"http://wops.com.mx/sistema/index.php/mobiles/register" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
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
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [KVNProgress showSuccessWithStatus:@"Done!" completion:^(void){
                        WPTrackController *trackerController = [[WPTrackController alloc]initWithNibName:@"WPTrackController" bundle:nil];
                        [self.navigationController pushViewController:trackerController animated:YES];
                    }];
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

- (IBAction)hideKeyboard:(id)sender {
    [self resignFirstResponder];
}
@end
