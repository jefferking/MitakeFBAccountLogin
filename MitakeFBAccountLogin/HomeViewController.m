//
//  HomeViewController.m
//  MitakeFBAccountLogin
//
//  Created by 金融研發一部-林忠賢 on 2017/6/16.
//  Copyright © 2017年 金融研發一部-林忠賢. All rights reserved.
//

#import "HomeViewController.h"
#import <AccountKit/AccountKit.h>

@interface HomeViewController ()
@property (strong, nonatomic) IBOutlet UIButton *logoutButton;
@property (nonatomic, copy) AKFAccountKit *accountKit;
@property (strong, nonatomic) IBOutlet UILabel *accountLabel;
@property (strong, nonatomic) IBOutlet UILabel *phoneMailLabel;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *valueLabel;



@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if (_accountKit == nil) {
        // may also specify AKFResponseTypeAccessToken
        _accountKit = [[AKFAccountKit alloc] initWithResponseType:AKFResponseTypeAccessToken];
    }
    [_accountKit requestAccount:^(id<AKFAccount> account, NSError *error) {
        // account ID
        self.accountLabel.text = account.accountID;
        if ([account.emailAddress length] > 0) {
            self.titleLabel.text = @"Email Address";
            self.valueLabel.text = account.emailAddress;
        }
        else if ([account phoneNumber] != nil) {
            self.titleLabel.text = @"Phone Number";
            self.valueLabel.text = [[account phoneNumber] stringRepresentation];
        }
    }];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)logoutAction:(id)sender {
    [_accountKit logOut];
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
