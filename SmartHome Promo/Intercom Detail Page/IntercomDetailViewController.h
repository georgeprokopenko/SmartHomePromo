//
//  IntercomDetailViewController.h
//  DomophoneApp
//
//  Created by George Prokopenko on 18.04.2018.
//  Copyright © 2018 George Prokopenko. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IntercomObject.h"
#import "MainViewController.h"

@interface IntercomDetailViewController : UIViewController

@property (retain, nonatomic) MainViewController* mainViewController;
@property (retain, nonatomic) IntercomObject* selectedIntercom;

@end

