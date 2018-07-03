//
//  Constants.m
//  DomophoneApp
//
//  Created by George Prokopenko on 21.04.2018.
//  Copyright © 2018 George Prokopenko. All rights reserved.
//

#import "Constants.h"

@implementation Constants

Modes const APPMODE = AppModeDebug;
Modes const BACKENDMODE = BackEndModeDebug;

#pragma mark Alert CONSTANTS

NSString* const attention = @"Внимание!";
NSString* const noInternet = @"Нет доступа к интернету";
NSString* const onlyFiveDoors = @"Вы можете закрепить не более 5-ти дверей";
NSString* const okButton = @"OK";

#pragma mark API CONSTANTS

int const processTimeout = 10;
NSString* const API_URL = (BACKENDMODE == BackEndModeDebug) ? @"https://debug.smarthome.ru/api/" : @"https://prod.smarthome.ru/api/";
NSString* const API_VERSION = @"1";
NSString* const SIGN_IN_REQUEST = @"customers/sign_in";
NSString* const MY_INTERCOMS = @"customers/intercoms";
NSString* const REGISTER_DEVICE = @"customers/devices";
NSString* const SEARCH_FOR_DEVICE = @"customers/devices/lookup";



#pragma mark NOTIFICATIONS

NSString* const kProcessTimedOut = @"kProcessTimedOut";

NSString* const kAuthNeeded = @"kAuthNeeded";
NSString* const kAuthDone = @"kAuthDone";
NSString* const kWrongSignInCredentials = @"kWrongSignInCredentials";

NSString* const kIntercomsListLoaded = @"kIntercomsListLoaded";
NSString* const kNoIntercomsLoaded = @"kNoIntercomsLoaded";

// v.1 ONLY
NSString* const kMainTabBarSelectIndexOne = @"kMainTabBarSelectIndexOne";
NSString* const kMainTabBarSelectIndexTwo = @"kMainTabBarSelectIndexTwo";


// v.2 ONLY
NSString* const kRegisterLinphoneAccount = @"kRegisterLinphoneAccount";
NSString* const kLinphoneAccountRegistered = @"kLinphoneAccountRegistered";


NSString* const kDmpfLinphoneMakeCall = @"kDmpfLinphoneMakeCall";
NSString* const kDmpfLinphoneEndCall = @"kDmpfLinphoneEndCall";

NSString* const kDmpfLinphoneSetupForVideo = @"kDmpfLinphoneSetupForVideo";


#pragma mark Device Identification

+ (NSString*) deviceUID {
    return [UIDevice currentDevice].identifierForVendor.UUIDString;
}

+ (NSString*) deviceKind {
    NSArray* modelString = [[Constants deviceModel] componentsSeparatedByString:@" "];
    NSString* deviceKind;
    if ([modelString[0] isEqualToString:@"iPad"]) deviceKind = @"tablet";
    else deviceKind = @"mobile";
    return deviceKind;
}


+ (NSString*) deviceModel {
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString* code = [NSString stringWithCString:systemInfo.machine
                                        encoding:NSUTF8StringEncoding];
    
    static NSDictionary* deviceNamesByCode = nil;
    if (!deviceNamesByCode)
        deviceNamesByCode = @{@"i386"      : @"Simulator",
                              @"x86_64"    : @"Simulator",
                              @"iPod1,1"   : @"iPod Touch",        // (Original)
                              @"iPod2,1"   : @"iPod Touch",        // (Second Generation)
                              @"iPod3,1"   : @"iPod Touch",        // (Third Generation)
                              @"iPod4,1"   : @"iPod Touch",        // (Fourth Generation)
                              @"iPod7,1"   : @"iPod Touch",        // (6th Generation)
                              @"iPhone1,1" : @"iPhone",            // (Original)
                              @"iPhone1,2" : @"iPhone",            // (3G)
                              @"iPhone2,1" : @"iPhone",            // (3GS)
                              @"iPad1,1"   : @"iPad",              // (Original)
                              @"iPad2,1"   : @"iPad 2",            //
                              @"iPad3,1"   : @"iPad",              // (3rd Generation)
                              @"iPhone3,1" : @"iPhone 4",          // (GSM)
                              @"iPhone3,3" : @"iPhone 4",          // (CDMA/Verizon/Sprint)
                              @"iPhone4,1" : @"iPhone 4S",         //
                              @"iPhone5,1" : @"iPhone 5",          // (model A1428, AT&T/Canada)
                              @"iPhone5,2" : @"iPhone 5",          // (model A1429, everything else)
                              @"iPad3,4"   : @"iPad",              // (4th Generation)
                              @"iPad2,5"   : @"iPad Mini",         // (Original)
                              @"iPhone5,3" : @"iPhone 5c",         // (model A1456, A1532 | GSM)
                              @"iPhone5,4" : @"iPhone 5c",         // (model A1507, A1516, A1526 (China), A1529 | Global)
                              @"iPhone6,1" : @"iPhone 5s",         // (model A1433, A1533 | GSM)
                              @"iPhone6,2" : @"iPhone 5s",         // (model A1457, A1518, A1528 (China), A1530 | Global)
                              @"iPhone7,1" : @"iPhone 6 Plus",     //
                              @"iPhone7,2" : @"iPhone 6",          //
                              @"iPhone8,1" : @"iPhone 6S",         //
                              @"iPhone8,2" : @"iPhone 6S Plus",    //
                              @"iPhone8,4" : @"iPhone SE",         //
                              @"iPhone9,1" : @"iPhone 7",          //
                              @"iPhone9,3" : @"iPhone 7",          //
                              @"iPhone9,2" : @"iPhone 7 Plus",     //
                              @"iPhone9,4" : @"iPhone 7 Plus",     //
                              @"iPhone10,1": @"iPhone 8",          // CDMA
                              @"iPhone10,4": @"iPhone 8",          // GSM
                              @"iPhone10,2": @"iPhone 8 Plus",     // CDMA
                              @"iPhone10,5": @"iPhone 8 Plus",     // GSM
                              @"iPhone10,3": @"iPhone X",          // CDMA
                              @"iPhone10,6": @"iPhone X",          // GSM
                              
                              @"iPad4,1"   : @"iPad Air",          // 5th Generation iPad (iPad Air) - Wifi
                              @"iPad4,2"   : @"iPad Air",          // 5th Generation iPad (iPad Air) - Cellular
                              @"iPad4,4"   : @"iPad Mini",         // (2nd Generation iPad Mini - Wifi)
                              @"iPad4,5"   : @"iPad Mini",         // (2nd Generation iPad Mini - Cellular)
                              @"iPad4,7"   : @"iPad Mini",         // (3rd Generation iPad Mini - Wifi (model A1599))
                              @"iPad6,7"   : @"iPad Pro (12.9\")", // iPad Pro 12.9 inches - (model A1584)
                              @"iPad6,8"   : @"iPad Pro (12.9\")", // iPad Pro 12.9 inches - (model A1652)
                              @"iPad6,3"   : @"iPad Pro (9.7\")",  // iPad Pro 9.7 inches - (model A1673)
                              @"iPad6,4"   : @"iPad Pro (9.7\")"   // iPad Pro 9.7 inches - (models A1674 and A1675)
                              };
    
    NSString* deviceName = [deviceNamesByCode objectForKey:code];
    
    if (!deviceName) {
        if ([code rangeOfString:@"iPod"].location != NSNotFound) deviceName = @"iPod Touch";
        else if([code rangeOfString:@"iPad"].location != NSNotFound) deviceName = @"iPad";
        else if([code rangeOfString:@"iPhone"].location != NSNotFound) deviceName = @"iPhone";
        else  deviceName = @"Unknown";
    }
    
    return deviceName;
}



@end
