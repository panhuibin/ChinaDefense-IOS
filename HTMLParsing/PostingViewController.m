//
//  PostingViewController.m
//  SinoDefense
//
//  Created by Sarah Pan on 2016-06-24.
//  Copyright © 2016 Swipe Stack Ltd. All rights reserved.
//

#import "PostingViewController.h"
#import "URLRequestManager.h"

@interface PostingViewController ()

@end

@implementation PostingViewController

@synthesize forumTitle = _forumTitle;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavigator];
    [self.tableView setSeparatorColor:[UIColor blackColor]];
    self.forumTitleLabel.text = _forumTitle;
    self.postContentTextView.text = @"enter your post content here";
    self.postTopicField.text = @"enter your post topic here";
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - navigator

- (void)setNavigator {
    UINavigationItem *navItem = self.navigationItem;
    navItem.title = _forumTitle;
    //[[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60)
    //                                                     forBarMetrics:UIBarMetricsDefault];
    navItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationController.navigationBar.topItem.title = @"";
    [self createRightButtonItem];
}

- (void)createRightButtonItem {
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"tick_icon"]
                                                                           style:UIBarButtonItemStylePlain
                                                                          target:self
                                                                          action:@selector(sendNewPost)];
    rightBarButtonItem.tintColor = [UIColor colorWithRed:0.502 green:0.776 blue:0.200 alpha:1.000];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
}

#pragma mark -


-(void)setForumTitle:(NSString *)forumTitle
{
    _forumTitle = forumTitle;
}

#pragma mark - buttons

-(void)sendNewPost
{
    NSString *title = self.postTopicField.text;
    NSString *content = self.postContentTextView.text;
    NSMutableURLRequest *request = [[URLRequestManager sharedInstance] getNewTopicRequest:title withContent:content withAttachment:nil];
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    [connection start];
}

#pragma mark - NSURLConnection delegate

-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    
    NSLog(@"%@" , error);
}



@end
