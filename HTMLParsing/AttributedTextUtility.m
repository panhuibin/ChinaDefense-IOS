//
//  AttributedTextUtility.m
//  SinoDefense
//
//  Created by Sarah Pan on 2016-05-30.
//  Copyright © 2016 Swipe Stack Ltd. All rights reserved.
//

#import "AttributedTextUtility.h"
#import "TFHppleElement.h"
#import "ImageManager.h"
#import "ImageStore.h"
#import "ContentBlockEntity.h"

@implementation AttributedTextUtility

+(id)sharedInstance
{
    static AttributedTextUtility *sharedInstance = nil;
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

-(NSMutableAttributedString *) convertImageIntoAttributedString: (UIImage *) image withInView: (UIView *)view
{
    
    NSTextAttachment *attachment = [[NSTextAttachment alloc] init];
    
    //scales image down to ration of width of view - you probably don't need this
    CGSize scaleToView = image.size;
    scaleToView.width = view.bounds.size.width;
    scaleToView.height = (view.bounds.size.width/image.size.width)*image.size.height;
    
    attachment.image = image;
    attachment.bounds = CGRectMake(0,-1,scaleToView.width,scaleToView.height);
    
    NSMutableAttributedString *imageAttrString = [[NSAttributedString attributedStringWithAttachment:attachment] mutableCopy];
    return imageAttrString;

}

-(NSAttributedString *)insertImages:(NSArray *) imageFileNames intoAttrString: (NSAttributedString *) attr withInView:(UIView *)view
{
    NSMutableAttributedString *mutableAttr = [[NSMutableAttributedString alloc] initWithAttributedString:attr];
    if ([imageFileNames count]) {
        for(NSString *imageFileName in imageFileNames){
            UIImage *image = [[ImageStore sharedInstance] imageForKey:imageFileName];
            NSAttributedString *imageAttrString = [self convertImageIntoAttributedString:image withInView:view];
            NSRange r = [mutableAttr.string rangeOfString:imageFileName];
            [mutableAttr replaceCharactersInRange:r withAttributedString:imageAttrString];
        }
    }
    NSLog(@"%@",mutableAttr.string);
    NSLog(@"%@",mutableAttr);
    return mutableAttr;
    
}

-(NSAttributedString *)convertHtmlElementIntoAttrStringWithImagePlaceholder:(TFHppleElement *)node{
    NSLog(@"%@", node.raw);
    NSMutableString *htmlString = [[NSMutableString alloc] initWithString:node.raw];
    NSArray *imageElements = [node searchWithXPathQuery:@"//img"];

    for(TFHppleElement *image in imageElements){
        NSLog(@"%@", image.raw);
        NSString *imageHtml = image.raw;
        NSString *imageSrc = [image objectForKey:@"src"];
        NSString *imageName = [[ImageManager sharedInstance] getImageNameFromURL:imageSrc];
        NSString *imageTag = [NSString stringWithFormat:@"<img>%@</img>",imageName];
        NSRange wholeHtml = NSMakeRange(0, [htmlString length]);
        [htmlString replaceOccurrencesOfString:imageHtml withString:imageTag options:0 range:wholeHtml];
    }
    
    
    return [[NSAttributedString alloc] initWithData:[htmlString dataUsingEncoding:NSUTF8StringEncoding]
                                                          options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,
                                                                    NSCharacterEncodingDocumentAttribute: @(NSUTF8StringEncoding)}
                                               documentAttributes:nil error:nil];
}



-(NSAttributedString *) htmlIntoAttr:(TFHppleElement *)node withImageFileNames:(NSArray *) imageFileNames{
    NSAttributedString *attr = [self convertHtmlElementIntoAttrStringWithImagePlaceholder:node];
    NSLog(@"%@", attr.string);
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    UIView *topView = window.rootViewController.view;
    return [self insertImages:imageFileNames intoAttrString:attr withInView:topView];
}


-(NSArray *) htmlIntoImageTextBlocks:(TFHppleElement *)node {
    NSMutableArray *blocks = [[NSMutableArray alloc] init];
    NSMutableString *htmlString = [[NSMutableString alloc] initWithString:node.raw];
    NSArray *imageElements = [node searchWithXPathQuery:@"//img"];
    
    for(TFHppleElement *image in imageElements){
        NSString *imgSource = [image objectForKey:@"src"];
        UIImage *srcUIImage;
        if(![[ImageStore sharedInstance] imageForKey:imgSource]){
            srcUIImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imgSource]]];
        }else{
            srcUIImage = [[ImageStore sharedInstance] imageForKey:imgSource];
        }
        //what should i do with the emotions? currently just ignore them...
        if(srcUIImage){
            [[ImageStore sharedInstance] setImage:srcUIImage forKey:imgSource];
            NSRange imageRange = [htmlString rangeOfString:image.raw];
            NSRange truncateRange = NSMakeRange(0, imageRange.length+imageRange.location);
            NSString *paragrahHtml = [htmlString substringToIndex:imageRange.location];
            [htmlString deleteCharactersInRange:truncateRange];
            NSString *paragrahText = [self htmlToText:paragrahHtml];
            ContentBlockEntity *textEntity = [[ContentBlockEntity alloc] init:paragrahText withType:0];
            [blocks addObject:textEntity];
            ContentBlockEntity *imageEntity = [[ContentBlockEntity alloc] init:imgSource withType:1];
            [blocks addObject:imageEntity];
        }

    }
    NSString *paragrahText = [self htmlToText:htmlString];
    ContentBlockEntity *textEntity = [[ContentBlockEntity alloc] init:paragrahText withType:0];
    [blocks addObject:textEntity];
    return blocks;
}

-(NSString *)htmlToText:(NSString *)htmlString
{
    NSAttributedString *attr= [[NSAttributedString alloc] initWithData:[htmlString dataUsingEncoding:NSUTF8StringEncoding]
                                            options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,
                                                      NSCharacterEncodingDocumentAttribute: @(NSUTF8StringEncoding)}
                                 documentAttributes:nil error:nil];
    return attr.string;
}

-(NSArray *) htmlIntoImageTextBlocksWithURL:(TFHppleElement *)node {
    NSMutableArray *blocks = [[NSMutableArray alloc] init];
    NSMutableString *htmlString = [[NSMutableString alloc] initWithString:node.raw];
    NSArray *imageElements = [node searchWithXPathQuery:@"//img"];
    
    for(TFHppleElement *image in imageElements){
        NSString *imgSource = [image objectForKey:@"src"];
        NSRange imageRange = [htmlString rangeOfString:image.raw];
        NSRange truncateRange = NSMakeRange(0, imageRange.length+imageRange.location);
        NSString *paragrahHtml = [htmlString substringToIndex:imageRange.location];
        [htmlString deleteCharactersInRange:truncateRange];
        NSString *paragrahText = [self htmlToText:paragrahHtml];
        ContentBlockEntity *textEntity = [[ContentBlockEntity alloc] init:paragrahText withType:0];
        [blocks addObject:textEntity];
        ContentBlockEntity *imageEntity = [[ContentBlockEntity alloc] init:imgSource withType:1];
            [blocks addObject:imageEntity];
        
    }
    NSString *paragrahText = [self htmlToText:htmlString];
    ContentBlockEntity *textEntity = [[ContentBlockEntity alloc] init:paragrahText withType:0];
    [blocks addObject:textEntity];
    return blocks;
}




@end
