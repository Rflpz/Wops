//
//  WPTrackController.m
//  Wops
//
//  Created by Rafael Lopez on 4/20/16.
//  Copyright © 2016 Rflpz. All rights reserved.
//

#import "WPTrackController.h"
#import <MapKit/MapKit.h>
#import "WPMenuController.h"
#import <CoreLocation/CoreLocation.h>
#define IS_IPHONE_4 (fabs((double)[[UIScreen mainScreen]bounds].size.height - (double)480) < DBL_EPSILON)
#define IS_IPHONE_5 (fabs((double)[[UIScreen mainScreen]bounds].size.height - (double)568) < DBL_EPSILON)
#define IS_IPHONE_6 (fabs((double)[[UIScreen mainScreen]bounds].size.height - (double)667) < DBL_EPSILON)
#define IS_IPHONE_6_PLUS (fabs((double)[[UIScreen mainScreen]bounds].size.height - (double)736) < DBL_EPSILON)
@interface WPTrackController ()<CLLocationManagerDelegate>
@property (weak, nonatomic) IBOutlet MKMapView *map;
@property (strong, nonatomic) CLLocationManager *locationManager;

@end

@implementation WPTrackController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"TRACKING";
    [self.navigationItem setHidesBackButton:YES];
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc]
                                   initWithImage:[[self imageWithImage:[UIImage imageNamed:@"menu_wops.png"] scaledToSize:CGSizeMake(35,35)] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]
                                   style:UIBarButtonItemStyleDone
                                   target:self
                                   action:@selector(goMenu)];
    self.navigationItem.leftBarButtonItem = leftButton;
    _map.tintColor = [self colorFromHexString:@"#0097A7"];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    _locationManager = [[CLLocationManager alloc] init];
    _locationManager.delegate = self;
    _locationManager.distanceFilter = kCLDistanceFilterNone;
    _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
        [self.locationManager requestWhenInUseAuthorization];
    [_locationManager startUpdatingLocation];

}
- (void)mapViewDidFinishLoadingMap:(MKMapView *)mapView {
    _map.userTrackingMode = MKUserTrackingModeFollowWithHeading;
}
-(void)goMenu{
    WPMenuController *menuController;
    if (IS_IPHONE_4) {
        menuController = [[WPMenuController alloc] initWithNibName:@"WPMenuView4" bundle:nil];
    }
    if (IS_IPHONE_5) {
        menuController = [[WPMenuController alloc] initWithNibName:@"WPMenuView5" bundle:nil];
    }
    if (IS_IPHONE_6) {
        menuController = [[WPMenuController alloc] initWithNibName:@"WPMenuView6" bundle:nil];
    }
    if (IS_IPHONE_6_PLUS) {
        menuController = [[WPMenuController alloc] initWithNibName:@"WPMenuView6Plus" bundle:nil];
    }
    [self.navigationController pushViewController:menuController animated:YES];
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
