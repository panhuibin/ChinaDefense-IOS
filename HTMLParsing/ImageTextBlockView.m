//
//  ImageTextBlockView.m
//  SinoDefense
//
//  Created by Sarah Pan on 2016-06-29.
//  Copyright © 2016 Swipe Stack Ltd. All rights reserved.
//

#import "ImageTextBlockView.h"
#import <UIKit/UIKit.h>
#import "ContentBlockEntity.h"

@implementation ImageTextBlockView


-(void)setImageTextBlock:(NSArray *)imageTextBlock
{
    for(ContentBlockEntity *contentBlockEntity in imageTextBlock){
        if(contentBlockEntity.type==0){
            UILabel *label = [[UILabel alloc] init];
            label.text = contentBlockEntity.content;
            label.translatesAutoresizingMaskIntoConstraints = NO;
            NSDictionary *viewDict = @{@"label" : label};
            [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[label]|" options:0 metrics:0 views:viewDict]];
            [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[label]" options:0 metrics:0 views:viewDict]];
        }else if(contentBlockEntity.type==1){
          //
        }
    }

}

@end
