//
//  MyIntercomsViewController.h
//  DomophoneApp
//
//  Created by George Prokopenko on 12.04.2018.
//  Copyright © 2018 George Prokopenko. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainViewController.h"
#import "AppDelegate.h"

@interface MyIntercomsViewController : UIViewController

@property (retain, nonatomic) MainViewController* mainViewController;
- (void) loadIntercoms;

- (void) openCallPageWith:(NSString*)name;

@end
