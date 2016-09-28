//
//  SingleTutorial.h
//  HTMLParsing
//
//  Created by Sarah Pan on 2016-04-28.
//  Copyright © 2016 Swipe Stack Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TopicEntity : NSObject
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *url;
@property (nonatomic, copy) NSString *author;
@property (nonatomic, copy) NSString *replies;
@property (nonatomic) BOOL isSticky;
@property (nonatomic) int currentPage;

@end
