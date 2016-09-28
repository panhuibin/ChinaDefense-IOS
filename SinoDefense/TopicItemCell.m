//
//  TableViewCell.m
//  SinoDefense
//
//  Created by Sarah Pan on 2016-07-09.
//  Copyright © 2016 Sarah Pan. All rights reserved.
//

#import "TopicItemCell.h"
#define Getwidth  [UIScreen mainScreen].bounds.size.width
@implementation TopicItemCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setViews];
        [self setConstraints];
    }
    return self;
}

- (void)setViews{
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,0,Getwidth,20)];
    [self addSubview:_titleLabel];
    _authorLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,21,Getwidth/2,20)];
    [self addSubview:_authorLabel];
    _replyLabel = [[UILabel alloc] initWithFrame:CGRectMake(Getwidth/2,21,Getwidth/2,20)];
    [self addSubview:_replyLabel];
    _replyLabel.textAlignment = NSTextAlignmentRight;
}

- (void)setConstraints{
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
