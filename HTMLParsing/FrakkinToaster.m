//
//  FrakkinToaster.m
//  Kobov3
//
//  Created by Charles Joseph on 10-11-15.
//  Copyright 2010 Kobo Inc. All rights reserved.
//

#import "FrakkinToaster.h"
#import <QuartzCore/QuartzCore.h>
#import "UIColor+SP.h"
#import "UIFont+SP.h"
#import "NSString+IntegralSizing.h"

static FrakkinToaster * volatile gInstance = nil;

@interface FrakkinToaster (Private)
- (void)displayToastWithTitle:(NSString *)title message:(NSString *)message duration:(float)duration delay:(float)delay;
- (void)dismissToast;
- (float)duration;
@property (nonatomic, readonly) UIView *view;
@end

@implementation FrakkinToaster

+ (FrakkinToaster *)sharedInstance
{
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        gInstance = [[FrakkinToaster alloc] init];
    });
    
    return gInstance;
}

#pragma mark -

+ (void)displayNoNetworkToast {
    [FrakkinToaster displayToastWithMessage:NSLocalizedString( @"You're not connected to the Internet.", @"No network toast message." ) forDuration:kToasterDefaultDuration withDelay:kToasterDefaultDelay];
}

+ (void)displayLoginToKoboToast {
    [FrakkinToaster displayToastWithMessage:NSLocalizedString(@"Sign into Kobo to join the conversation", @"Kobo login required for Pulse toast")];
}

+ (void)displayLoginToFacebookToast {
    [FrakkinToaster displayToastWithMessage:NSLocalizedString(@"Sign into Facebook to join the conversation", @"Facebook login required for Pulse toast")];
}

#pragma mark -

+ (void)displayToastWithMessage:(NSString *)message {
    [FrakkinToaster displayToastWithMessage:message forDuration:kToasterDefaultDuration withDelay:kToasterDefaultDelay];
}

+ (void)displayToastWithTitle:(NSString *)title message:(NSString *)message {
    FrakkinToaster *toaster = [FrakkinToaster sharedInstance];
    [toaster displayToastWithTitle:title message:message duration:kToasterDefaultDuration delay:kToasterDefaultDelay];
}

+ (void)displayToastWithMessage:(NSString *)message forDuration:(float)duration {
    [FrakkinToaster displayToastWithMessage:message forDuration:duration withDelay:kToasterDefaultDelay];
}

+ (void)displayToastWithMessage:(NSString *)message forDuration:(float)duration withDelay:(float)delay {
    FrakkinToaster *toaster = [FrakkinToaster sharedInstance];
    [toaster displayToastWithTitle:nil message:message duration:duration delay:delay];
}

+ (void)displayToastWithTitle:(NSString *)title message:(NSString *)message duration:(float)duration delay:(float)delay interruptCurrentToast:(BOOL)interrupt{
    FrakkinToaster *toaster = [FrakkinToaster sharedInstance];
    if (interrupt == NO && toaster.view.superview != nil) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, ([toaster duration] + kToasterAnimationTime) * NSEC_PER_SEC), dispatch_get_main_queue(), ^(void){
            [FrakkinToaster displayToastWithTitle:title message:message duration:duration delay:delay interruptCurrentToast:interrupt];
        });
    }
    else {
        [toaster displayToastWithTitle:title message:message duration:duration delay:delay];
    }
}

#pragma mark -

- (id)init {
    self = [super init];
    
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveMemoryWarning) name:UIApplicationDidReceiveMemoryWarningNotification object:nil];
    }
    
    return self;
}

- (void)createViewsIfNeeded {
    if (self.view != nil)
        return;
    
    _view = [[UIView alloc] initWithFrame:CGRectZero];
    _view.backgroundColor = [UIColor clearColor];
    _view.userInteractionEnabled = NO;
    _view.alpha = 0.0;
    _view.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    _view.accessibilityIdentifier=@"KBFrakinToaster";
    
    _tintView = [[UIView alloc] initWithFrame:CGRectZero];
    _tintView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    _tintView.backgroundColor = [UIColor blackColor];
    _tintView.alpha = 0.4;
    [_view addSubview:_tintView];
    
    _backgroundView = [[UIView alloc] initWithFrame:CGRectZero];
    _backgroundView.layer.cornerRadius = 5.0;
    _backgroundView.layer.masksToBounds = YES;
    _backgroundView.backgroundColor = [UIColor colorWithWhite:240.0/255.0 alpha:1.0];
    _backgroundView.layer.shouldRasterize = YES;
    _backgroundView.layer.rasterizationScale = [[UIScreen mainScreen] scale];
    _backgroundView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin;
    [_view addSubview:_backgroundView];
    
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _titleLabel.font =  [UIFont fontWithName:@"Avenir-Medium" size:20.0];
    _titleLabel.backgroundColor = _backgroundView.backgroundColor;
    _titleLabel.numberOfLines = 0;
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.textColor = [UIColor blackColor];
    [_backgroundView addSubview:_titleLabel];
    
    _messageLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _messageLabel.font = [UIFont fontWithName:@"Avenir-Medium" size:15.0];
    _messageLabel.backgroundColor = _backgroundView.backgroundColor;
    _messageLabel.numberOfLines = 0;
    _messageLabel.textAlignment = NSTextAlignmentCenter;
    _messageLabel.textColor = [UIColor blackColor];
    [_backgroundView addSubview:_messageLabel];
}

- (void)layoutViews {
    CGFloat width = 262, offset = 29;
    CGRect f = CGRectZero;
    
    _tintView.frame = _view.bounds;
    
    if (_titleLabel.text.length > 0) {
        _titleLabel.hidden = NO;
        f.size = [_titleLabel.text integralSizeWithFont:_titleLabel.font constrainedToSize:CGSizeMake(width - 80, CGFLOAT_MAX) lineBreakMode:_titleLabel.lineBreakMode];
        f.size.width = roundf(f.size.width) + 10;
        f.origin.x = roundf((width - f.size.width) / 2.0);
        f.origin.y = offset;
        _titleLabel.frame = f;
        offset = CGRectGetMaxY(f) + 13;
    }
    else {
        _titleLabel.hidden = YES;
    }
    
    if (_messageLabel.text.length > 0) {
        _messageLabel.hidden = NO;
        //f.size = [_messageLabel.text integralSizeWithFont:_messageLabel.font constrainedToSize:CGSizeMake(width - 60, CGFLOAT_MAX) lineBreakMode:_messageLabel.lineBreakMode];
        f.origin.x = roundf((width - f.size.width) / 2.0);
        f.origin.y = offset;
        _messageLabel.frame = f;
        offset = CGRectGetMaxY(f) + 13;
    }
    else {
        _messageLabel.hidden = YES;
    }
    
    offset += 16;
    
    if (((int)offset % 2) == 1)
        offset++;
    
    f.size = CGSizeMake(width, offset);
    f.origin.x = roundf((_view.bounds.size.width - f.size.width) / 2.0);
    f.origin.y = roundf((_view.bounds.size.height - f.size.height) / 2.0);
    _backgroundView.frame = f;
}

- (void)displayToastWithTitle:(NSString *)title message:(NSString *)message duration:(float)duration delay:(float)delay {
    [self createViewsIfNeeded];
    
    _backgroundView.transform = CGAffineTransformIdentity;
    
    UIView *window = [[UIApplication sharedApplication] keyWindow];
    self.view.frame = window.frame;
    
    if (self.view.superview == nil) {
        [window addSubview:self.view];
    }
    
    _titleLabel.text = title;
    _messageLabel.text = message;
    _duration = duration;
    
    [self layoutViews];
    
    if (_isAnimationInProgress == YES) {
        return;
    }
    else {
        _isAnimationInProgress = YES;
    }
    
    [UIView animateWithDuration:kToasterAnimationTime
                          delay:delay
                        options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         self.view.alpha = 1.0;
                     }
                     completion:^(BOOL finished){
                         [UIView animateWithDuration:kToasterAnimationTime
                                               delay:_duration
                                             options:UIViewAnimationOptionBeginFromCurrentState
                                          animations:^{
                                              self.view.alpha = 0.0;
                                          }
                                          completion:^(BOOL finished){
                                              if (self.view.alpha == 0) {
                                                  [self.view removeFromSuperview];
                                              }
                                              _isAnimationInProgress = NO;
                                          }];
                     }];
}

- (float)duration {
    return _duration;
}

- (UIView *)view {
    return _view;
}

- (void)didReceiveMemoryWarning {
    if (self.view.superview == nil) {
        _view = nil;
        _tintView = nil;
        _backgroundView = nil;
        _titleLabel = nil;
        _messageLabel = nil;
    }
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


@end
