//
//  ContentBlockEntity.m
//  SinoDefense
//
//  Created by Sarah Pan on 2016-06-02.
//  Copyright © 2016 Swipe Stack Ltd. All rights reserved.
//

#import "ContentBlockEntity.h"

@implementation ContentBlockEntity

-(id)init:(NSString *) content withType:(int) type{
    _content = content;
    _type = type;
    return self;
}

@end
