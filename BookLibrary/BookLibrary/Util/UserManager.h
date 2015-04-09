//
// Created by Haibin Wang on 4/1/15.
// Copyright (c) 2015 Haibin Wang. All rights reserved.
//

#import <Foundation/Foundation.h>

@class User;


@interface UserManager : NSObject

//@property (nonatomic, strong, readonly) User *currentUser;


+ (instancetype)sharedInstance;



- (void)registerWithMail:(NSString *)mail passwd:(NSString *)passwd success:(void(^)(User *user))successBlock failure:(void(^)(NSError *error))failureBlock;

- (void)loginWithMail:(NSString *)mail passwd:(NSString *)passwd success:(void(^)(User *user))successBlock failure:(void(^)(NSError *error))failureBlock;

- (void)saveCurrentUser:(User *)user;

- (User *)currentUser;

@end