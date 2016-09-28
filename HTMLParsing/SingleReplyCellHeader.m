//
//  MyTableViewCellHeader.m
//  SinoDefense
//
//  Created by Sarah Pan on 2016-06-16.
//  Copyright © 2016 Swipe Stack Ltd. All rights reserved.
//

#import "SingleReplyCellHeader.h"
#import "config.h"
#import "ReplyViewController.h"
#import "SidebarMenuViewController.h"

@interface SingleReplyCellHeader()
{
    UIView *_upperSeparator;
    UIView *_lowerSeparator;
    UIImageView *_imgAvatarView;
    UILabel *_userName;
    UILabel *_replyTime;
    UIButton *_replyButton;
}
@end

@implementation SingleReplyCellHeader

-(instancetype)init
{
    self=[super init];
    if (self)
    {
        self.backgroundColor=[UIColor whiteColor];
        [self configurationContentView];
        [self configurationLocation];
    }
    return self;
}

#pragma 配置view
-(void)configurationContentView
{
    //头像
    _imgAvatarView=[[UIImageView alloc]init];
    _imgAvatarView.backgroundColor=[UIColor clearColor];
    [self addSubview:_imgAvatarView];
    
    
    
    //名称View
    _replyButton=[UIButton buttonWithType:UIButtonTypeCustom];
    _replyButton.backgroundColor=[UIColor blueColor];
    [_replyButton.layer setBorderColor:[[UIColor blackColor] CGColor]];
    [_replyButton setTitle:@"Re" forState:UIControlStateNormal];
    [_replyButton addTarget:self action:@selector(replyButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_replyButton];
    
    
    //用户昵称
    _userName=[[UILabel alloc]init];
    _userName.backgroundColor=[UIColor clearColor];
    _userName.font=TITLE_FONT_SIZE;
    _userName.textColor=RGBCOLOR(231,123,59);
    [self addSubview:_userName];
    
    
    
    //发布时间
    _replyTime=[[UILabel alloc]init];
    _replyTime.backgroundColor=[UIColor clearColor];
    _replyTime.font=SUBTITLE_FONT_SIZE;
    _replyTime.textAlignment=NSTextAlignmentLeft;
    _replyTime.textColor=RGBCOLOR(231,123,59);
    [self addSubview:_replyTime];
    
    _upperSeparator = [[UIView alloc] init];
    _upperSeparator.backgroundColor = [UIColor colorWithWhite:0.7 alpha:1];
    [self addSubview:_upperSeparator];
    
    _lowerSeparator = [[UIView alloc] init];
    _lowerSeparator.backgroundColor = [UIColor colorWithWhite:0.7 alpha:1];
    [self addSubview:_lowerSeparator];
    

}

#pragma mark － set Location
-(void)configurationLocation
{
    //should use auto layout
    _upperSeparator.frame = CGRectMake(0, 0, 320, 1);
    _imgAvatarView.frame=CGRectMake(0,1,HEAD_IAMGE_HEIGHT,HEAD_IAMGE_HEIGHT);
    _userName.frame=CGRectMake(HEAD_IAMGE_HEIGHT,1,Getwidth-HEAD_IAMGE_HEIGHT*2,19);
    _replyTime.frame=CGRectMake(HEAD_IAMGE_HEIGHT,20,Getwidth-HEAD_IAMGE_HEIGHT*2,19);
    _replyButton.frame=CGRectMake(Getwidth-HEAD_IAMGE_HEIGHT,0,HEAD_IAMGE_HEIGHT,HEAD_IAMGE_HEIGHT);
    _lowerSeparator.frame = CGRectMake(0, HEAD_IAMGE_HEIGHT, 320, 1);
    [self printSubviews:self];
}

-(void)setLocationWithAutoLayout
{
    NSDictionary *viewsDictionary = @{@"_upperSeperator":_upperSeparator, @"_imgAvatarView":_imgAvatarView, @"_userName":_userName};
}

#pragma mark - set Value

- (void)setSingleReplyEntity:(SingleReplyEntity *)singleReplyEntity
{
    _imgAvatarView.image = [UIImage imageNamed:@"ring_icon.png"];
    _userName.text = singleReplyEntity.author;
    _replyTime.text=@"0:0:0";
    [_replyButton setTitle:@"Reply" forState:UIControlStateNormal];
}



-(void) printSubviews:(UIView *)view
{
    if(view.subviews){
        for(UIView *subview in view.subviews){
            NSLog(@"%@",subview);
            if([subview isKindOfClass:[UILabel class]]){
                NSLog(@"%@",((UILabel *)subview).text);
            }else if([subview isKindOfClass:[UIImageView class]]){
                // NSLog(@"%@",((UIImageView *)subview).image);
            }
            if(subview.subviews){
                [self printSubviews:subview];
            }
        }
    }
}

#pragma mark - reply button action

- (void)replyButtonClick:(id)sender
{
    NSString *replyId = _singleReplyEntity.replyId;
    
    UIStoryboard *storyboard =[UIStoryboard storyboardWithName:@"ReplyView" bundle:[NSBundle mainBundle]];
    ReplyViewController *rvc =  (ReplyViewController*)[storyboard instantiateViewControllerWithIdentifier:@"ReplyView"];
    rvc.postTitle = [_singleReplyEntity.title copy];
    rvc.replyId = [_singleReplyEntity.replyId copy];
    SidebarMenuViewController *svc =(SidebarMenuViewController*)self.window.rootViewController;
    [(UINavigationController *)svc.containerController pushViewController:rvc animated:YES];
}

@end
