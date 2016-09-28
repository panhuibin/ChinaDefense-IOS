//
//  CategoryStore.h
//  HTMLParsing
//
//  Created by Sarah Pan on 2016-05-02.
//  Copyright © 2016 Swipe Stack Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CategoryStore : NSObject

@property(nonatomic,copy) NSArray *categories;

-(NSArray *)getCategories;

+(id) sharedInstance;

@end
