//
//  CookieStore.m
//  SinoDefense
//
//  Created by Sarah Pan on 2016-05-25.
//  Copyright © 2016 Swipe Stack Ltd. All rights reserved.
//

#import "CookieManager.h"

@implementation CookieManager

+(id)sharedInstance
{
    static CookieManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

-(void) saveCookies
{
    for (NSHTTPCookie *cookie in [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies])
    {
        if([[cookie domain] isEqualToString: @"www.sinodefenceforum.com"]){
            if([[cookie name] isEqualToString:@"xf_session"]){
                _sessionCookie = [cookie value];
                NSLog(@"%@,%@",[cookie value],[cookie expiresDate]);
            }else if([[cookie name] isEqualToString:@"xf_user"]){
                _userCookie = [cookie value];
                 NSLog(@"%@,%@",[cookie value],[cookie expiresDate]);
            }
        }
    }
}


- (void) clearCookies {
    NSArray *cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies];
    [cookies enumerateObjectsUsingBlock:^(NSHTTPCookie *cookie, NSUInteger idx, BOOL *stop) {
        if ([cookie.domain containsString:@"www.sinodefenceforum.com"]) {
            [[NSHTTPCookieStorage sharedHTTPCookieStorage] deleteCookie:cookie];
        }
    }];
}

-(NSString*) getCookieAsString
{
    return [NSString stringWithFormat:@"%@%@", _sessionCookie,_userCookie ];
}

#pragma mark - archive
-(NSString *)cookieArchivePath
{
    NSArray *documentDirectories = NSSearchPathForDirectoriesInDomains((NSDocumentDirectory), NSUserDomainMask, YES);
    NSString *documentDirectory = [documentDirectories firstObject];
    return [documentDirectory stringByAppendingString:@"cookies.archive"];
}

-(BOOL)archiveCookies
{
    NSString *path = [self cookieArchivePath];
    return [NSKeyedArchiver archiveRootObject:self.sessionCookie toFile:path];
}

@end
