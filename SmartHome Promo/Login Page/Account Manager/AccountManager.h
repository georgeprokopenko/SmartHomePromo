//
//  AccountManager.h
//  DomophoneApp
//
//  Created by George Prokopenko on 19.04.2018.
//  Copyright © 2018 George Prokopenko. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserAccount.h"
@interface AccountManager : NSObject

+ (instancetype) shared;

@property (retain, nonatomic) UserAccount* userAccount;
@property (assign, nonatomic) BOOL shouldCheckIfDeviceIsRegistered;

+ (void) signInWithLogin:(NSString*)login password:(NSString*)password;
+ (void) registerDevice;
+ (void) logout;

@end
