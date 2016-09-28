//
//  ReplyViewController.h
//  SinoDefense
//
//  Created by Sarah Pan on 2016-06-26.
//  Copyright © 2016 Swipe Stack Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface PostViewController : UITableViewController



@property (weak, nonatomic) IBOutlet UITextField *postTopicField;
@property (weak, nonatomic) IBOutlet UITextView *postContentTextView;
@property (nonatomic,strong) NSString* forumId;
@property (nonatomic,strong) NSString* forumTitle;
@property (nonatomic,strong) NSString* replyId;
@property (nonatomic,strong) NSString* postTitle;
@property (nonatomic,strong) UIImage* image;
@property (nonatomic) BOOL isNewPost;
@property (weak, nonatomic) IBOutlet UIButton *addPicturesButton;

@property (weak, nonatomic) IBOutlet UIButton *addPhotosButton;

@property (weak, nonatomic) IBOutlet UIButton *addEmojisButton;
@property (weak, nonatomic) IBOutlet UIButton *previewButton;


@end
