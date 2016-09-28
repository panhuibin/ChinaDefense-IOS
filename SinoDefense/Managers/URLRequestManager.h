//
//  URLRequestManager.h
//  SinoDefense
//
//  Created by Sarah Pan on 2016-06-24.
//  Copyright © 2016 Swipe Stack Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface URLRequestManager : NSObject
+(id) sharedInstance;

-(NSMutableURLRequest*)getLoginRequest: (NSString*) username withPassword: (NSString*)password;
-(NSMutableURLRequest*)getNewTopicRequest: (NSString*) title withContent: (NSString*)content withAttachment: (NSString*) attachment;
-(NSMutableURLRequest*)getReplyRequest:(NSString*)replyId withTitle: (NSString*) title withContent: (NSString*)content withAttachment: (NSString*) attachment;
@end
