//
//  Paginatino.h
//  SinoDefense
//
//  Created by Sarah Pan on 2016-05-07.
//  Copyright © 2016 Swipe Stack Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Paginatino : NSObject
@property (nonatomic, assign) NSUInteger totalPages;
@property (nonatomic, assign) NSUInteger currentPage;
@property (nonatomic, assign) NSUInteger perPage;
@end
