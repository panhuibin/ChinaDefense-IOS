

#import <UIKit/UIKit.h>

#define kToasterAnimationTime 0.25
#define kToasterDefaultDuration 2.5
#define kToasterDefaultDelay 0.0

@interface FrakkinToaster : NSObject {
    UIView *_view;
    UIView *_tintView;
    UIView *_backgroundView;
    UILabel *_messageLabel;
    UILabel *_titleLabel;
    float _duration;
    
    BOOL _isAnimationInProgress;
}

//By default a new toast will interrupt the currently displayed toast; to have the new toast display after a delay use this function:
+ (void)displayToastWithTitle:(NSString *)title message:(NSString *)message duration:(float)duration delay:(float)delay interruptCurrentToast:(BOOL)interrupt;
+ (void)displayToastWithMessage:(NSString *)message;
+ (void)displayToastWithTitle:(NSString *)title message:(NSString *)message;
+ (void)displayToastWithMessage:(NSString *)message forDuration:(float)duration;
+ (void)displayToastWithMessage:(NSString *)message forDuration:(float)duration withDelay:(float)delay;

+ (void)displayNoNetworkToast;
+ (void)displayLoginToKoboToast;
+ (void)displayLoginToFacebookToast;
@end
