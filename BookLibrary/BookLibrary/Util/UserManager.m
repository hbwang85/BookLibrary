//
// Created by Haibin Wang on 4/1/15.
// Copyright (c) 2015 Haibin Wang. All rights reserved.
//

#import <CoreData/CoreData.h>
#import <RestKit/CoreData/RKCoreData.h>
#import <RestKit/Network/RKObjectManager.h>
#import "UserManager.h"
#import "ApplicationConstants.h"
#import "RKRequestDescriptor.h"
#import "Account.h"
#import "User.h"
#import "RKResponseDescriptor.h"


@interface UserManager()

@property (nonatomic, strong) RKObjectManager *userObjectManager;

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

- (void)registerWithMail:(NSString *)mail passwd:(NSString *)passwd success:(void(^)(User *user))successBlock failure:(void(^)(NSError *error))failureBlock {

    RKEntityMapping *entityMapping = [RKEntityMapping mappingForEntityForName:@"User" inManagedObjectStore:self.userObjectManager.managedObjectStore];
    [entityMapping addAttributeMappingsFromArray:@[@"user_id", @"user_name", @"user_email", @"book_count", @"location",
            @"friend_count", @"access_token", @"group_name", @"avatar_url", @"phone_number"]];
    entityMapping.identificationAttributes = @[@"user_id"];
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:entityMapping
                                                                                            method:RKRequestMethodPOST
                                                                                       pathPattern:@"/register"
                                                                                           keyPath:nil
                                                                                       statusCodes:[NSIndexSet indexSetWithIndex:200]];
    [_userObjectManager addResponseDescriptor:responseDescriptor];


    Account *account = [Account new];
    account.mail = @"2@iou.com";
    account.passwd = @"888888";

    __weak typeof(self) weakSelf = self;
    [_userObjectManager postObject:account
                              path:@"/register"
                        parameters:nil
                           success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {

                               NSArray *array = mappingResult.array;
                               User *user = array[0];
//                               [weakSelf saveCurrentUser:user];
                               successBlock(user);
                           }
                           failure:^(RKObjectRequestOperation *operation, NSError *error) {
                               failureBlock(error);
                           }];



}




/*
- (void)registerWithMail:(NSString *)mail passwd:(NSString *)passwd success:(void(^)(User *user))successBlock failure:(void(^)(NSError *error))failureBlock{
//    Account *account = [Account new];
//    account.mail = mail;
//    account.passwd = passwd;
//
//    __weak typeof(self) weakSelf = self;
//    [_userObjectManager postObject:account
//                              path:@"/register"
//                        parameters:nil
//                           success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
//
//                               NSArray *array = mappingResult.array;
//                               User *user = array[0];
//                               [weakSelf saveCurrentUser:user];
//                               successBlock(user);
//                           }
//                           failure:^(RKObjectRequestOperation *operation, NSError *error) {
//                               failureBlock(error);
//                           }];


    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://localhost:3000/register"]];
    request.HTTPMethod = @"POST";
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    request.HTTPBody = [NSJSONSerialization dataWithJSONObject:@{@"email":@"1@31.com",
    @"password":@"121212"}
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:nil];

//    RKObjectMapping *responseMapping = [RKObjectMapping mappingForClass:[User class]];
//    [responseMapping addAttributeMappingsFromArray:@[@"user_id", @"user_name", @"user_email", @"book_count", @"location",
//                @"friend_count", @"access_token", @"group_name", @"avatar_url", @"phone_number"]];
//    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:responseMapping
//                                                                                            method:RKRequestMethodPOST
//                                                                                       pathPattern:@"/register"
//                                                                                           keyPath:nil
//                                                                                       statusCodes:[NSIndexSet indexSetWithIndex:200]];

    
    NSURL *modelURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"bookLib" ofType:@"momd"]];
    NSManagedObjectModel *managedObjectModel = [[[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL] mutableCopy];
    RKManagedObjectStore *managedObjectStore = [[RKManagedObjectStore alloc] initWithManagedObjectModel:managedObjectModel];
    [managedObjectStore createPersistentStoreCoordinator];
    
    NSError *error = nil;
    NSPersistentStore __unused *persistentStore = [managedObjectStore addInMemoryPersistentStore:&error];
    [managedObjectStore createManagedObjectContexts];
    
//    _userObjectManager.managedObjectStore = managedObjectStore;
    RKEntityMapping *entityMapping = [RKEntityMapping mappingForEntityForName:@"User" inManagedObjectStore:managedObjectStore];
    [entityMapping addAttributeMappingsFromArray:@[@"user_id", @"user_name", @"user_email", @"book_count", @"location",
                                                   @"friend_count", @"access_token", @"group_name", @"avatar_url", @"phone_number"]];
    entityMapping.identificationAttributes = @[@"user_id"];
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:entityMapping
                                                                                            method:RKRequestMethodPOST
                                                                                       pathPattern:@"/register"
                                                                                           keyPath:nil
                                                                                       statusCodes:[NSIndexSet indexSetWithIndex:200]];
    
    RKObjectRequestOperation *operation = [[RKObjectRequestOperation alloc] initWithRequest:request
                                                                        responseDescriptors:@[responseDescriptor]];

    [operation setCompletionBlockWithSuccess:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {

    } failure:^(RKObjectRequestOperation *operation, NSError *error) {

    }];

    [operation start];

}
*/


- (void)loginWithMail:(NSString *)mail passwd:(NSString *)passwd success:(void (^)(User *user))successBlock failure:(void (^)(NSError *error))failureBlock {
    Account *account = [Account new];
    account.mail = @"1@51.com";
    account.passwd = @"111111";
    
    typeof(self) weakSelf = self;

    [_userObjectManager postObject:account
                              path:@"/login"
                        parameters:nil
                           success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                               NSArray *array = mappingResult.array;
                               [weakSelf saveCurrentUser:array[0]];
                               successBlock(array[0]);

                           } failure:^(RKObjectRequestOperation *operation, NSError *error) {
                failureBlock(error);
            }];

}

- (void)saveCurrentUser:(User *)user {
//    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"ActiveUser" ofType:@"plist"];
//    NSDictionary *dict = @{@"user_id" : user.user_id,
//            @"user_name" : user.user_name,
//            @"user_email" : user.user_email,
//            @"book_count" : user.book_count,
//            @"access_token" : user.access_token,
//            @"avatar_url" : user.avatar_url,
//            @"friend_count" : user.friend_count,
//            @"group_name" : user.group_name,
//            @"location" : user.location};
//    [dict writeToFile:filePath atomically:YES];
    
    [[NSUserDefaults standardUserDefaults] setObject:user.user_id forKey:kUserID];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

//- (User *)currentUser {
//    User *user = [[User alloc] init];
//    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"ActiveUser" ofType:@"plist"];
//    if (![[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
//        user = nil;
//    } else {
//    }

//    return user;
//}

- (instancetype)init{
    self = [super init];
    if (self) {
        _userObjectManager = [RKObjectManager managerWithBaseURL:[NSURL URLWithString:kBaseURL]];

        RKObjectMapping *requestMapping = [RKObjectMapping requestMapping];
        [requestMapping addAttributeMappingsFromDictionary:@{@"mail": @"email",
                @"passwd": @"password"}];

        RKRequestDescriptor *requestDescriptor = [RKRequestDescriptor requestDescriptorWithMapping:requestMapping
                                                                                       objectClass:[Account class]
                                                                                       rootKeyPath:nil
                                                                                            method:RKRequestMethodPOST];
        [_userObjectManager addRequestDescriptor:requestDescriptor];

        NSURL *modelURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"bookLib" ofType:@"momd"]];
        NSManagedObjectModel *managedObjectModel = [[[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL] mutableCopy];
        RKManagedObjectStore *managedObjectStore = [[RKManagedObjectStore alloc] initWithManagedObjectModel:managedObjectModel];
        [managedObjectStore createPersistentStoreCoordinator];

        NSError *error = nil;
        NSPersistentStore __unused *persistentStore = [managedObjectStore addInMemoryPersistentStore:&error];
        [managedObjectStore createManagedObjectContexts];

        _userObjectManager.managedObjectStore = managedObjectStore;


    }

    return self;
}



/*
- (instancetype)init {
    self = [super init];
    if (self){
        _userObjectManager = [RKObjectManager managerWithBaseURL:[NSURL URLWithString:kBaseURL]];
//        [_userObjectManager.HTTPClient setDefaultHeader:@"Content-Type" value:@"application/json"];

        RKObjectMapping *requestMapping = [RKObjectMapping mappingForClass:[Account class]];
        [requestMapping addAttributeMappingsFromDictionary:@{@"mail": @"email",
        @"passwd": @"password"}];

        RKRequestDescriptor *requestDescriptor = [RKRequestDescriptor requestDescriptorWithMapping:requestMapping
                                                                                       objectClass:[Account class]
                                                                                       rootKeyPath:nil
                                                                                            method:RKRequestMethodPOST];
//        RKObjectMapping *responseMapping = [RKObjectMapping mappingForClass:[User class]];
//        [responseMapping addAttributeMappingsFromArray:@[@"user_id", @"user_name", @"user_email", @"book_count", @"location",
//        @"friend_count", @"access_token", @"group_name", @"avatar_url", @"phone_number"]];
//        RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:responseMapping
//                                                                                                method:RKRequestMethodPOST
//                                                                                           pathPattern:@"/register"
//                                                                                               keyPath:nil
//                                                                                           statusCodes:[NSIndexSet indexSetWithIndex:200]];
        [_userObjectManager addRequestDescriptor:requestDescriptor];
//        [_userObjectManager addResponseDescriptor:responseDescriptor];
        
        NSURL *modelURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"bookLib" ofType:@"momd"]];
        
        NSManagedObjectModel *managedObjectModel = [[[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL] mutableCopy];
        RKManagedObjectStore *managedObjectStore = [[RKManagedObjectStore alloc] initWithManagedObjectModel:managedObjectModel];
        [managedObjectStore createPersistentStoreCoordinator];

        NSError *error = nil;
        NSPersistentStore __unused *persistentStore = [managedObjectStore addInMemoryPersistentStore:&error];
        [managedObjectStore createManagedObjectContexts];

        _userObjectManager.managedObjectStore = managedObjectStore;
        RKEntityMapping *entityMapping = [RKEntityMapping mappingForEntityForName:@"User" inManagedObjectStore:managedObjectStore];
        [entityMapping addAttributeMappingsFromArray:@[@"user_id", @"user_name", @"user_email", @"book_count", @"location",
        @"friend_count", @"access_token", @"group_name", @"avatar_url", @"phone_number"]];
        entityMapping.identificationAttributes = @[@"user_id"];
        RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:entityMapping
                                                                                                method:RKRequestMethodPOST
                                                                                           pathPattern:@"/register"
                                                                                               keyPath:nil
                                                                                           statusCodes:[NSIndexSet indexSetWithIndex:200]];
        [_userObjectManager addResponseDescriptor:responseDescriptor];
    };

    return self;
}
*/

- (User *)currentUser{
    NSString *userID = [[NSUserDefaults standardUserDefaults] stringForKey:kUserID];
    if (userID) {
        User *user = [User new];
        user.user_id = userID;
        
        return user;

    }
    
    return nil;
}


@end
