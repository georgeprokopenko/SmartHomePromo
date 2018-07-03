//
//  Mapper.h
//  DomophoneApp
//
//  Created by George Prokopenko on 18.03.2018.
//  Copyright © 2018 George Prokopenko. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "SignInViewController.h"
#import "IntercomDetailViewController.h"
#import "SettingsViewController.h"
#import "ResetAccessViewController.h"
#import "CustomAlertView.h"

typedef enum CustomViewController : NSInteger {
    kMainViewController = 0,
    kSignInPage,
    kIntercomDetailPage,
    kSettingsPage,
    kAccessResetPage,
} CustomViewController;

@interface Mapper : NSObject


#pragma mark Presenting View Controller

+ (void) pushViewController:(UIViewController*)nextViewController
                       from:(UIViewController *)controller
                   animated:(BOOL)animated;

+ (void) presentViewController:(UIViewController*)nextViewController
                          from:(UIViewController *)controller
                      animated:(BOOL)animated;

+ (void) presentCustomViewController:(CustomViewController)nextViewController
                                from:(UIViewController *)controller
            withNavigationController:(BOOL)navigation
                            animated:(BOOL)animated;


+ (void) pushCustomViewController:(CustomViewController)nextViewController
                             from:(UIViewController *)controller
                         animated:(BOOL)animated;

+ (void) presentCustomViewController:(CustomViewController)nextViewController
                                from:(UIViewController *)controller
                            animated:(BOOL)animated;

+ (UIViewController*) customViewController:(CustomViewController)customVC;


#pragma mark Alert Controllers

+ (void) showAlertController:(UIAlertController*)alert from:(id)controller;

+ (void) showCustomAlertWithType:(CustomAlertViewType)type;

@end
