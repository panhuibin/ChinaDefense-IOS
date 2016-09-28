//
//  MyTableViewCell.h
//  TYAttributedLabelDemo
//
//  Created by Sarah Pan on 2016-06-14.
//  Copyright © 2016 tanyang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "TYAttributedLabel.h"
#import "SingleReplyEntity.h"
#import "SingleReplyCellHeader.h"

@interface SingleReplyCell : UITableViewCell
@property (nonatomic, weak, readonly) TYAttributedLabel *label;
@property (nonatomic, weak) UIImageView *iconImage;
@property (nonatomic, weak) UILabel *nameLabel;
@property (nonatomic,strong) SingleReplyEntity *singleReplyEntity;
@property (nonatomic,strong) SingleReplyCellHeader *headView;
@end
