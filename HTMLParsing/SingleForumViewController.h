//
//  DetailViewController.h
//  HTMLParsing
//
//  Created by Matt Galloway on 19/05/2012.
//  Copyright (c) 2012 Swipe Stack Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SingleTopicViewController;
@class SingleTopicViewController;

@interface SingleForumViewController : UITableViewController


@property (strong, nonatomic) SingleTopicViewController *singleTopicViewController;
@property (strong, nonatomic) SingleTopicViewController *mvc;

@property (strong, nonatomic) NSString* forumUrl;
@property (strong, nonatomic) NSString* forumTitle;

@end
