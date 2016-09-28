//
//  ImageManager.m
//  SinoDefense
//
//  Created by Sarah Pan on 2016-05-30.
//  Copyright © 2016 Swipe Stack Ltd. All rights reserved.
//

#import "ImageManager.h"

@implementation ImageManager

+(id)sharedInstance
{
    static ImageManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

-(id)init {
    if (self = [super init]) {
    }
    return self;
}

-(UIImage *) getImageFromURL:(NSString *)fileURL {
    UIImage * result;
    
    NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:fileURL]];
    result = [UIImage imageWithData:data];
    
    return result;
}

-(void) saveImage:(UIImage *)image withFileName:(NSString *)imageName ofType:(NSString *)extension inDirectory:(NSString *)directoryPath {
    if ([[extension lowercaseString] isEqualToString:@"png"]) {
        [UIImagePNGRepresentation(image) writeToFile:[directoryPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.%@", imageName, @"png"]] options:NSAtomicWrite error:nil];
    } else if ([[extension lowercaseString] isEqualToString:@"jpg"] || [[extension lowercaseString] isEqualToString:@"jpeg"]) {
        [UIImageJPEGRepresentation(image, 1.0) writeToFile:[directoryPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.%@", imageName, @"jpg"]] options:NSAtomicWrite error:nil];
    } else {
        NSLog(@"Image Save Failed\nExtension: (%@) is not recognized, use (PNG/JPG)", extension);
    }
}

-(UIImage *) loadImage:(NSString *)fileName ofType:(NSString *)extension inDirectory:(NSString *)directoryPath {
    UIImage * result = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/%@.%@", directoryPath, fileName, extension]];
    
    return result;
}

-(void)downloadImageToDevice:(NSString*)imageURL{
    NSString * documentsDirectoryPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    UIImage * imageFromURL = [self getImageFromURL:imageURL];
    NSString *filename = [self getImageNameFromURL:imageURL];
    NSString *imageType = [[filename componentsSeparatedByString:@"."] lastObject];
    [self saveImage:imageFromURL withFileName:filename ofType:imageType inDirectory:documentsDirectoryPath];
}

-(UIImage *)getImageFromDevice: (NSString *)imageURL{
    NSString * documentsDirectoryPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSArray *parts = [imageURL componentsSeparatedByString:@"/"];
    NSString *filename = [parts lastObject];
    NSString *imageType = [[filename componentsSeparatedByString:@"."] lastObject];
    return [self loadImage:filename ofType:imageType inDirectory:documentsDirectoryPath];
}

-(NSString *)getImageNameFromURL:(NSString*)imageURL{
    NSArray *parts = [imageURL componentsSeparatedByString:@"/"];
    NSString *filename = [parts lastObject];
    return filename;
}

@end
