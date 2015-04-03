//
//  UserInfoCell.h
//  BookLibrary
//
//  Created by Haibin Wang on 4/3/15.
//  Copyright (c) 2015 Haibin Wang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class User;

@interface UserInfoCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *avatar;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *cityLabel;
@property (weak, nonatomic) IBOutlet UILabel *mailLabel;
@property (weak, nonatomic) IBOutlet UILabel *logInfoLabel;

- (void)switchToLoginState:(User *)user;
- (void)switchToLogoutState;


@end
