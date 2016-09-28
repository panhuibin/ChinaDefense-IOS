//
//  HttpSessionManager.m
//  SinoDefense
//
//  Created by Sarah Pan on 2016-08-11.
//  Copyright © 2016 Sarah Pan. All rights reserved.
//

#import "HttpSessionManager.h"
#import "URLRequestManager.h"

@implementation HttpSessionManager

+ (id)sharedInstance {
    static HttpSessionManager *sessionManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sessionManager = [[HttpSessionManager alloc] init];
    });
    
    return sessionManager;
}

-(void)sendPost:(NSURLRequest*) request completionHandler:(void (^)(bool isSuccessful))completionHandler
{
    NSLog(@"%@",[self formatURLRequest:request]);
    NSURLSession* session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]
                                                          delegate:nil
                                                     delegateQueue:[NSOperationQueue mainQueue]];
    NSURLSessionTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error) {
            NSLog(@"dataTaskWithRequest error: %@", error);
        }
        NSLog(@"%@", [self formatURLResponse:response withData:data]);
        if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
            NSInteger statusCode = [(NSHTTPURLResponse *)response statusCode];
            if (statusCode != 200) {
                NSLog(@"Expected responseCode == 200; received %ld", (long)statusCode);
                completionHandler(false);
            }else{
                completionHandler(true);
            }
        }
    }];
    [task resume];
}

- (NSString *)formatURLRequest:(NSURLRequest *)request
{
    NSMutableString *message = [NSMutableString stringWithString:@"---REQUEST------------------\n"];
    [message appendFormat:@"URL: %@\n",[request.URL description] ];
    [message appendFormat:@"METHOD: %@\n",[request HTTPMethod]];
    for (NSString *header in [request allHTTPHeaderFields])
    {
        [message appendFormat:@"%@: %@\n",header,[request valueForHTTPHeaderField:header]];
    }
    [message appendFormat:@"BODY: %@\n",[[NSString alloc] initWithData:[request HTTPBody] encoding:NSUTF8StringEncoding]];
    [message appendString:@"----------------------------\n"];
    return [NSString stringWithFormat:@"%@",message];
}

- (NSString *)formatURLResponse:(NSHTTPURLResponse *)response withData:(NSData *)data
{
    NSString *responsestr = [[NSString alloc] initWithBytes:[data bytes] length:[data length] encoding:NSUTF8StringEncoding];
    NSMutableString *message = [NSMutableString stringWithString:@"---RESPONSE------------------\n"];
    [message appendFormat:@"URL: %@\n",[response.URL description] ];
    [message appendFormat:@"MIMEType: %@\n",response.MIMEType];
    [message appendFormat:@"Status Code: %ld\n",(long)response.statusCode];
    for (NSString *header in [[response allHeaderFields] allKeys])
    {
        [message appendFormat:@"%@: %@\n",header,[response allHeaderFields][header]];
    }
    [message appendFormat:@"Response Data: %@\n",responsestr];
    [message appendString:@"----------------------------\n"];
    return [NSString stringWithFormat:@"%@",message];
}



@end
