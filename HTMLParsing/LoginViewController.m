//
//  LoginViewController.m
//  PHPHub
//
//  Created by Aufree on 9/30/15.
//  Copyright (c) 2015 ESTGroup. All rights reserved.
//

#import "LoginViewController.h"
#import "WebViewController.h"
#import "CookieManager.h"
#import "UserManager.h"
#import "SidebarMenuViewController.h"
#import "URLRequestManager.h"

@interface LoginViewController ()


@end

@implementation LoginViewController
NSString *username;
NSString *password;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"Login";
    self.navigationItem.hidesBackButton = YES;
    
    [self drawButtonBorder:_loginButton borderColor:[UIColor blueColor]];
    [self toggleLoginView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)dealloc {
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - draw

- (void)drawButtonBorder:(UIButton *)button borderColor:(UIColor *)color {
    button.layer.cornerRadius = 10.0f;
    button.layer.borderWidth = 0.5;
    button.layer.borderColor = color.CGColor;
}

#pragma mark - toggle login log out views

- (void) toggleLoginView{
    if([[UserManager sharedInstance] isLogin]==NO){
        [_emailField setHidden:NO];
        [_passwordField setHidden:NO];
        [_loginButton setHidden:NO];
        [_emailLabel setHidden:YES];
        [_passwordLabel setHidden:YES];
        [_logoutButton setHidden:YES];
    }else{
        [_emailField setHidden:YES];
        [_passwordField setHidden:YES];
        [_loginButton setHidden:YES];
        [_emailLabel setHidden:NO];
        [_passwordLabel setHidden:NO];
        [_logoutButton setHidden:NO];
        _emailLabel.text = username;
        _passwordLabel.text = password;
    }
    
}


#pragma mark - login logout

- (IBAction)loginSubmit:(id)sender {
    username = self.emailField.text;
    password = self.passwordField.text;
    
    NSMutableURLRequest *request = [[URLRequestManager sharedInstance] getLoginRequest:username withPassword:password];
        //initialize a connection from request
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    self.connection = connection;
    //start the connection
    [connection start];
    

}
- (IBAction)logoutSubmit:(id)sender {
    [[CookieManager sharedInstance] clearCookies];
    [self toggleLoginView];
    [self.view setNeedsDisplay];
}

#pragma mark - NSURLConnection delegate
/*
 this method might be calling more than one times according to incoming data size
 */

-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    
    [[CookieManager sharedInstance] saveCookies];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:username forKey:@"username"];
    [userDefaults synchronize];
    
    if(![[UserManager sharedInstance] isLogin]){
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"Sign In Failed" delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
        [alertView show];
    }else{
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"Sign In Successful" delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
        [alertView show];
        [self toggleLoginView];
        [self.view setNeedsDisplay];
    }
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    
    NSLog(@"%@" , error);
}





 


@end
