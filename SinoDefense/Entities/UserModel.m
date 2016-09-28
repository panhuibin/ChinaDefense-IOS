//
//  UserModel.m
//  SinoDefense
//
//  Created by Sarah Pan on 2016-05-19.
//  Copyright © 2016 Swipe Stack Ltd. All rights reserved.
//

#import "UserModel.h"

@implementation UserModel

- (instancetype)init {
    return self;
}

- (id)getCurrentUserData:(BaseResultBlock)block {
    return self;
}

- (id)getUserById:(NSNumber *)userId callback:(BaseResultBlock)block {
    return self;
}

- (id)loginWithUserName:(NSString *)username loginToken:(NSString *)loginToken block:(BaseResultBlock)block {
    return self;
}

- (void)completeLoginAction:(NSDictionary *)data {

}

- (id)updateUserProfile:(User *)user withBlock:(BaseResultBlock)block {
    return self;
}


@end
