//
//  IntercomManager.h
//  DomophoneApp
//
//  Created by George Prokopenko on 23.04.2018.
//  Copyright © 2018 George Prokopenko. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IntercomObject.h"

@interface IntercomManager : NSObject

+ (void) openIntercom:(IntercomObject*)intercom completion:(void (^)(BOOL success))completionBlock;



@end
