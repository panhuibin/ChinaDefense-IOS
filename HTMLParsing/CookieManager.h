//
//  CookieStore.h
//  SinoDefense
//
//  Created by Sarah Pan on 2016-05-25.
//  Copyright © 2016 Swipe Stack Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CookieManager : NSObject

@property(nonatomic,weak) NSString *sessionCookie;
@property(nonatomic,weak) NSString *userCookie;

+(id) sharedInstance;
-(NSString *) getSessionCookie;
-(NSString *) getUserCookie;
-(void) saveCookies;
- (void) clearCookies;
-(BOOL) archiveCookies;
@end
