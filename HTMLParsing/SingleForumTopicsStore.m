//
//  SingleForumTopicsStore.m
//  SinoDefense
//
//  Created by Sarah Pan on 2016-05-02.
//  Copyright © 2016 Swipe Stack Ltd. All rights reserved.
//

#import "SingleForumTopicsStore.h"
#import "TopicEntity.h"
#import "HTMLParsingManager.h"
#import "SingleForumEntity.h"

@implementation SingleForumTopicsStore


+(id)sharedInstance
{
    static SingleForumTopicsStore *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

-(id)init {
    if (self = [super init]) {
        _singleForumEntity = [[SingleForumEntity alloc]init];
    }
    return self;
}


-(NSMutableArray*) getSingleForumTopics:(NSString *)url{
    
    _singleForumEntity.url=url;
    _singleForumTopics = [[HTMLParsingManager sharedInstance] parseForumPage:url forPage:1];
    _singleForumEntity.currentPage=1;
    return _singleForumTopics;
    
}

-(NSMutableArray*) appendSingleForumTopics{
    int nextPage =  _singleForumEntity.currentPage+1;
    _currentPageTopics =[[HTMLParsingManager sharedInstance] parseForumPage:_singleForumEntity.url forPage:nextPage];
    [_singleForumTopics addObjectsFromArray: _currentPageTopics];
    _singleForumEntity.currentPage=nextPage;
    return _singleForumTopics;
}





    
@end
