//
//  MeViewController.m
//  PHPHub
//
//  Created by Aufree on 9/23/15.
//  Copyright (c) 2015 ESTGroup. All rights reserved.
//

#import "MeViewController.h"
//#import "NotificationListViewController.h"
#import "LoginViewController.h"
//#import "UserProfileViewController.h"
//#import "TopicListViewController.h"
#import "SettingsViewController.h"
//#import "CommentListViewController.h"
//#import "TOWebViewController.h"
#import "UserManager.h"

@interface MeViewController ()
@property (nonatomic, strong) User *user;
@property (weak, nonatomic) IBOutlet UILabel *unreadCountLabel;
@end

@implementation MeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"Me";
    self.tableView.contentInset = UIEdgeInsetsMake(-1.0f, 0.0f, 0.0f, 0.0);

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    //if ([[UserManager sharedInstance] isLogin]) {
        [self updateMeView];
        [self setupUnreadCountLabel];
    //}
    //else {
    //    LoginViewController *loginVC = [[UIStoryboard storyboardWithName:@"Passport"
    //                                                              bundle:[NSBundle mainBundle]]
    //                                    instantiateViewControllerWithIdentifier:@"login"];
    //    loginVC.delegate = self;
    //    [self.navigationController pushViewController:loginVC animated:NO];
    //}
}

- (void)setupUnreadCountLabel {
    if (self.navigationController.tabBarItem.badgeValue.integerValue > 0) {
        _unreadCountLabel.hidden = NO;
        _unreadCountLabel.text = self.navigationController.tabBarItem.badgeValue;
    }
}

- (void)updateUnreadCount:(NSNotification *)notification {
    NSNumber *unreadCount = notification.userInfo[@"unreadCount"];
    if (unreadCount.integerValue > 0) {
        _unreadCountLabel.hidden = NO;
        _unreadCountLabel.text = unreadCount.stringValue;
    } else {
        _unreadCountLabel.hidden = YES;
    }
}

- (void)updateMeView {
    //self.user = [UserManager sharedInstance].userInfo;
    
    if (_user) {
        //NSString *avatarHeight = [NSString stringWithFormat:@"%.f", _avatarImageView.height * 2];
        //NSURL *URL = [BaseHelper qiniuImageCenter:_userEntity.avatar withWidth:avatarHeight withHeight:avatarHeight];
        //[_avatarImageView sd_setImageWithURL:URL placeholderImage:[UIImage imageNamed:@"avatar_placeholder"]];
        _usernameLabel.text = _user.username;
        _userIntroLabel.text = _user.username;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return section == 0 ? 1.0f : UITableViewAutomaticDimension;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return section == 0 ? nil : @"";
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    UIViewController *vc;
    if (section == 0 && row == 0) {
    } else if (section == 1) {
        switch (row) {
            case 0: {
                break;
            } case 1: {
                //vc = [self createTopicListWithType:TopicListTypeAttention];
                break;
            } case 2: {
                //vc = [self createTopicListWithType:TopicListTypeFavorite];
                break;
            }
        }
    } else if (section == 2) {
        if (row == 0) {
            //vc = [self createTopicListWithType:TopicListTypeNormal];
        } else if (row == 1) {
            //[self jumpToCommentListView];
        } else if (row == 2) {
            vc = [[UIStoryboard storyboardWithName:@"Settings" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"settings"];
        }
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (vc) {
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
}
/*

- (TopicListViewController *)createTopicListWithType:(TopicListType)topicListType {
    TopicListViewController *topicListVC = [[TopicListViewController alloc] init];
    //topicListVC.userId = [[CurrentUser Instance] userId].integerValue;
    //topicListVC.topicListType = topicListType;
    return topicListVC;
}

- (void)jumpToCommentListView {
    CommentListViewController *commentListVC = [[CommentListViewController alloc] init];
    commentListVC.hidesBottomBarWhenPushed = YES;
    TopicEntity *topic = [TopicEntity new];
    topic.topicRepliesUrl = _userEntity.repliesUrl;
    commentListVC.topic = topic;
    [self.navigationController pushViewController:commentListVC animated:YES];
}
*/
@end