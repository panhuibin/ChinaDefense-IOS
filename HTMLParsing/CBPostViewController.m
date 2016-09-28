//
//  CBPostViewController.m
//  iOS-Carbon-Forum
//
//  Created by WangShengFeng on 15/12/22.
//  Copyright © 2015年 WangShengFeng. All rights reserved.
//

#import "CBPostViewController.h"
#import <AFNetworking/AFNetworking.h>
#import <SVProgressHUD/SVProgressHUD.h>

@interface CBPostViewController () <UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UITextView *titleTextView;
@property (weak, nonatomic) IBOutlet UITextView *contentTextView;
@property (weak, nonatomic) IBOutlet UITextView *tagTextView;

@property (nonatomic, weak) UILabel *titlePlaceHolder;
@property (nonatomic, weak) UILabel *contentPlaceHolder;
@property (nonatomic, weak) UILabel *tagPlaceHolder;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleViewTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleViewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tagViewTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tagViewHeight;

@end

@implementation CBPostViewController


- (void)viewDidLoad
{
    [super viewDidLoad];

    [self setupNav];

    self.titleTextView.tintColor = [UIColor blueColor];
    self.titleTextView.delegate = self;
    self.contentTextView.tintColor = [UIColor blueColor];
    self.contentTextView.delegate = self;
    self.tagTextView.tintColor = [UIColor blueColor];
    self.tagTextView.delegate = self;
    [self setupPlaceHolder];

    [self setupPostSetting];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    [self.contentTextView becomeFirstResponder];
}

- (void)dealloc
{
    [[AFHTTPSessionManager manager].operationQueue cancelAllOperations];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

- (void)setupNav
{
    self.title = self.titleText;

    UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [closeButton setImage:[UIImage imageNamed:@"setting_close"] forState:UIControlStateNormal];
    [closeButton sizeToFit];
    [closeButton addTarget:self action:@selector(closeBtnClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:closeButton];

    UIButton *postButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [postButton setImage:[UIImage imageNamed:@"nav_post"] forState:UIControlStateNormal];
    [postButton sizeToFit];
    [postButton addTarget:self action:@selector(postBtnClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:postButton];
}

- (void)closeBtnClick
{
    [self.view endEditing:YES];

    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)postBtnClick
{
    if (self.postSetting == CBNew) {
        if (!self.titleTextView.text.length || !self.contentTextView.text.length || !self.tagTextView.text.length) {
            // 空判断
            [SVProgressHUD showErrorWithStatus:@"请输入内容"];
            return;
        }
    }
    if (self.postSetting == CBReply) {
        if (!self.contentTextView.text.length) {
            [SVProgressHUD showErrorWithStatus:@"请输入内容"];
            return;
        }
    }

    [self.view endEditing:YES];
    [[AFHTTPSessionManager manager].operationQueue cancelAllOperations];

    NSString *urlStr;
    if (self.postSetting == CBNew) {
        urlStr = @"new";
    }
    if (self.postSetting == CBReply) {
        urlStr = @"reply";
    }
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    if (self.postSetting == CBNew) {
        [params setObject:self.titleTextView.text forKey:@"Title"];
        [params setObject:self.contentTextView.text forKey:@"Tag[]"];
        [params setObject:self.contentTextView.text forKey:@"Content"];
    }
    if (self.postSetting == CBReply) {
        [params setObject:self.TopicID forKey:@"TopicID"];
        [params setObject:self.contentTextView.text forKey:@"Content"];
    }

    [[AFHTTPSessionManager manager] POST:urlStr
        parameters:params
        success:^(NSURLSessionDataTask *_Nonnull task, id _Nonnull responseObject) {
            [SVProgressHUD showSuccessWithStatus:@"发布成功"];
            dispatch_after(
                dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self dismissViewControllerAnimated:YES completion:nil];
                });
        }
        failure:^(NSURLSessionDataTask *_Nullable task, NSError *_Nonnull error) {
            NSLog(@"%@", error);
        }];
}

- (void)setupPlaceHolder
{
    UILabel *titlePlaceHolder = [[UILabel alloc] init];
    titlePlaceHolder.text = @"请输入标题";
    titlePlaceHolder.font = [UIFont systemFontOfSize:14];
    titlePlaceHolder.textColor = [UIColor blackColor];
    titlePlaceHolder.frame = CGRectMake(5, 8, 0, 0);
    [titlePlaceHolder sizeToFit];

    self.titlePlaceHolder = titlePlaceHolder;
    [self.titleTextView addSubview:titlePlaceHolder];

    UILabel *tagPlaceHolder = [[UILabel alloc] init];
    tagPlaceHolder.text = @"请输入标签";
    tagPlaceHolder.font = [UIFont systemFontOfSize:14];
    tagPlaceHolder.textColor = [UIColor blackColor];
    tagPlaceHolder.frame = CGRectMake(5, 8, 0, 0);
    [tagPlaceHolder sizeToFit];

    self.tagPlaceHolder = tagPlaceHolder;
    [self.tagTextView addSubview:tagPlaceHolder];

    UILabel *contentPlaceHolder = [[UILabel alloc] init];
    contentPlaceHolder.text = @"请输入内容";
    contentPlaceHolder.font = [UIFont systemFontOfSize:14];
    contentPlaceHolder.textColor = [UIColor blackColor];
    contentPlaceHolder.frame = CGRectMake(5, 8, 0, 0);
    [contentPlaceHolder sizeToFit];

    self.contentPlaceHolder = contentPlaceHolder;
    [self.contentTextView addSubview:contentPlaceHolder];
}

- (void)textViewDidChange:(UITextView *)textView
{
    if (textView == self.titleTextView) {
        if (textView.text.length) {
            self.titlePlaceHolder.alpha = 0;
        }
        if (!textView.text.length) {
            self.titlePlaceHolder.alpha = 1;
        }
    }

    if (textView == self.contentTextView) {
        if (textView.text.length) {
            self.contentPlaceHolder.alpha = 0;
        }
        if (!textView.text.length) {
            self.contentPlaceHolder.alpha = 1;
        }
    }

    if (textView == self.tagTextView) {
        if (textView.text.length) {
            self.tagPlaceHolder.alpha = 0;
        }
        if (!textView.text.length) {
            self.tagPlaceHolder.alpha = 1;
        }
    }
}

- (void)setupPostSetting
{
    if (self.postSetting == CBNew) {
        // 发帖
    }

    if (self.postSetting == CBReply) {
        // 回帖
        self.titleViewTop.constant = 0;
        self.titleViewHeight.constant = 0;
        self.tagViewTop.constant = 0;
        self.tagViewHeight.constant = 0;
    }
}

@end
