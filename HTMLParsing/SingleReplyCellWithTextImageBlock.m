//
//  MyCell.m
//  测试Cell的Frame
//
//  Created by 荣耀iMac on 16/5/23.
//  Copyright © 2016年 GloriousSoftware. All rights reserved.
//

#import "SingleReplyCellWithTextImageBlock.h"
#import "SingleReplyEntity.h"
#import "SingleReplyEntity.h"
#import "ContentBlockEntity.h"
#import "ImageStore.h"

#define WLNameFont [UIFont systemFontOfSize:15]
#define WLTextFont [UIFont systemFontOfSize:16]

@interface SingleReplyCellWithTextImageBlock()

@property (nonatomic, weak) UIImageView *iconView;
@property (nonatomic, weak) UILabel *nameLabel;


@end

@implementation SingleReplyCellWithTextImageBlock


+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    // NSLog(@"cellForRowAtIndexPath");
    static NSString *identifier = @"status";
    // 1.缓存中取
    SingleReplyCellWithTextImageBlock *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    // 2.创建
    if (cell == nil) {
        cell = [[SingleReplyCellWithTextImageBlock alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    return cell;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {

    }
    return self;
}

-(void)setSingleReplyEntity:(SingleReplyEntity *)singleReplyEntity
{
    _singleReplyEntity = singleReplyEntity;
    [self setUserIcon];
    [self setNameLabel];
    [self setContentView];
    [self printSubviews:self.contentView];
    [self setNeedsDisplay];
    //[self.contentView setNeedsLayout];
    //[self.contentView layoutIfNeeded];
    //[self printSubviews:self.contentView];
}

-(void) setUserIcon
{
    UIImageView *iconView = [[UIImageView alloc] init];
    [self.contentView addSubview:iconView];
    self.iconView = iconView;
    self.iconView.image = [UIImage imageNamed:@"ring_icon.png"];
    self.iconView.frame = CGRectMake(0, 0, 40, 40);
}

-(void) setNameLabel
{
    UILabel *nameLabel = [[UILabel alloc] init];
    nameLabel.font = WLNameFont;
    [self.contentView addSubview:nameLabel];
    self.nameLabel = nameLabel;
    self.nameLabel.text = _singleReplyEntity.author;
    CGSize nameSize = [self sizeWithString:_singleReplyEntity.author font:WLNameFont maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
    self.nameLabel.frame = CGRectMake(40, 0, nameSize.width,nameSize.height);
    
}

-(void) setContentView
{
    int blockY = 40;
    for(ContentBlockEntity *contentBlockEntity in _singleReplyEntity.imageTextBlocks){
        if(contentBlockEntity.type==0){
            UITextView *text = [[UITextView alloc] init];
            text.font = WLTextFont;
            NSString *content = contentBlockEntity.content;
            text.text = content;
            text.scrollEnabled=NO;  
            CGSize frameSize = [self sizeWithString:content font:WLTextFont maxSize:CGSizeMake(300, MAXFLOAT)];
            text.frame = CGRectMake(0, blockY, frameSize.width, frameSize.height);
            blockY += frameSize.height;
            [self.contentView addSubview:text];
        }else if(contentBlockEntity.type==1){
            UIImageView *pictureView = [[UIImageView alloc] init];
            UIImage *image = [[ImageStore sharedInstance] imageForKey:contentBlockEntity.content];
            pictureView.image = image;
            pictureView.frame = CGRectMake(0, blockY, 100, 100);
            [self.contentView addSubview:pictureView];
            blockY += 100;
        }
    }

}

+ (CGFloat)totalHeightWithItem:(SingleReplyEntity *)singleReplyEntity
{
    int blockY = 40;
    for(ContentBlockEntity *contentBlockEntity in singleReplyEntity.imageTextBlocks){
        if(contentBlockEntity.type==0){
            NSString *content = contentBlockEntity.content;
            CGSize frameSize = [self sizeWithString:content font:WLTextFont maxSize:CGSizeMake(300, MAXFLOAT)];
            blockY += frameSize.height;
        }else if(contentBlockEntity.type==1){
            blockY += 100;
        }
    }
    return blockY;

}


-(void) printSubviews:(UIView *)view
{
    if(view.subviews){
        for(UIView *subview in view.subviews){
            NSLog(@"%@",subview);
            if([subview isKindOfClass:[UILabel class]]){
               NSLog(@"%@",((UILabel *)subview).text);
            }else if([subview isKindOfClass:[UIImageView class]]){
               // NSLog(@"%@",((UIImageView *)subview).image);
            }
            if(subview.subviews){
                [self printSubviews:subview];
            }
        }
    }
}

-(CGSize)sizeWithString:(NSString *)str font:(UIFont *)font maxSize:(CGSize)maxSize
{
    NSDictionary *dict = @{NSFontAttributeName :font};
    CGSize size = [str boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil].size;
    return size;
}

+(CGSize)sizeWithString:(NSString *)str font:(UIFont *)font maxSize:(CGSize)maxSize
{
    NSDictionary *dict = @{NSFontAttributeName :font};
    CGSize size = [str boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil].size;
    return size;
}

@end
