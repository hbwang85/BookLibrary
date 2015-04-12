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
#import "RKPathUtilities.h"


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
    account.mail = mail;
    account.passwd = passwd;

    __weak typeof(self) weakSelf = self;
    [_userObjectManager postObject:account
                              path:@"/register"
                        parameters:nil
                           success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {

                               NSArray *array = mappingResult.array;
                               User *user = array[0];
                               [weakSelf saveLoginUserID:user];
                               successBlock(user);
                           }
                           failure:^(RKObjectRequestOperation *operation, NSError *error) {
                               failureBlock(error);
                           }];
}


- (void)loginWithMail:(NSString *)mail passwd:(NSString *)passwd success:(void (^)(User *user))successBlock failure:(void (^)(NSError *error))failureBlock {
    Account *account = [Account new];
    account.mail = @"1@51.com";
    account.passwd = @"111111";

    [_userObjectManager postObject:account
                              path:@"/login"
                        parameters:nil
                           success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                               NSArray *array = mappingResult.array;
                               successBlock(array[0]);

                           } failure:^(RKObjectRequestOperation *operation, NSError *error) {
                failureBlock(error);
            }];

}


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
        NSLog(@"sql path:%@", modelURL.absoluteString);
        NSManagedObjectModel *managedObjectModel = [[[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL] mutableCopy];
        RKManagedObjectStore *managedObjectStore = [[RKManagedObjectStore alloc] initWithManagedObjectModel:managedObjectModel];
        [managedObjectStore createPersistentStoreCoordinator];

        NSError *error = nil;
//        NSPersistentStore __unused *persistentStore = [managedObjectStore addInMemoryPersistentStore:&error];
//        NSURL *dbPath = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"bookLib.sqlite"];
        NSString *dbPath = [RKApplicationDataDirectory() stringByAppendingPathComponent:@"bookLib.sqlite"];

        [managedObjectStore addSQLitePersistentStoreAtPath:dbPath
                                    fromSeedDatabaseAtPath:nil
                                         withConfiguration:nil
                                                   options:nil
                                                     error:&error];
        NSAssert(!error, @"create persistentStore error %@", [error localizedDescription]);
        [managedObjectStore createManagedObjectContexts];

        _userObjectManager.managedObjectStore = managedObjectStore;

    }

    return self;
}

- (void)saveLoginUserID:(User *)user {
    [[NSUserDefaults standardUserDefaults] setValue:user.user_id forKey:kUserID];
    [[NSUserDefaults standardUserDefaults] synchronize];

    [self clearOtherUsers];
}

- (User *)currentUser{
    NSString *userID = [[NSUserDefaults standardUserDefaults] stringForKey:kUserID];
    if (userID) {
        User *user = [self fetchUserFromBDWithUID:userID];

        return user;
    }

    return nil;
}

- (User *)fetchUserFromBDWithUID:(NSString *)userID{
    User *user = nil;

    NSManagedObjectContext *managedObjectContext = self.userObjectManager.managedObjectStore.persistentStoreManagedObjectContext;
    NSFetchRequest *fetchRequest = [NSFetchRequest new];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"User" inManagedObjectContext:managedObjectContext];
    [fetchRequest setEntity:entity];

    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"user_id == %@", userID];
    fetchRequest.predicate = predicate;

    NSError *error = nil;
    NSArray *fetchObjects = [managedObjectContext executeFetchRequest:fetchRequest error:&error];
    if (fetchObjects.count>0) {
        user = fetchObjects[0];
    }

    return user;
}

- (void)clearOtherUsers{
    NSManagedObjectContext *managedObjectContext = self.userObjectManager.managedObjectStore.persistentStoreManagedObjectContext;

    NSFetchRequest *fetchRequest = [NSFetchRequest new];
    NSEntityDescription *description = [NSEntityDescription entityForName:@"User"
                                                   inManagedObjectContext:managedObjectContext];
    fetchRequest.entity = description;

    NSArray *array = [managedObjectContext executeFetchRequest:fetchRequest
                                                         error:nil];

    NSString *userID = [[NSUserDefaults standardUserDefaults] stringForKey:kUserID];
    [array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        User *user = (User *)obj;
        if (![user.user_id isEqualToString:userID]) {
            [managedObjectContext deleteObject:user];
        }
    }];

    NSError *error = nil;
    if (![managedObjectContext save:&error]) {
        NSLog(@"error:%@", [error localizedDescription]);
    }


}


// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory {

    NSLog(@"%@", [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject]);
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

@end