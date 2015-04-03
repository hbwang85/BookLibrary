//
// Created by Haibin Wang on 4/1/15.
// Copyright (c) 2015 Haibin Wang. All rights reserved.
//

#import <RestKit/Network/RKObjectManager.h>
#import "UserManager.h"
#import "ApplicationConstants.h"
#import "RKRequestDescriptor.h"
#import "Account.h"
#import "User.h"
#import "RKResponseDescriptor.h"

@interface UserManager()

@property (nonatomic, strong) RKObjectManager *userObjectManager;
@property (nonatomic, strong) User *currentUser;

@end


@implementation UserManager
+ (instancetype)sharedInstance {
    static UserManager *_instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[UserManager alloc] init];
    });

    return _instance;
}

- (void)registerWithMail:(NSString *)mail passwd:(NSString *)passwd success:(void(^)(User *user))successBlock failure:(void(^)(NSError *error))failureBlock{
    Account *account = [Account new];
    account.mail = mail;
    account.passwd = passwd;

    typeof(self) weakSelf = self;
    [_userObjectManager postObject:account
                              path:@"/register"
                        parameters:nil
                           success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {

                               NSArray *array = mappingResult.array;
                               User *user = array[0];
                               weakSelf.currentUser = user;
                               successBlock(user);
                           }
                           failure:^(RKObjectRequestOperation *operation, NSError *error) {
                               failureBlock(error);
                           }];

}

- (void)loginWithMail:(NSString *)mail passwd:(NSString *)passwd success:(void (^)(User *user))successBlock failure:(void (^)(NSError *error))failureBlock {
    Account *account = [Account new];
    account.mail = @"1@5.com";
    account.passwd = @"111111";
    
    typeof(self) weakSelf = self;

    [_userObjectManager postObject:account
                              path:@"/login"
                        parameters:nil
                           success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                               NSArray *array = mappingResult.array;
                               weakSelf.currentUser = array[0];
                               successBlock(array[0]);

                           } failure:^(RKObjectRequestOperation *operation, NSError *error) {
                failureBlock(error);
            }];

}


- (instancetype)init {
    self = [super init];
    if (self){
        _userObjectManager = [RKObjectManager managerWithBaseURL:[NSURL URLWithString:kBaseURL]];
//        [_userObjectManager.HTTPClient setDefaultHeader:@"Content-Type" value:@"application/json"];

        RKObjectMapping *requestMapping = [RKObjectMapping requestMapping];
        [requestMapping addAttributeMappingsFromDictionary:@{@"mail": @"email",
        @"passwd": @"password"}];

        RKRequestDescriptor *requestDescriptor = [RKRequestDescriptor requestDescriptorWithMapping:requestMapping
                                                                                       objectClass:[Account class]
                                                                                       rootKeyPath:nil
                                                                                            method:RKRequestMethodPOST];
        RKObjectMapping *responseMapping = [RKObjectMapping mappingForClass:[User class]];
        [responseMapping addAttributeMappingsFromArray:@[@"user_id", @"user_name", @"user_email", @"book_count", @"location",
        @"friend_count", @"access_token", @"group_name", @"avatar_url", @"phone_number"]];
        RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:responseMapping
                                                                                                method:RKRequestMethodPOST
                                                                                           pathPattern:@"/register"
                                                                                               keyPath:nil
                                                                                           statusCodes:[NSIndexSet indexSetWithIndex:200]];
        [_userObjectManager addRequestDescriptor:requestDescriptor];
        [_userObjectManager addResponseDescriptor:responseDescriptor];
    }

    return self;
}


@end
