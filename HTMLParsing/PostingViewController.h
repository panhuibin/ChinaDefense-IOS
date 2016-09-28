//
//  PostingViewController.h
//  SinoDefense
//
//  Created by Sarah Pan on 2016-06-24.
//  Copyright © 2016 Swipe Stack Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PostingViewController : UITableViewController
@property(nonatomic,strong) NSString* forumTitle;
@property (weak, nonatomic) IBOutlet UILabel *forumTitleLabel;
@property (weak, nonatomic) IBOutlet UITextField *postTopicField;
@property (weak, nonatomic) IBOutlet UITextView *postContentTextView;

@end
