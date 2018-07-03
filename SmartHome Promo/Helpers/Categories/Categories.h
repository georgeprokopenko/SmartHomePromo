//
//  Categories.h
//  linphone
//
//  Created by George Prokopenko on 25/06/2018.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Categories : NSObject
@end


#pragma mark UIImageView Category

@interface UIImageView (UIImageViewAnimations)
- (void) show;
- (void) hide;
@end

@implementation UIImageView (UIImageViewAnimations)

- (void) show {
    self.alpha = 0.0;
    self.hidden = NO;
    self.transform = CGAffineTransformMakeScale(0.6, 0.6);
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.alpha = 1.0;
        self.transform = CGAffineTransformMakeScale(1.0, 1.0);
    } completion:nil];
}
- (void) hide {
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.alpha = 0.0;
        self.transform = CGAffineTransformMakeScale(0.6, 0.6);
    } completion:^(BOOL finished) {
        self.hidden = YES;
    }];
}
@end


#pragma mark UINavigationController Category

@interface UINavigationController (NavControllerAppearance)
+ (void) setBarDesignApperance;
@end

@implementation UINavigationController (NavControllerAppearance)
+ (void) setBarDesignApperance {
    [[UINavigationBar appearance] setTranslucent:NO];
    [UINavigationBar appearance].barTintColor = [UIColor colorWithRed:38.0/255.0 green:45.0/255.0 blue:55.0/255.0 alpha:1.0f];
    [UINavigationBar appearance].tintColor = [UIColor whiteColor];
    [[UINavigationBar appearance] setTitleTextAttributes: @{NSForegroundColorAttributeName: [UIColor whiteColor]}];
}
@end


#pragma mark UIView Category

@interface UIView (Shake)
- (void) shake;
@end

@implementation UIView (Shake)
- (void) shake {
    CAKeyframeAnimation* animation = [CAKeyframeAnimation animationWithKeyPath:@"transform.translation.x"];
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    animation.duration = 0.6;
    animation.values = @[@(-18.0), @(18.0), @(-18.0), @(18.0), @(-8.0), @(8.0), @(-3.0), @(3.0), @(0.0)];
    [self.layer addAnimation:animation forKey:@"shake"];
}
@end
