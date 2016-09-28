//
//  MyTableViewController.m
//  TYAttributedLabelDemo
//
//  Created by Sarah Pan on 2016-06-14.
//  Copyright © 2016 tanyang. All rights reserved.
//


#import "SingleTopicViewController.h"
#import "TYAttributedLabel.h"
#import "SingleReplyCell.h"
#import "SingleReplyEntity.h"
#import "HTMLParsingManager.h"
#import <QuartzCore/QuartzCore.h>
#import <MediaPlayer/MediaPlayer.h>
#import "AttributedTextUtility.h"
#import "ContentBlockEntity.h"
#import "ImageStore.h"
#import "MJRefresh.h"
#import "SingleTopicReplysStore.h"

@interface SingleTopicViewController ()<TYAttributedLabelDelegate>
@property (nonatomic, strong) NSArray *textContainers;
@end



static NSString *cellId = @"AutoLayoutAttributedLabelCell";
#define RGB(r,g,b,a)	[UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]

@implementation SingleTopicViewController{
    NSMutableArray *_replyList;
    int _refreshCount;
    
}

@synthesize topicUrl = _topicUrl;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerClass:[SingleReplyCell class] forCellReuseIdentifier:cellId];
    [self setNavigator];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(topDragRefreshData)];
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(bottomDragRefreshData)];
    UILabel *header = [[UILabel alloc] init];
    header.text = _topicTitle;
    [self.tableView.tableHeaderView addSubview:header];
    
    [self loadReplies];
    
    if ([self.tableView respondsToSelector:@selector(setEstimatedRowHeight:)]) {
        self.tableView.estimatedRowHeight = 40;
    }
}

- (void)loadReplies {
    _replyList = [[HTMLParsingManager sharedInstance] parseTopicPage:_topicUrl forPage:1];
    NSMutableArray *tmp = [NSMutableArray array];
    for(SingleReplyEntity *singleReplyEntity in _replyList){
        TYTextContainer * textContainer = [self creatTextContainer:singleReplyEntity];
        [tmp addObject:textContainer];
    }
    _textContainers = [tmp copy];
    [self.tableView reloadData];
    
}

#pragma mark - navigator

- (void)setNavigator {
    UINavigationItem *navItem = self.navigationItem;
    navItem.title = _topicTitle;
    navItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    //[self createRightButtonItem];
}

- (void)createRightButtonItem {
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"pencil_square_icon"]
                                                                           style:UIBarButtonItemStylePlain
                                                                          target:self
                                                                          action:@selector(jumpToPostTopicVC)];
    rightBarButtonItem.tintColor = [UIColor blackColor];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
}


- (TYTextContainer *)creatTextContainer:(SingleReplyEntity *)singleReplyEntity
{
    TYTextContainer *textContainer = [[TYTextContainer alloc]init];
    textContainer.font = [UIFont fontWithName:@"Helvetica" size:13.0];
    
    for(ContentBlockEntity *contentBlockEntity in singleReplyEntity.imageTextBlocks){
        if(contentBlockEntity.type==0){
            [textContainer appendText:contentBlockEntity.content];
        }else if(contentBlockEntity.type==1){
            TYImageStorage *imageUrlStorage = [[TYImageStorage alloc]init];
            //imageUrlStorage.imageURL = [NSURL URLWithString:contentBlockEntity.content];
            //[textContainer appendTextStorage:imageUrlStorage];
            //imageUrlStorage.size = CGSizeMake([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.width);
            NSString *imageKey = contentBlockEntity.content;
            UIImage *image = [[ImageStore sharedInstance] imageForKey:imageKey];
            
            CGSize size = CGSizeMake([UIScreen mainScreen].bounds.size.width, image.size.height*[UIScreen mainScreen].bounds.size.width/image.size.width);
            NSLog(@"image size:%f,%f",image.size.width,image.size.height);
            NSLog(@"display size:%f,%f",size.width,size.height);
            [textContainer appendImage: image size:size];
           
        }
    }
    return textContainer;
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return _textContainers.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SingleReplyCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId forIndexPath:indexPath];
    
    // Configure the cell...
    //cell.label.delegate = self;
    SingleReplyEntity *singleReplyEntity = (SingleReplyEntity *)_replyList[indexPath.row];
    cell.singleReplyEntity = singleReplyEntity;
    cell.label.textContainer = _textContainers[indexPath.row];
    //cell.nameLabel.text = singleReplyEntity.author;

    
    // 如果是直接赋值textContainer ，可以不用设置preferredMaxLayoutWidth，因为创建textContainer时，必须传正确的textwidth，即 preferredMaxLayoutWidth
    cell.label.preferredMaxLayoutWidth = CGRectGetWidth(tableView.frame);
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([[UIDevice currentDevice].systemVersion doubleValue] >= 8.0) {
        return UITableViewAutomaticDimension;
    }
    TYTextContainer *textContaner = _textContainers[indexPath.row];
    return textContaner.textHeight+30;// after createTextContainer, have value
}

#pragma mark refresh data

- (void)bottomDragRefreshData
{
    _replyList = [[SingleTopicReplysStore sharedInstance] getSingleReplyEntities:_topicUrl];
    [self.tableView reloadData];
    NSMutableArray *tmp = [NSMutableArray array];
    for(SingleReplyEntity *singleReplyEntity in _replyList){
        TYTextContainer * textContainer = [self creatTextContainer:singleReplyEntity];
        [tmp addObject:textContainer];
    }
    _textContainers = [tmp copy];
    [self.tableView reloadData];
    [self.tableView.mj_header endRefreshing];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
}

- (void)topDragRefreshData
{
    NSArray *array =[[HTMLParsingManager sharedInstance] parseTopicPage:_topicUrl forPage:++_refreshCount];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [_replyList addObjectsFromArray:array];
    NSMutableArray *tmp = [NSMutableArray array];
    for(SingleReplyEntity *singleReplyEntity in _replyList){
        TYTextContainer * textContainer = [self creatTextContainer:singleReplyEntity];
        [tmp addObject:textContainer];
    }
    _textContainers = [tmp copy];
    [self.tableView reloadData];
    [self.tableView.mj_footer endRefreshing];
}



@end

