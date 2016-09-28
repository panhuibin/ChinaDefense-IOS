//
//  HTMLParsingManager.h
//  HTMLParsing
//
//  Created by Sarah Pan on 2016-04-29.
//  Copyright © 2016 Swipe Stack Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HTMLParsingManager : NSObject

+(id) sharedInstance;
-(NSArray *) parseTopicPage:(NSString *)topicURL forPage:(int)pageIndex;
-(NSArray *) parseForumPage:(NSString *)forumURL forPage:(int)pageIndex;
-(NSArray *) parseFrontPageCategories;
@end
    