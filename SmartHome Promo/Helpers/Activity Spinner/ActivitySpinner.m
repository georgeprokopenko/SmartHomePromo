//
//  ActivitySpinner.m
//  DomophoneApp
//
//  Created by George Prokopenko on 20.05.2018.
//  Copyright © 2018 George Prokopenko. All rights reserved.
//

#define SetProcessTimeout(timeout) [ActivitySpinner shared].processTimoutTimer = [NSTimer scheduledTimerWithTimeInterval:timeout target:self selector:@selector(dismiss) userInfo:nil repeats:NO];
#define StopProcessTimeout [[ActivitySpinner shared].processTimoutTimer invalidate]; [ActivitySpinner shared].processTimoutTimer = nil;

#import "ActivitySpinner.h"
@interface ActivitySpinner ()
@property NSTimer* processTimoutTimer;
@property (strong, nonatomic) UIImageView* spinner;
@end
@implementation ActivitySpinner

+ (instancetype) shared {
    static dispatch_once_t once;
    static id sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

+ (void) setupSpinner {
    if (![ActivitySpinner shared].spinner) {
        [ActivitySpinner shared].spinner = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"spinner"]];
        [[ActivitySpinner shared].spinner setFrame:CGRectMake(0, 0, 32, 32)];
    }
}


#pragma mark Showing

+ (void) show {
    [self setupSpinner];
    [ActivitySpinner shared].spinner.transform = CGAffineTransformMakeScale(0.0, 0.0);
    [[UIApplication sharedApplication].keyWindow addSubview:[ActivitySpinner shared].spinner];
    [self rotateSpinner:YES];
    [ActivitySpinner shared].spinner.center = [UIApplication sharedApplication].keyWindow.center;
    [UIView animateWithDuration:0.4 animations:^{
        [ActivitySpinner shared].spinner.transform = CGAffineTransformMakeScale(1.0, 1.0);
    }];
}

+ (void) showWithTimout:(int)timeout completionHandler:(void (^)(BOOL completed))block {
    SetProcessTimeout(timeout);
    [self setupSpinner];
    [ActivitySpinner shared].spinner.transform = CGAffineTransformMakeScale(0.0, 0.0);
    [[UIApplication sharedApplication].keyWindow addSubview:[ActivitySpinner shared].spinner];
    [self rotateSpinner:YES];
    [ActivitySpinner shared].spinner.center = [UIApplication sharedApplication].keyWindow.center;
    [UIView animateWithDuration:0.4 animations:^{
        [ActivitySpinner shared].spinner.transform = CGAffineTransformMakeScale(1.0, 1.0);
    }];
    
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, timeout * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        if (block && [ActivitySpinner shared].processTimoutTimer) block(YES);
    });
}

+ (void) showInView:(UIView*)view {
    [self setupSpinner];
    [ActivitySpinner shared].spinner.transform = CGAffineTransformMakeScale(0.0, 0.0);
    [view addSubview:[ActivitySpinner shared].spinner];
    [self rotateSpinner:YES];
    [ActivitySpinner shared].spinner.center = view.center;
    [UIView animateWithDuration:0.4 animations:^{
        [ActivitySpinner shared].spinner.transform = CGAffineTransformMakeScale(1.0, 1.0);
    }];
}

+ (void) showWithDuration:(int)seconds {
    
}

+ (void) dismiss {
    StopProcessTimeout;
    [UIView animateWithDuration:0.3 animations:^{
        [ActivitySpinner shared].spinner.transform = CGAffineTransformMakeScale(0.0, 0.0);
    }];
    [ActivitySpinner shared].spinner = nil;
}

+ (void) rotateSpinner:(BOOL)rotate {
    CABasicAnimation* rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0 ];
    rotationAnimation.duration = 3;
    rotationAnimation.cumulative = YES;
    rotationAnimation.repeatCount = HUGE_VALF;
    [[ActivitySpinner shared].spinner.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
}



@end
