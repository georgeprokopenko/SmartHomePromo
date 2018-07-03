//
//  MainTabBarController.m
//  DomophoneApp
//
//  Created by George Prokopenko on 12.04.2018.
//  Copyright © 2018 George Prokopenko. All rights reserved.
//

#import "MainTabBarController.h"

#import "AppDelegate.h"
#import "Constants.h"
#import "MyIntercomsViewController.h"
#import "SettingsViewController.h"
#import "DistrictInfoViewController.h"

@interface MainTabBarController ()

@end

@implementation MainTabBarController

- (void)didReceiveMemoryWarning {[super didReceiveMemoryWarning];}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNotificators];
}

- (void) setupNotificators {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tabBarSelectIndexOne) name:kMainTabBarSelectIndexOne object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tabBarSelectIndexTwo) name:kMainTabBarSelectIndexTwo object:nil];
}
     
- (void) initViewControllersWithMain:(MainViewController*)mainViewController {
    MyIntercomsViewController* myIntercomsVC = [[MyIntercomsViewController alloc] init];
    myIntercomsVC.mainViewController = mainViewController;
    UINavigationController* myIntercomsNC = [[UINavigationController alloc] initWithRootViewController:myIntercomsVC];
    
    SettingsViewController* settingsVC = [[SettingsViewController alloc] init];
    UINavigationController* settingsNC = [[UINavigationController alloc] initWithRootViewController:settingsVC];
    
    DistrictInfoViewController* districtPagesVC = [[DistrictInfoViewController alloc] init];
    
    [UINavigationController setBarDesignApperance];
    self.viewControllers = @[myIntercomsNC, settingsNC, districtPagesVC];
}


// v.1 ONLY
- (void) tabBarSelectIndexOne {
    [self setSelectedIndex:0];
}

- (void) tabBarSelectIndexTwo {
    [self setSelectedIndex:1];
}


@end
