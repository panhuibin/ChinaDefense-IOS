//
//  DetailViewController.m
//  HTMLParsing
//
//  Created by Matt Galloway on 19/05/2012.
//  Copyright (c) 2012 Swipe Stack Ltd. All rights reserved.
//

#import "SingleForumViewController.h"
#import "SingleForumTopicsStore.h"
#import "TopicEntity.h"
#import "HTMLParsingManager.h"
#import "SingleForumTopicsStore.h"
#import "TopicItemCell.h"
#import "MJRefresh.h"
#import "SingleTopicViewController.h"
#import "PostingViewController.h"

@interface SingleForumViewController (){
    NSMutableArray *_topicList;
    int _refreshCount;
}

@end

@implementation SingleForumViewController

@synthesize singleTopicViewController = _singleTopicViewController;

@synthesize forumUrl = _forumUrl;
@synthesize forumTitle = _forumTitle;


#pragma mark - Managing the detail item

- (void)loadTopics {
    NSLog(@"%@", _forumUrl);
    //_topicList = [[HTMLParsingManager sharedInstance] parseForumPage:_forumUrl];
    _topicList = [[SingleForumTopicsStore sharedInstance] getSingleForumTopics:_forumUrl];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [self.tableView reloadData];
    
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setNavigator];
    UINib *nib = [UINib nibWithNibName:@"TopicItemCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"TopicItemCell"];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(topDragRefreshData)];
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(bottomDragRefreshData)];
    
    [self loadTopics];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self setNavigator];
    [self loadTopics];
}




- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    return self;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    return self;
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
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"pencil_square_icon"]
                                                                           style:UIBarButtonItemStylePlain
                                                                          target:self
                                                                          action:@selector(postTopic)];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
}


#pragma mark - Table View




- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _topicList.count;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    static NSString *CellIdentifier = @"TopicItemCell";
    TopicItemCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if(cell == nil){
        cell = [[TopicItemCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    
    TopicEntity *thisTopic = [_topicList objectAtIndex:indexPath.row];
    NSLog(@"%@",thisTopic.title);
    
    cell.titleLabel.text = thisTopic.title;
    cell.authorLabel.text = thisTopic.author;
    cell.replyLabel.text = thisTopic.replies;
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return NO;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    TopicEntity *thisTopic = [_topicList objectAtIndex:indexPath.row];
    NSString *topicURL = thisTopic.url;
    //self.singleTopicViewController.topicUrl = topicURL;
    //[self.navigationController pushViewController:self.singleTopicViewController animated:YES];
    self.mvc = [[SingleTopicViewController alloc] init];
    self.mvc.topicUrl = topicURL;
    self.mvc.topicTitle = thisTopic.title;
    [self.navigationController pushViewController:self.mvc animated:YES];
    
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger lastSectionIndex = [tableView numberOfSections] - 1;
    NSInteger lastRowIndex = [tableView numberOfRowsInSection:lastSectionIndex] - 1;
    if ((indexPath.section == lastSectionIndex) && (indexPath.row == lastRowIndex)) {
        // This is the last cell
        [self loadMore];
    }
}


#pragma mark - handleRefresh
-(void)loadMore{
    _topicList = [[SingleForumTopicsStore sharedInstance] appendSingleForumTopics];
    [self.tableView reloadData];
}

-(void) handleRefresh:(id)sender{
    _topicList = [[SingleForumTopicsStore sharedInstance] getSingleForumTopics:_forumUrl];
}

- (void)bottomDragRefreshData
{
    _topicList = [[SingleForumTopicsStore sharedInstance] getSingleForumTopics:_forumUrl];
    [self.tableView reloadData];
    [self.tableView.mj_header endRefreshing];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
}

- (void)topDragRefreshData
{
    NSArray *array =[[HTMLParsingManager sharedInstance] parseForumPage:_forumUrl forPage:++_refreshCount];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [_topicList addObjectsFromArray:array];
    [self.tableView reloadData];
    [self.tableView.mj_footer endRefreshing];
}


#pragma mark - postButton

-(void) postTopic{
    UIStoryboard *storyboard =[UIStoryboard storyboardWithName:@"PostingView" bundle:[NSBundle mainBundle]];
    PostingViewController *pvc =  (PostingViewController*)[storyboard instantiateViewControllerWithIdentifier:@"PostingView"];
    pvc.forumTitle = _forumTitle;
    [[self navigationController] pushViewController:pvc animated:YES];
}

@end
