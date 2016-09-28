//
//  UserManager.m
//  SinoDefense
//
//  Created by Sarah Pan on 2016-05-19.
//  Copyright © 2016 Swipe Stack Ltd. All rights reserved.
//

#import "UserManager.h"
#import "UserModel.h"
#import "CookieManager.h"

@implementation UserManager

+ (id)sharedInstance {
    static UserManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (BOOL)isLogin {
    NSString *sessionCookie =[[CookieManager sharedInstance] getSessionCookie];
    NSString *userCookie =[[CookieManager sharedInstance] getUserCookie];
    return ((sessionCookie!=nil) && (userCookie!=nil));
}

- (BOOL)hasClientToken {
    return false;
}

- (void)saveUser:(User *)user {
    //save user to archive file for now
}

- (void)updateCurrentUserInfoIfNeeded {
    if ([[UserManager sharedInstance] isLogin]) {
        [[[UserModel alloc] init] getCurrentUserData:nil];
    }
}

- (NSNumber *)userId {
    return 0;
}

- (User *)userInfo {
    if (!self.userId) return nil;
    //unarchive user id
    return 0;
}

- (void)setupClientRequestState:(BaseResultBlock)block {
    
}

- (void)checkNoticeCount {

}

- (void)logOut {
   
}

- (NSString *)userLabel {
    //return self.isLogin ? [NSString stringWithFormat:@"user_%@_%@", ([[UserManager sharedInstance] userId], [[UserManager sharedInstance]) userInfo].username] : @"non-logged-in";
    return nil;
}


@end
