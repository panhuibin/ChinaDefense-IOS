//
//  ImageManager.h
//  SinoDefense
//
//  Created by Sarah Pan on 2016-05-30.
//  Copyright © 2016 Swipe Stack Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ImageManager : NSObject

+(id) sharedInstance;

-(UIImage *) getImageFromURL:(NSString *)fileURL;

-(void) insertImage:(NSAttributedString *)attr;
-(void) saveImage:(UIImage *)image withFileName:(NSString *)imageName ofType:(NSString *)extension inDirectory:(NSString *)directoryPath;   
-(UIImage *) loadImage:(NSString *)fileName ofType:(NSString *)extension inDirectory:(NSString *)directoryPath;

-(void)downloadImageToDevice:(NSString*)imageURL;

-(UIImage *)getImageFromDevice: (NSString *)imageURL;
-(NSString *)getImageNameFromURL:(NSString*)imageURL;


@end
