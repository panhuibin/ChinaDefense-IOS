//
//  WebViewController.h
//  ConnectionExample
//
//  Created by KEMAL KOCABIYIK on 2/25/12.
//  Copyright (c) 2012 Koc University. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WebViewController : UIViewController
@property (retain, nonatomic) NSString *str;
@property (nonatomic,strong) UIWebView *webView;
-(id) initWithString:(NSString *) str;
@end
