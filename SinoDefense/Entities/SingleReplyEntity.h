//
//  Contributor.h
//  HTMLParsing
//
//  Created by Matt Galloway on 20/05/2012.
//  Copyright (c) 2012 Swipe Stack Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SingleReplyEntity : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *author;
//@property (nonatomic, copy) NSAttributedString *content;
@property (nonatomic, copy) NSArray *imageKeys;
@property (nonatomic, copy) NSArray *imageTextBlocks;
@property (nonatomic, copy) NSString *replyId;
@end
