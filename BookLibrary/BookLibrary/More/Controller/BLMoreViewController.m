//
//  BLMoreViewController.m
//  BookLibrary
//
//  Created by Haibin Wang on 4/3/15.
//  Copyright (c) 2015 Haibin Wang. All rights reserved.
//

#import "BLMoreViewController.h"
#import "LoginViewController.h"
#import "UserManager.h"
#import "UserInfoCell.h"
#import "UserOtherInfoCell.h"
#import "User.h"

@interface BLMoreViewController ()

@end

@implementation BLMoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    self.clearsSelectionOnViewWillAppear = YES;
    UserInfoCell *cell = (UserInfoCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    UserOtherInfoCell *otherInfoCell = (UserOtherInfoCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    User *user = nil; //[[UserManager sharedInstance] currentUser];
    
    if (user && user.user_id) {
        [cell switchToLoginState:user];
//        otherInfoCell.bookCount.text = user.book_count;
//        otherInfoCell.colleagueCount.text = user.friend_count;
    } else {
        [cell switchToLogoutState];
        otherInfoCell.bookCount.text = @"--";
        otherInfoCell.colleagueCount.text = @"--";
    }

}


#pragma mark - Table view data source

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//    // Return the number of sections.
//    return 0;
//}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    // Return the number of rows in the section.
//    return 0;
//}


//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    // Configure the cell...
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@""];
//    if (indexPath.section==0 && indexPath.row==0) {
//
//    }
//
//    return cell;
//}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    if (indexPath.section==0 && indexPath.row==0) {
        if (1/*![UserManager sharedInstance].currentUser*/) {
            UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
            LoginViewController *vc = (LoginViewController *) [sb instantiateInitialViewController];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}

@end
