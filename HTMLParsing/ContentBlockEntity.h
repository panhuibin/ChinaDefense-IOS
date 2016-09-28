//
//  ContentBlockEntity.h
//  SinoDefense
//
//  Created by Sarah Pan on 2016-06-02.
//  Copyright © 2016 Swipe Stack Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ContentBlockEntity : NSObject
-(id)init:(NSString *) content withType:(int) type;

@property (nonatomic, copy) NSString *content;
/** 类型含义：0:文字    1:图片 */
@property (nonatomic, assign) int type;
@end
