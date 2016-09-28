//
//  TopicItemCell.h
//  SinoDefense
//
//  Created by Sarah Pan on 2016-05-05.
//  Copyright © 2016 Swipe Stack Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TopicItemCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *authorLabel;
@property (weak, nonatomic) IBOutlet UILabel *replyLabel;
@property (weak, nonatomic) IBOutlet UIImageView *thumnail;

@end
