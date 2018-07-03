//
//  ActivitySpinner.h
//  DomophoneApp
//
//  Created by George Prokopenko on 20.05.2018.
//  Copyright © 2018 George Prokopenko. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>

@interface ActivitySpinner : NSObject
+ (void) show;
+ (void) showInView:(UIView*)view;
+ (void) showWithTimout:(int)timeout completionHandler:(void (^)(BOOL completed))block;
+ (void) showWithDuration:(int)seconds;
+ (void) dismiss;
@end
