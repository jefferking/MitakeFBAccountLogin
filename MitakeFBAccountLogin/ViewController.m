//
//  ViewController.m
//  MitakeFBAccountLogin
//
//  Created by 金融研發一部-林忠賢 on 2017/6/15.
//  Copyright © 2017年 金融研發一部-林忠賢. All rights reserved.
//

#import "ViewController.h"
#import <AccountKit/AccountKit.h>
#import "HomeViewController.h"

@interface ViewController () <AKFViewControllerDelegate>
{
}

@property (nonatomic, copy) AKFAccountKit *accountKit;
@property (nonatomic, strong) UIViewController <AKFViewController> *pendingLoginViewController;
@property (nonatomic, copy) NSString *authCode;
@property (strong, nonatomic) IBOutlet UIButton *emailButton;
@property (strong, nonatomic) IBOutlet UIButton *phoneButton;

@end

@implementation ViewController {

    
}

//- (AKFAccountKit *)accountKit {
//    if (_accountKit == nil) {
//        // may also specify AKFResponseTypeAccessToken
//        _accountKit = [[AKFAccountKit alloc] initWithResponseType:AKFResponseTypeAccessToken];
//    }
//    return _accountKit;
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    if (_accountKit == nil) {
        // may also specify AKFResponseTypeAccessToken
        _accountKit = [[AKFAccountKit alloc] initWithResponseType:AKFResponseTypeAccessToken];
    }
    
    _pendingLoginViewController = [_accountKit viewControllerForLoginResume];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (_accountKit.currentAccessToken != nil) {
        HomeViewController *homeScreen = [[HomeViewController alloc]initWithNibName:@"HomeViewController" bundle:nil];
        [self presentViewController:homeScreen animated:YES completion:nil];
    } else if (_pendingLoginViewController != nil) {
        [self prepareLoginViewController:_pendingLoginViewController];
        [self presentViewController:_pendingLoginViewController animated:YES completion:nil];
        _pendingLoginViewController = nil;
    }
}

- (void)isUserLoggedIn {
    [_accountKit  accountPreferences];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareLoginViewController:(UIViewController<AKFViewController> *)loginViewocntroller {
    loginViewocntroller.delegate = self;
    loginViewocntroller.uiManager = nil;
//    AKFTheme *theme = [AKFTheme outlineThemeWithPrimaryColor:[UIColor yellowColor] primaryTextColor:[UIColor blackColor] secondaryTextColor:[UIColor blueColor] statusBarStyle:UIStatusBarStyleDefault];
//    [loginViewocntroller setTheme:theme];
}

#pragma AFKViewController Delegate
// handle callbacks on successful login to show account
- (void)viewController:(UIViewController<AKFViewController> *)viewController
  didCompleteLoginWithAccessToken:(id<AKFAccessToken>)accessToken
                            state:(NSString *)state
{
    HomeViewController *homeScreen = [[HomeViewController alloc]initWithNibName:@"HomeViewController" bundle:nil];
    [self presentViewController:homeScreen animated:YES completion:nil];
    
}

- (void)viewController:(UIViewController<AKFViewController> *)viewController didFailWithError:(NSError *)error
{
    // ... implement appropriate error handling ...
    NSLog(@"%@ did fail with error: %@", viewController, error);
}

- (void)viewControllerDidCancel:(UIViewController<AKFViewController> *)viewController
{
     NSLog(@"cancel: %@", viewController);
}


- (IBAction)emailButtonAction:(id)sender {
    NSString *inputState = [[NSUUID UUID] UUIDString];
    UIViewController<AKFViewController> *vc = [_accountKit viewControllerForEmailLoginWithEmail:@"" state:inputState];
    [self prepareLoginViewController:vc];
    [self presentViewController:vc animated:YES completion:NULL];
    
}
- (IBAction)phoneButtonAction:(id)sender {
    AKFPhoneNumber *phoneNumber = [[AKFPhoneNumber alloc] initWithCountryCode:@"+886" phoneNumber:@"0988709816"];
    NSString *inputState = [[NSUUID UUID] UUIDString];
    UIViewController<AKFViewController>* vc = [_accountKit viewControllerForPhoneLoginWithPhoneNumber:phoneNumber state:inputState];
    //default is NO
    vc.enableSendToFacebook = YES;
    [self prepareLoginViewController:vc];
//    [self.navigationController pushViewController:vc animated:YES];
    [self presentViewController:vc animated:YES completion:nil];
}

@end
