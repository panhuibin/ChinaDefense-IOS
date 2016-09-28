//
//  MasterViewController.m
//  HTMLParsing
//
//  Created by Matt Galloway on 19/05/2012.
//  Copyright (c) 2012 Swipe Stack Ltd. All rights reserved.
//

#import "CategoriesViewController.h"

#import "SingleForumViewController.h"

#import "TFHpple.h"
#import "SingleForumEntity.h"
#import "SingleReplyEntity.h"
#import "HTMLParsingManager.h"
#import "CategoryStore.h"
#import "SingleCategory.h"
#import "SingleForumEntity.h"
#import "CategoryStore.h"

@interface CategoriesViewController() {
    NSArray *_categories;
}
@end

@implementation CategoriesViewController


@synthesize singleForumViewController = _singleForumViewController;


- (void)loadCategories {
    //_categories = [[HTMLParsingManager sharedInstance] parseFrontPageCategories];
    _categories = [[CategoryStore sharedInstance] getCategories];
    [self.tableView reloadData];
    
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        UINavigationItem *navItem = self.navigationItem;
        navItem.title = @"Categories";
        //[self createRightButtonItem];
    }
    return self;
}

- (void)createRightButtonItem {
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"pencil_square_icon"]
                                                                           style:UIBarButtonItemStylePlain
                                                                          target:self
                                                                          action:@selector(jumpToPostTopicVC)];
    rightBarButtonItem.tintColor = [UIColor colorWithRed:0.502 green:0.776 blue:0.200 alpha:1.000];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;

}

							
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadCategories];
    
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}


#pragma mark - Table View

- (NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return ((SingleCategory *) _categories[section]).title;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [_categories count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [((SingleCategory *) _categories[section]).forums count];
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.imageView.image = [UIImage imageNamed:@"essential_icon.png"];
        cell.imageView.highlightedImage = [UIImage imageNamed:@"essential_selected_icon.png"];
    }
    SingleForumEntity *thisForum = (SingleForumEntity *) ((SingleCategory *) _categories[indexPath.section]).forums[indexPath.row];
    cell.textLabel.text = thisForum.title;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!self.singleForumViewController) {
        //self.singleForumViewController = [[SingleForumViewController alloc] initWithNibName:@"SingleForumViewController" bundle:nil];
        self.singleForumViewController =[[SingleForumViewController alloc]  initWithStyle:UITableViewStylePlain];
    }
    
    SingleForumEntity *thisForum = (SingleForumEntity *) ((SingleCategory *) _categories[indexPath.section]).forums[indexPath.row];
    self.singleForumViewController.forumUrl = thisForum.url;
    self.singleForumViewController.forumTitle = thisForum.title;
    [self.navigationController pushViewController:self.singleForumViewController animated:YES];
}

@end
