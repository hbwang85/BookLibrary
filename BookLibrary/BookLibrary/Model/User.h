//
//  User.h
//  BookLibrary
//
//  Created by Haibin Wang on 4/6/15.
//  Copyright (c) 2015 Haibin Wang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface User : NSManagedObject

@property (nonatomic, retain) NSString * access_token;
@property (nonatomic, retain) NSString * avatar_url;
@property (nonatomic, retain) NSString * friend_count;
@property (nonatomic, retain) NSString * group_name;
@property (nonatomic, retain) NSString * location;
@property (nonatomic, retain) NSString * phone_number;
@property (nonatomic, retain) NSString * user_email;
@property (nonatomic, retain) NSString * user_id;
@property (nonatomic, retain) NSString * user_name;
@property (nonatomic, retain) NSString * book_count;

@end
