//
//  UserInfoCell.m
//  BookLibrary
//
//  Created by Haibin Wang on 4/3/15.
//  Copyright (c) 2015 Haibin Wang. All rights reserved.
//

#import "UserInfoCell.h"
#import "User.h"

@implementation UserInfoCell

- (void)awakeFromNib {
    // Initialization code
    [self switchToLogoutState];
}

- (id)init{
    self = [super init];
    if (self) {
        [self switchToLogoutState];
    }

    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)switchToLoginState:(User *)user {
    _avatar.image = [UIImage imageNamed:@"log-in-user.png"];
    _cityLabel.hidden = NO;
    _cityLabel.text = @"Xi'an";
    _logInfoLabel.hidden = YES;
    _mailLabel.hidden = NO;
    _mailLabel.text = user.user_email;
    _nameLabel.hidden = NO;
    _nameLabel.text = user.user_name;
}

- (void)switchToLogoutState {
    _avatar.image = [UIImage imageNamed:@"log-out-user.png"];
    _cityLabel.hidden = YES;
    _logInfoLabel.hidden = NO;
    _mailLabel.hidden = YES;
    _nameLabel.hidden = YES;
}


@end
