//
//  Mapper.m
//  DomophoneApp
//
//  Created by George Prokopenko on 18.03.2018.
//  Copyright © 2018 George Prokopenko. All rights reserved.
//

#import "Mapper.h"
#import "AppDelegate.h"

@interface Mapper () <CustomAlertViewDelegate>
@property (strong, nonatomic) CustomAlertView* customAlert;
@end

@implementation Mapper

+ (instancetype) shared {
    static dispatch_once_t once;
    static id sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}


#pragma mark Presenting View Controllers

+ (void) pushCustomViewController:(CustomViewController)nextViewController from:(UIViewController *)controller animated:(BOOL)animated {
    [controller.navigationController pushViewController:[self customViewController:nextViewController] animated:animated];
}

+ (void) presentCustomViewController:(CustomViewController)nextViewController from:(UIViewController *)controller withNavigationController:(BOOL)navigation animated:(BOOL)animated {
    
    if (navigation) {
        UINavigationController* navController = [[UINavigationController alloc] initWithRootViewController:[self customViewController:nextViewController]];
        [controller presentViewController:navController animated:animated completion:nil];
    }
    else [controller presentViewController:[self customViewController:nextViewController] animated:animated completion:nil];
}

+ (void) presentCustomViewController:(CustomViewController)nextViewController from:(UIViewController *)controller animated:(BOOL)animated {
    [controller presentViewController:[self customViewController:nextViewController] animated:animated completion:nil];
}

+ (void) pushViewController:(UIViewController*)nextViewController from:(UIViewController *)controller animated:(BOOL)animated {
    [controller.navigationController pushViewController:nextViewController animated:animated];
}

+ (void) presentViewController:(UIViewController*)nextViewController from:(UIViewController *)controller animated:(BOOL)animated {
    [controller presentViewController:nextViewController animated:animated completion:nil];
}

+ (UIViewController*) customViewController:(CustomViewController)customVC {
    UIViewController* controller;
    if (customVC == kIntercomDetailPage) controller = [IntercomDetailViewController new];
    if (customVC == kSignInPage) controller = [SignInViewController new];
    if (customVC == kSettingsPage) controller = [SettingsViewController new];
    if (customVC == kAccessResetPage) controller = [ResetAccessViewController new];
    return controller;
}


#pragma mark Helpers


+ (UIViewController *) topViewController {
    return [self topViewController:[self applicationTop].rootViewController];
}

+ (UIWindow *) applicationTop {
    return [UIApplication sharedApplication].keyWindow;
}

+ (UIViewController *)topViewController:(UIViewController *)rootViewController {
    if (!rootViewController.presentedViewController) return rootViewController;
    if ([rootViewController.presentedViewController isKindOfClass:[UINavigationController class]]) {
        UINavigationController *navigationController = (UINavigationController *)rootViewController.presentedViewController;
        UIViewController *lastViewController = [[navigationController viewControllers] lastObject];
        return [self topViewController:lastViewController];
    }
    UIViewController *presentedViewController = (UIViewController *)rootViewController.presentedViewController;
    return [self topViewController:presentedViewController];
}



#pragma mark Alert Controllers

+ (void) showAlertController:(UIAlertController*)alert from:(id)controller {
    UIViewController* topVC;
    if ([controller isKindOfClass:[UIViewController class]]) topVC = controller;
    else topVC = [self topViewController];
    [topVC presentViewController:alert animated:YES completion:nil];
}



+ (void) showCustomAlertWithType:(CustomAlertViewType)type {
    [Mapper shared].customAlert = nil;
    [Mapper shared].customAlert = [[CustomAlertView alloc] init];
    [Mapper shared].customAlert.delegate = [Mapper shared];
    [Mapper shared].customAlert.modalPresentationStyle = UIModalPresentationOverFullScreen;
    [[self topViewController] presentViewController:[Mapper shared].customAlert animated:NO completion:^{
        [[Mapper shared].customAlert setupWithType:type];
        [[Mapper shared].customAlert show];
    }];
    
}

- (void) customAlertButtonTapped {
    [self.customAlert dismissViewControllerAnimated:NO completion:nil];
    self.customAlert = nil;
}


@end
