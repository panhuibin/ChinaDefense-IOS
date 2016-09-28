//
//  SingleTopicReplysStore.h
//  SinoDefense
//
//  Created by Sarah Pan on 2016-06-21.
//  Copyright © 2016 Swipe Stack Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TopicEntity.h"

@interface SingleTopicReplysStore : NSObject
@property(nonatomic,copy) NSMutableArray *singleTopicReplies;
@property(nonatomic,strong) TopicEntity *topicEntity;
@property(nonatomic,copy) NSMutableArray *currentPageReplies;
-(NSMutableArray *)getSingleReplyEntities:(NSString *)topicURL;
+(id) sharedInstance;
@end
