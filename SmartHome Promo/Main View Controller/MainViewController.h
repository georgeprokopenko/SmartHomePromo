//
//  MainViewController.h
//  DomophoneApp
//
//  Created by George Prokopenko on 14.04.2018.
//  Copyright © 2018 George Prokopenko. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AccountManager.h"

@interface MainViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIView *bottomBar;

- (void) hideTabBar;
- (void) showTabBar;

- (void) authNeeded;
- (void) authDone;

@end
