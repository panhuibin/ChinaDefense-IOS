//
//  UserManager.h
//  SinoDefense
//
//  Created by Sarah Pan on 2016-05-19.
//  Copyright © 2016 Swipe Stack Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h";

@interface UserManager : NSObject

@property (nonatomic, copy) NSNumber *userId;
@property (nonatomic, weak) User *userInfo;
+ (id)sharedInstance;
- (BOOL)isLogin;
- (BOOL)hasClientToken;
- (void)updateCurrentUserInfoIfNeeded;
- (void)saveUser:(User *)user;
- (void)checkNoticeCount;
- (void)logOut;
- (NSString *)userLabel;

@end
