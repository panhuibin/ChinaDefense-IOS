//
//  WebViewController.m
//  ConnectionExample
//
//  Created by KEMAL KOCABIYIK on 2/25/12.
//  Copyright (c) 2012 Koc University. All rights reserved.
//

#import "WebViewController.h"

@implementation WebViewController
@synthesize str;


-(id) initWithString:(NSString *)s{
    
    self= [super init];
    
    if (self) {
        self.str = s;
    }
    
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    //load controller's web view with fetched str
    self.webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, 1024,768)];
    self.webView.delegate=self;
    NSString *path = [[NSBundle mainBundle] pathForResource:@"login" ofType:@"html"];
    NSString *html = [[NSString alloc] initWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    // Tell the web view to load it
    [self.webView loadHTMLString:html baseURL:[[NSBundle mainBundle] bundleURL]];
    //[self.webView loadHTMLString:self.str baseURL:nil];
    // Do any additional setup after loading the view from its nib.
    [self.view addSubview:self.webView];
}

- (void)viewDidUnload
{
    [self setWebView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


@end
