//
//  MainViewController.m
//  DomophoneApp
//
//  Created by George Prokopenko on 14.04.2018.
//  Copyright © 2018 George Prokopenko. All rights reserved.
//

#import "MainViewController.h"
#import "MainTabBarController.h"
#import "MyIntercomsViewController.h"
#import "AccountManager.h"
#import "AppDelegate.h"
#import "Mapper.h"
#import "Constants.h"

#define APPDelegate (AppDelegate*)[UIApplication sharedApplication].delegate


@interface MainViewController ()
@property (retain, nonatomic) MainTabBarController* tabBarController;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomBarBottomConstraint;
@property (weak, nonatomic) IBOutlet UIView *containerView;

@property (weak, nonatomic) IBOutlet UIButton *intercomButton;
@property (weak, nonatomic) IBOutlet UIButton *aboutButton;
@property (weak, nonatomic) IBOutlet UIButton *settingsButton;
@property (weak, nonatomic) IBOutlet UIButton *promoButton;

@end

@implementation MainViewController 

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupContainerView];
    [self setupNotificators];
    [self tabBarItemSelected:self.intercomButton];
}

- (void) viewDidAppear:(BOOL)animated {
    if (![AccountManager shared].userAccount) [self authNeeded];
    else [self authDone];
}

- (void) setupContainerView {
    self.tabBarController = [[MainTabBarController alloc] init];
    [self.tabBarController.view setFrame:self.containerView.bounds];
    [self.containerView addSubview:self.tabBarController.view];
    [self addChildViewController:self.tabBarController];
    
    [self.tabBarController didMoveToParentViewController:self];
    [self.tabBarController initViewControllersWithMain:self];
    self.tabBarController.tabBar.hidden = YES;
}

- (void) setupNotificators {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(authNeeded) name:kAuthNeeded object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(authDone) name:kAuthDone object:nil];
}

- (void) authNeeded {
    [Mapper presentCustomViewController:kSignInPage from:self withNavigationController:YES animated:YES];
}

- (void) authDone {
    [self tabBarItemSelected:self.intercomButton];
    UINavigationController* myIntercomsNC = [self.tabBarController.viewControllers firstObject];
    MyIntercomsViewController* myIntercomsVC = [myIntercomsNC.viewControllers firstObject];
    [myIntercomsVC loadIntercoms];
}



#pragma mark Bottom Bar

- (void) unselectAllItemsAndSelect:(UIButton*)button {
    [self.intercomButton setSelected:NO];
    [self.settingsButton setSelected:NO];
    [self.aboutButton setSelected:NO];
    [self.promoButton setSelected:NO];
    [button setSelected:YES];
}

-(IBAction)tabBarItemSelected:(UIButton*)item {
    [self.tabBarController setSelectedIndex:item.tag];
    [self unselectAllItemsAndSelect:item];
}

- (void) hideTabBar {
    self.bottomBarBottomConstraint.constant = -self.bottomBar.bounds.size.height;
    [UIView animateWithDuration:0.4 animations:^{
        [self.view layoutIfNeeded];
    }];
}

- (void) showTabBar {
    self.bottomBarBottomConstraint.constant = 0;
    [UIView animateWithDuration:0.4 animations:^{
        [self.view layoutIfNeeded];
    }];
}



#pragma mark Calling

- (void) showIncomingCallFromIntercomID:(NSString*)callID {
    UINavigationController* myIntercomsNC = [self.tabBarController.viewControllers firstObject];
    MyIntercomsViewController* myIntercomsVC = [myIntercomsNC.viewControllers firstObject];
    [myIntercomsVC openCallPageWith:callID];
}




@end
