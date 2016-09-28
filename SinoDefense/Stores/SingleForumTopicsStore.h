//
//  SingleForumTopicsStore.h
//  SinoDefense
//
//  Created by Sarah Pan on 2016-05-02.
//  Copyright © 2016 Swipe Stack Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SingleForumEntity.h"

@interface SingleForumTopicsStore : NSObject

@property(nonatomic,copy) NSMutableArray *singleForumTopics;
@property(nonatomic,strong) SingleForumEntity *singleForumEntity;
@property(nonatomic,copy) NSMutableArray *currentPageTopics;
-(NSMutableArray *)getSingleForumTopics:(NSString *)forumURL;
-(NSMutableArray*) appendSingleForumTopics;
+(id) sharedInstance;

@end
