//
//  MyTableViewCell.m
//  TYAttributedLabelDemo
//
//  Created by Sarah Pan on 2016-06-14.
//  Copyright © 2016 tanyang. All rights reserved.
//

#import "SingleReplyCell.h"
#import "SingleReplyCellHeader.h"
#define Getwidth  [UIScreen mainScreen].bounds.size.width
@interface SingleReplyCell ()
@property (nonatomic, weak) TYAttributedLabel *label;
//@property (nonatomic, weak) UIImageView *iconImage;
//@property (nonatomic, weak) UILabel *nameLabel;
@end

@implementation SingleReplyCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self addAtrribuedLabel];
        //[self addIconImage];
        //[self addNameLabel];
        [self addHeadView];
        [self setLayout];
        
    }
    [self printSubviews:self.contentView];
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        [self addAtrribuedLabel];
    }
    return self;
}

- (void)addAtrribuedLabel
{
    TYAttributedLabel *label = [[TYAttributedLabel alloc]init];
    label.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:label];
    _label = label;
}

-(void) addHeadView
{
    _headView=[[SingleReplyCellHeader alloc]init];
    [self.contentView addSubview:_headView];
    _headView.frame=CGRectMake(0,0,Getwidth,40);
}

-(void) addIconImage
{
    UIImageView *iconView = [[UIImageView alloc] init];
    [self.contentView addSubview:iconView];
    iconView.image = [UIImage imageNamed:@"ring_icon.png"];
    iconView.frame = CGRectMake(0, 0, 40, 40);
    _iconImage = iconView;
}

-(void) addNameLabel
{
    UILabel *nameLabel = [[UILabel alloc] init];
    [self.contentView addSubview:nameLabel];
    nameLabel.text = @"test";
    nameLabel.frame = CGRectMake(40, 0, 200,40);
    _nameLabel = nameLabel;
    
}


-(void)setLayout
{
    NSArray *verticalContrainsts = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-45-[label]-15-|" options:0 metrics:nil views:@{@"label":_label}];
    NSArray *horizontalCOntraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[label]-10-|" options:0 metrics:nil views:@{@"label":_label}];
    
    if ([[UIDevice currentDevice].systemVersion doubleValue] >= 8.0) {
        [NSLayoutConstraint activateConstraints:verticalContrainsts];
        [NSLayoutConstraint activateConstraints:horizontalCOntraints];
    } else {
        [self.contentView addConstraints:verticalContrainsts];
        [self.contentView addConstraints:horizontalCOntraints];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void)setSingleReplyEntity:(SingleReplyEntity *)singleReplyEntity{
    if(_headView){
        _headView.singleReplyEntity = singleReplyEntity;
    }
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

@end

