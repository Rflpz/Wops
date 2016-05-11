//
//  WPFriendsController.m
//  Wops
//
//  Created by Rafael Lopez on 4/20/16.
//  Copyright © 2016 Rflpz. All rights reserved.
//

#import "WPFriendsController.h"
#import "WPFriendCell.h"
#import "Wops-Swift.h"
#import "AFNetworking.h"
#import "KVNProgress.h"
#import "MMNumberKeyboard.h"

@interface WPFriendsController ()<UITableViewDelegate, UITableViewDataSource, MMNumberKeyboardDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonnull)     YBAlertController *alert;
@end

@implementation WPFriendsController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"FRIENDS";
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc]
                                   initWithImage:[[self imageWithImage:[UIImage imageNamed:@"back_wops.png"] scaledToSize:CGSizeMake(35,35)] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]
                                   style:UIBarButtonItemStyleDone
                                   target:self
                                   action:@selector(goBack)];
    self.navigationItem.leftBarButtonItem = leftButton;
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc]
                                   initWithImage:[[self imageWithImage:[UIImage imageNamed:@"add_friend_wops.png"] scaledToSize:CGSizeMake(35,35)] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]
                                   style:UIBarButtonItemStyleDone
                                   target:self
                                   action:@selector(showModal)];
    self.navigationItem.rightBarButtonItem = rightButton;
    self.view.backgroundColor = [self colorFromHexString:@"#0097A7"];
    _tableView.backgroundColor = [UIColor clearColor];
    [self animateTable];
   
}
-(void)goBack{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)addByEmail{

}
-(void)addByPhone{
   // http://wops.com.mx/sistema/index.php/mobiles/agrega_amigo
    [_alert dismiss];
    UIAlertController* alertController = [UIAlertController
                                          alertControllerWithTitle:@"Add friend"
                                          message:@"Write the phone number"
                                          preferredStyle:UIAlertControllerStyleAlert];
    [alertController addTextFieldWithConfigurationHandler: ^(UITextField *tf){
         MMNumberKeyboard *keyboard = [[MMNumberKeyboard alloc] initWithFrame:CGRectZero];
         keyboard.allowsDecimalPoint = NO;
         keyboard.delegate = self;
         tf.inputView = keyboard;
     }];
    UIAlertAction* ok = [UIAlertAction actionWithTitle:@"Add" style:UIAlertActionStyleDefault
                                               handler:^(UIAlertAction * action){
                                                   UITextField *textField = alertController.textFields[0];
                                                   NSLog(@"text was %@", textField.text);
                                                   
                                               }];
    UIAlertAction* cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDestructive
                                                   handler:^(UIAlertAction * action) {
                                                       
                                                       NSLog(@"cancel btn");
                                                       
                                                       [alertController dismissViewControllerAnimated:YES completion:nil];
                                                       
                                                   }];
    
    [alertController addAction:ok];
    [alertController addAction:cancel];
    [self presentViewController:alertController animated:YES completion:nil];
}
- (void)addContactWithPhone:(UIAlertAction *) alert{
    
}
-(void)showModal{
    _alert = [[YBAlertController alloc] init];
    [_alert addButton:[UIImage imageNamed:@"call_wops.png"] title:@"Add by phone" target:self selector:@selector(addByPhone)];
    [_alert addButton:[UIImage imageNamed:@"mail_wops.png"] title:@"Add by email" target:self selector:@selector(addByEmail)];
    _alert.cancelButtonTitle = @"Cancel";
    _alert.cancelButtonTextColor = [self colorFromHexString:@"#0097A7"];
    [_alert show];
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
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifierCustom = @"WPFriendCell";
    
    WPFriendCell *cell = (WPFriendCell *)[tableView dequeueReusableCellWithIdentifier:identifierCustom];
    if (cell == nil){
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:identifierCustom owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    UILabel *leftObj = [[UILabel alloc] initWithFrame:CGRectMake(0,-3,10,109)];
    leftObj.layer.cornerRadius = 2;
    leftObj.clipsToBounds = YES;
    if (indexPath.row % 2 == 0) {
        cell.backgroundColor = [self colorFromHexString:@"#7C4DFF"];
        leftObj.backgroundColor = [self colorFromHexString:@"#0097A7"];
        cell.lblEmailUser.textColor = [self colorFromHexString:@"#212121"];
        cell.lblPhoneUser.textColor = [self colorFromHexString:@"#FFFFFF"];
        cell.lblNameUser.textColor = [self colorFromHexString:@"#FFFFFF"];
    }else{
        leftObj.backgroundColor = [self colorFromHexString:@"#0097A7"];
        cell.lblEmailUser.textColor = [self colorFromHexString:@"#212121"];
        cell.lblPhoneUser.textColor = [self colorFromHexString:@"#0097A7"];
        cell.lblNameUser.textColor = [self colorFromHexString:@"#0097A7"];
        cell.backgroundColor = [UIColor whiteColor];
    }
    [cell addSubview:leftObj];

    [cell setNeedsUpdateConstraints];
    [cell updateConstraintsIfNeeded];
    return cell;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectio{
    return 10;
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [_tableView deselectRowAtIndexPath:indexPath animated:YES];
}
- (void)animateTable{
    [_tableView reloadData];
    NSArray *cells = _tableView.visibleCells;
    ;
    for (UITableViewCell  *cell in cells) {
        cell.transform = CGAffineTransformMakeTranslation(0, _tableView.bounds.size.height);
    }
    int index = 0;
    for (UITableViewCell  *cell in cells) {
        [UIView animateWithDuration:1.5f delay:0.05f * index
             usingSpringWithDamping:0.8f initialSpringVelocity:0.0f
                            options:0 animations:^{
                                cell.transform = CGAffineTransformMakeTranslation(0, 0);
                            } completion:nil];
        index++;
    }
}

@end
