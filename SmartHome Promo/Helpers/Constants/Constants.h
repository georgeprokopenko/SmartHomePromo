//
//  Constants.h
//  DomophoneApp
//
//  Created by George Prokopenko on 21.04.2018.
//  Copyright © 2018 George Prokopenko. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <sys/utsname.h>
#import "Categories.h"

typedef enum : NSUInteger {
    AppModeDebug,
    AppModeProduction,
    BackEndModeDebug,
    BackEndProduction,
} Modes;

@interface Constants : NSObject

extern Modes const APPMODE;
extern Modes const BACKENDMODE;

#pragma mark Alert CONSTANTS

extern NSString* const attention;
extern NSString* const noInternet;
extern NSString* const onlyFiveDoors;
extern NSString* const okButton;


#pragma mark API CONSTANTS

extern int const processTimeout;
extern NSString* const API_URL;
extern NSString* const API_VERSION;
extern NSString* const SIGN_IN_REQUEST;
extern NSString* const MY_INTERCOMS;
extern NSString* const REGISTER_DEVICE;

#pragma mark NOTIFICATIONS

extern NSString* const kProcessTimedOut;

extern NSString* const kAuthNeeded;
extern NSString* const kAuthDone;
extern NSString* const kWrongSignInCredentials;

extern NSString* const kIntercomsListLoaded;
extern NSString* const kNoIntercomsLoaded;

// v.1 ONLY
extern NSString* const kMainTabBarSelectIndexOne;
extern NSString* const kMainTabBarSelectIndexTwo;

// v.2 ONLY
extern NSString* const kRegisterLinphoneAccount;
extern NSString* const kLinphoneAccountRegistered;

extern NSString* const kDmpfLinphoneMakeCall;
extern NSString* const kDmpfLinphoneEndCall;

extern NSString* const kDmpfLinphoneSetupForVideo;

#pragma mark Device Identification

+ (NSString*) deviceUID;
+ (NSString*) deviceKind;
+ (NSString*) deviceModel;


@end
