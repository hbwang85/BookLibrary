//
//  LoginViewController.m
//  BookLibrary
//
//  Created by Haibin Wang on 3/31/15.
//  Copyright (c) 2015 Haibin Wang. All rights reserved.
//

#import "LoginViewController.h"
#import "UserManager.h"

@interface LoginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *mailField;
@property (weak, nonatomic) IBOutlet UITextField *passwdField;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)login:(UIButton *)sender {
    [[UserManager sharedInstance] loginWithMail:@""
                                         passwd:@""
                                        success:^(User *user) {
    }
                                        failure:^(NSError *error) {

                                        }];
}


@end
