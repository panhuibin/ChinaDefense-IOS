//
//  ImageStore.h
//  SinoDefense
//
//  Created by Sarah Pan on 2016-05-30.
//  Copyright © 2016 Swipe Stack Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ImageStore : NSObject



+(instancetype) sharedInstance;
-(NSString *)setImage:(UIImage *)image;
-(void)setImage:(UIImage*)image forKey:(NSString *)key;
-(UIImage *) imageForKey:(NSString *)key;
-(NSString *)keyForImage:(UIImage *)image;

@end
