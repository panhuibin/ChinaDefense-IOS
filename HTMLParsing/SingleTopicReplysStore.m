//
//  SingleTopicReplysStore.m
//  SinoDefense
//
//  Created by Sarah Pan on 2016-06-21.
//  Copyright © 2016 Swipe Stack Ltd. All rights reserved.
//

#import "SingleTopicReplysStore.h"
#import "SingleReplyEntity.h"
#import "HTMLParsingManager.h"

@implementation SingleTopicReplysStore
+(id)sharedInstance
{
    static SingleTopicReplysStore *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

-(NSMutableArray*) getSingleReplyEntities:(NSString *)url{
    
    _topicEntity.url=url;
    _singleTopicReplies = [[HTMLParsingManager sharedInstance] parseTopicPage:url forPage:1];
    _topicEntity.currentPage=1;
    return _singleTopicReplies;
    
}



@end
