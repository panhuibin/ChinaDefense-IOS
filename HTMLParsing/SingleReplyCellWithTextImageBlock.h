//
//  MyCell.h
//  测试Cell的Frame
//
//  Created by 荣耀iMac on 16/5/23.
//  Copyright © 2016年 GloriousSoftware. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SingleReplyEntity.h"

@class SingleReplyFrame;

@interface SingleReplyCellWithTextImageBlock : UITableViewCell

@property (nonatomic,strong)SingleReplyEntity *singleReplyEntity;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
+ (CGFloat)totalHeightWithItem:(SingleReplyEntity *)singleReplyEntity;

@end
