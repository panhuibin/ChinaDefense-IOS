//
//  UserModel.h
//  SinoDefense
//
//  Created by Sarah Pan on 2016-05-19.
//  Copyright © 2016 Swipe Stack Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"

typedef void (^ BaseResultBlock)(id data, NSError *error);

@interface UserModel : NSObject


- (id)getCurrentUserData:(BaseResultBlock)block;
- (id)getUserById:(NSNumber *)userId callback:(BaseResultBlock)block;
- (id)loginWithUserName:(NSString *)username loginToken:(NSString *)loginToken block:(BaseResultBlock)block;
- (id)updateUserProfile:(User *)user withBlock:(BaseResultBlock)block;
@end

