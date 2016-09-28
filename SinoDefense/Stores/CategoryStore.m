//
//  CategoryStore.m
//  HTMLParsing
//
//  Created by Sarah Pan on 2016-05-02.
//  Copyright © 2016 Swipe Stack Ltd. All rights reserved.
//

#import "CategoryStore.h"
#import "SingleForumEntity.h"
#import "HTMLParsingManager.h"

@implementation CategoryStore

+(id)sharedInstance
{
    static CategoryStore *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

-(instancetype) init
{
    self = [super init];
    if(self){
        _categories =[[HTMLParsingManager sharedInstance] parseFrontPageCategories];
    }
    return self;
}

-(NSArray*) getCategories{
    return _categories;
}


@end
