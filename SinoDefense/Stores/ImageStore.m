//
//  ImageStore.m
//  SinoDefense
//
//  Created by Sarah Pan on 2016-05-30.
//  Copyright © 2016 Swipe Stack Ltd. All rights reserved.
//

#import "ImageStore.h"

@interface ImageStore()
@property(nonatomic,strong) NSMutableDictionary *dictionary;
@end

@implementation ImageStore

+(id)sharedInstance
{
    static ImageStore *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

-(id)init
{
    self=[super init];
    if(self){
        _dictionary = [[NSMutableDictionary alloc] init];
    }
    return self;
}

-(NSString *)setImage:(UIImage *)image
{
    NSUUID *uuid = [[NSUUID alloc] init];
    NSString *key = [uuid UUIDString];
    [self.dictionary setObject:image forKey:key];
    return key;
}

-(void)setImage:(UIImage *)image forKey:(NSString *)key
{
    [self.dictionary setObject:image forKey:key];
}

-(UIImage *)imageForKey:(NSString *)key
{
    return [self.dictionary objectForKey:key];
}

-(NSString *)keyForImage:(UIImage *)image
{
    return [[self.dictionary allKeysForObject:image] firstObject];
}

@end
