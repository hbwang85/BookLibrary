//
//  RegisterViewController.m
//  BookLibrary
//
//  Created by Haibin Wang on 3/31/15.
//  Copyright (c) 2015 Haibin Wang. All rights reserved.
//

#import "RegisterViewController.h"
#import "UserManager.h"

@interface RegisterViewController ()
@property (weak, nonatomic) IBOutlet UITextField *mailField;
@property (weak, nonatomic) IBOutlet UITextField *passwdField;
@property (weak, nonatomic) IBOutlet UITextField *passwdConfirmField;
@property (weak, nonatomic) IBOutlet UIButton *registerButton;

@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)register:(UIButton *)sender {
    __weak typeof(self) weakSelf = self;
    [[UserManager sharedInstance] registerWithMail:_mailField.text
                                            passwd:_passwdField.text
                                           success:^(User *user) {
                                               [self.navigationController popToRootViewControllerAnimated:YES];
                                           } failure:^(NSError *error) {

            }];

}



@end
