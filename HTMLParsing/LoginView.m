//
//  LoginView.m
//  SinoDefense
//
//  Created by Sarah Pan on 2016-06-24.
//  Copyright © 2016 Swipe Stack Ltd. All rights reserved.
//

#import "LoginView.h"

@interface  LoginView(){
    UILabel *_userNameLabel;
    UILabel *_passwordLabel;
    UITextField *_userNameField;
    UITextField *_passwordField;
    UIButton *_submitButton;
}

@end
@implementation LoginView

-(instancetype)init
{
    self=[super init];
    if (self)
    {
        self.backgroundColor=[UIColor whiteColor];
        [self addViews];
        [self setLayout];
    }
    return self;
}

-(void)addViews
{
    _userNameLabel = [[UILabel alloc] init];
    _userNameLabel.text = @"UserName:";
    _userNameLabel.backgroundColor =[UIColor clearColor];
    [self addSubview:_userNameLabel];
    
    _passwordLabel = [[UILabel alloc] init];
    _passwordLabel.text = @"Password:";
    _passwordLabel.backgroundColor =[UIColor clearColor];
    [self addSubview:_passwordLabel];
    
    
    _userNameField = [[UITextField alloc] init];
    _userNameLabel.text = @"UserName:";
    _userNameLabel.backgroundColor =[UIColor clearColor];
    [self addSubview:_userNameLabel];
    
    _passwordField = [[UITextField alloc] init];
    _passwordField.text = @"Password:";
    _passwordField.backgroundColor =[UIColor clearColor];
    [self addSubview:_passwordField];
    
    _submitButton = [[UIButton alloc] init];
    _submitButton.titleLabel.text = @"Submit";
    _submitButton.layer.cornerRadius = 10.0f;
    _submitButton.layer.borderWidth = 0.5;
    _submitButton.layer.borderColor = [[UIColor blueColor] CGColor];
    
    [self addSubview: _submitButton];
}

-(void)setLayout
{

    _userNameLabel.frame = CGRectMake(40, 100, 100, 40);
    _passwordLabel.frame = CGRectMake(40, 200, 100, 40);
    _userNameField.frame = CGRectMake(180, 100, 100, 40);
    _passwordField.frame = CGRectMake(180, 200, 100, 40);
    _submitButton.frame = CGRectMake(200, 300, 100, 40);
}

@end
