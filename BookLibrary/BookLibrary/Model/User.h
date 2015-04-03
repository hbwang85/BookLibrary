//
// Created by Haibin Wang on 4/1/15.
// Copyright (c) 2015 Haibin Wang. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface User : NSObject
@property (nonatomic, copy) NSString *user_id;
@property (nonatomic, copy) NSString *user_name;
@property (nonatomic, copy) NSString *user_email;
@property (nonatomic, copy) NSString *book_count;
@property (nonatomic, copy) NSString *friend_count;
@property (nonatomic, copy) NSString *access_token;
@property (nonatomic, copy) NSString *group_name;
@property (nonatomic, copy) NSString *avatar_url;
@property (nonatomic, copy) NSString *phone_number;
@property (nonatomic, copy) NSString *location;

@end