//
//  URLRequestManager.m
//  SinoDefense
//
//  Created by Sarah Pan on 2016-06-24.
//  Copyright © 2016 Swipe Stack Ltd. All rights reserved.
//

#import "URLRequestManager.h"
#import <AFNetworking/AFNetworking.h>

@implementation URLRequestManager{
    NSString *_baseUrl;
}

+(id)sharedInstance
{
    static URLRequestManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

-(id)init {
    if (self = [super init]) {
        _baseUrl = @"https://www.sinodefenceforum.com/";
    }
    return self;
}

-(NSMutableURLRequest*)getLoginRequest: (NSString*) username withPassword: (NSString*)password
{
    //initialize url that is going to be fetched.
    NSURL *url = [NSURL URLWithString:@"https://www.sinodefenceforum.com/login/login"];
    
    //initialize a request from url
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[url standardizedURL]];
    
    //set http method
    [request setHTTPMethod:@"POST"];
    
    [request setHTTPShouldHandleCookies:YES];
    //initialize a post data
    NSString *postData = [[NSString alloc] initWithFormat:@"login=%@&register=0&password=%@&remember=1&cookie_check=1&_xfToken=&redirect=https%3A%2F%2Fwww.sinodefenceforum.com%2F",username,password];
    //set request content type we MUST set this value.
    
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    //set post data of request
    [request setHTTPBody:[postData dataUsingEncoding:NSUTF8StringEncoding]];
    
    return request;

}
-(NSMutableURLRequest*)getNewTopicRequest: (NSString*) title withContent: (NSString*)content withAttachment: (NSString*) attachment
{
    
    //initialize url that is going to be fetched.
    NSURL *url = [NSURL URLWithString:@"https://www.sinodefenceforum.com/strategic-defense.f6/create-thread"];
    
    //initialize a request from url
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[url standardizedURL]];
    
    //set http method
    [request setHTTPMethod:@"POST"];
    
    [request setHTTPShouldHandleCookies:YES];
    //initialize a post data
    NSString *postData = [[NSString alloc] initWithFormat:@"title=post&message_html=%3Cp%3Epost+post+post%3C%2Fp%3E&_xfRelativeResolver=https%3A%2F%2Fwww.sinodefenceforum.com%2Fstrategic-defense.f6%2Fcreate-thread&tags=&attachment_hash=27aaea75743299ef02afa97100224388&watch_thread_state=1&poll%5Bquestion%5D=&poll%5Bresponses%5D%5B%5D=&poll%5Bresponses%5D%5B%5D=&poll%5Bmax_votes_type%5D=single&poll%5Bchange_vote%5D=1&poll%5Bview_results_unvoted%5D=1&_xfToken=8439%2C1466823796%2Ce9183f39fc8cf4d5a7bfcb31691398365686832a&_xfRequestUri=%2Fstrategic-defense.f6%2Fcreate-thread&_xfNoRedirect=1&_xfToken=8439%2C1466823796%2Ce9183f39fc8cf4d5a7bfcb31691398365686832a&_xfResponseType=json"];
    //set request content type we MUST set this value.
    
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    //[request setValue:@"myCookie" forHTTPHeaderField:@"Cookie"];
    
    
    //set post data of request
    [request setHTTPBody:[postData dataUsingEncoding:NSUTF8StringEncoding]];
    return request;
}

-(NSMutableURLRequest*)getReplyRequest:(NSString*)replyId withTitle: (NSString*) title withContent: (NSString*)content withAttachment: (NSString*) attachment
{
    //initialize url that is going to be fetched.
    NSURL *url = [NSURL URLWithString:@"https://www.sinodefenceforum.com/pla-news-pics-and-discussion.t7250/add-reply"];
    
    //initialize a request from url
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[url standardizedURL]];
    
    //set http method
    [request setHTTPMethod:@"POST"];
    
    [request setHTTPShouldHandleCookies:YES];
    //initialize a post data
    
    NSString *message_html = @"%3Cp%3Ethis+is+interesting%3C%2Fp%3E";
    NSString *relativeResolver = @"https%3A%2F%2Fwww.sinodefenceforum.com%2Fpla-news-pics-and-discussion.t7250%2F";
    NSString *attachHash = @"2c9ac8658c79c1dd0a9a87634409b9a3";
    NSString *lastDate = @"1429117540&";
    NSString *lastKnownDate = @"1467600933";
    NSString *xfToken = @"8439%2C1467601036%2C9e1ef9c764351101346276401f07430f4cd867dd";
    NSString *xfRequestUri = @"_xfRequestUri";
    NSString *xfNoDirect = @"1";
    NSString *xfResponseType = @"json";
    
    
    NSString *replyData =[[NSString alloc] initWithFormat:@"message_html=%@", message_html];
    
    NSString *postData = [[NSString alloc] initWithFormat:@"message_html=%3Cp%3Ethis+is+interesting%3C%2Fp%3E&_xfRelativeResolver=https%3A%2F%2Fwww.sinodefenceforum.com%2Fpla-news-pics-and-discussion.t7250%2F&attachment_hash=2c9ac8658c79c1dd0a9a87634409b9a3&last_date=1429117540&last_known_date=1467600933&_xfToken=8439%2C1467601036%2C9e1ef9c764351101346276401f07430f4cd867dd&_xfRequestUri=%2Fpla-news-pics-and-discussion.t7250%2F&_xfNoRedirect=1&_xfToken=8439%2C1467601036%2C9e1ef9c764351101346276401f07430f4cd867dd&_xfResponseType=json"];
    //set request content type we MUST set this value.
    
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    //[request setValue:@"myCookie" forHTTPHeaderField:@"Cookie"];
    
    
    //set post data of request
    [request setHTTPBody:[postData dataUsingEncoding:NSUTF8StringEncoding]];
    return request;
    
    NSString *uploadRequestURI = @"https://www.sinodefenceforum.com/attachments/do-upload";
    
    
    
    
    
}


-(void)postReply:(NSString*)replyId withTitle: (NSString*) title withContent: (NSString*)content withAttachment: (NSString*) attachment
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSString *urlString = @"https://www.sinodefenceforum.com/pla-news-pics-and-discussion.t7250/add-reply";
    NSString *message_html = @"%3Cp%3Ethis+is+interesting%3C%2Fp%3E";
    NSString *relativeResolver = @"https%3A%2F%2Fwww.sinodefenceforum.com%2Fpla-news-pics-and-discussion.t7250%2F";
    NSString *attachHash = @"2c9ac8658c79c1dd0a9a87634409b9a3";
    NSString *lastDate = @"1429117540&";
    NSString *lastKnownDate = @"1467600933";
    NSString *xfToken = @"8439%2C1467601036%2C9e1ef9c764351101346276401f07430f4cd867dd";
    NSString *xfRequestUri = @"_xfRequestUri";
    NSString *xfNoDirect = @"1";
    NSString *xfResponseType = @"json";
    NSDictionary *params = @{@"message_html": message_html,
                             @"relativeResolver": relativeResolver,
                             @"attachHash":attachHash,
                             @"lastDate":lastDate,
                             @"lastKnownDate":lastKnownDate,
                             @"xfToken":xfToken,
                             @"xfRequestUri":xfRequestUri,
                             @"xfNoDirect":xfNoDirect,
                             @"xfResponseType":xfResponseType};
    [manager POST:@"https://example.com/myobject"
            parameters:params 
    success:^(NSURLSessionDataTask *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}


@end
