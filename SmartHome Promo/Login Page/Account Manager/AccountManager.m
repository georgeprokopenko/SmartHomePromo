//
//  AccountManager.m
//  DomophoneApp
//
//  Created by George Prokopenko on 19.04.2018.
//  Copyright © 2018 George Prokopenko. All rights reserved.
//

#define VALUE_TO_STRING(value) ([value isKindOfClass:[NSString class]])? value : [NSString stringWithFormat:@"%@",value];
#define APPDelegate (AppDelegate*)[UIApplication sharedApplication].delegate
#define SetProcessTimeout [AccountManager shared].processTimoutTimer = [NSTimer scheduledTimerWithTimeInterval:processTimeout target:self selector:@selector(processTimedOut) userInfo:nil repeats:NO];
#define StopProcessTimeout [[AccountManager shared].processTimoutTimer invalidate]; [AccountManager shared].processTimoutTimer = nil;

#import "AccountManager.h"
#import "MainViewController.h"
#import "AppDelegate.h"
#import "Constants.h"
#import "ErrorHandler.h"
#import <AFNetworking/AFNetworking.h>

@interface AccountManager ()
@property NSTimer* processTimoutTimer;
@end

@implementation AccountManager

+ (instancetype) shared {
    static dispatch_once_t once;
    static id sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}


#pragma mark Networking

+ (void) signInWithLogin:(NSString*)login password:(NSString*)password {
    AFHTTPSessionManager* manager = [AFHTTPSessionManager manager];
    [manager.requestSerializer setValue:API_VERSION forHTTPHeaderField:@"API-VERSION"];
    
    NSDictionary* dict = @{@"account[phone]": login,
                           @"account[password]": password};
    SetProcessTimeout;
    [manager POST:[API_URL stringByAppendingString:SIGN_IN_REQUEST] parameters:dict progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        StopProcessTimeout;
        NSHTTPURLResponse* response = (NSHTTPURLResponse *)task.response;
        NSString* token = [response allHeaderFields][@"Authorization"];
        [self setUserAccount:responseObject[@"account"]];
        if (token) [self setAuthToken:token];
        [self checkIfDeviceAlredyRegistered:responseObject];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [ErrorHandler handleError:error];
    }];
}

+ (void) processTimedOut {
    [[NSNotificationCenter defaultCenter] postNotificationName:kProcessTimedOut object:nil];
}


#pragma mark Creating Account

+ (void) setUserAccount:(NSDictionary*)dictionary {
    RLMRealm* realm = [RLMRealm defaultRealm];
    [realm beginWriteTransaction];
    
    UserAccount* account = [[UserAccount alloc] init];
    account.accountID = VALUE_TO_STRING(dictionary[@"id"]);
    account.apartmentID = VALUE_TO_STRING(dictionary[@"apartment_id"]);
    account.accountNumber = VALUE_TO_STRING(dictionary[@"number"]);
    account.firstName = dictionary[@"first_name"];
    account.middleName = dictionary[@"middle_name"];
    account.lastName = dictionary[@"last_name"];
    account.phone = VALUE_TO_STRING(dictionary[@"phone"]);
    account.email = dictionary[@"email"];
    [AccountManager shared].userAccount = account;
    
    [realm addObject:account];
    [realm commitWriteTransaction];
}

+ (void) setAuthToken:(NSString*)token {
    RLMRealm* realm = [RLMRealm defaultRealm];
    [realm beginWriteTransaction];
    [AccountManager shared].userAccount.authToken = token;
    [realm commitWriteTransaction];
}

+ (void) setSipAccount:(NSDictionary*)dictionary {
    RLMRealm* realm = [RLMRealm defaultRealm];
    [realm beginWriteTransaction];
    
    SipAccount* sipAccount = [[SipAccount alloc] init];
    sipAccount.alias = VALUE_TO_STRING(dictionary[@"alias"]);
    sipAccount.ex_user = VALUE_TO_STRING(dictionary[@"ex_user"]);
    sipAccount.password = dictionary[@"password"];
    sipAccount.proxy = dictionary[@"proxy"];
    sipAccount.remoteRequestStatus = dictionary[@"remote_request_status"];
    [AccountManager shared].userAccount.sipAccount = sipAccount;
    
    [realm commitWriteTransaction];
    [[NSNotificationCenter defaultCenter] postNotificationName:kAuthDone object:nil];
}


#pragma mark Retreiving Objects

- (UserAccount*) userAccount {
    return [[UserAccount allObjects] firstObject];
}

+ (void) logout {
    RLMRealm* realm = [RLMRealm defaultRealm];
    [realm beginWriteTransaction];
    [realm deleteObject:[AccountManager shared].userAccount];
    [realm commitWriteTransaction];
    [[NSNotificationCenter defaultCenter] postNotificationName:kAuthNeeded object:nil];
}

+ (void) checkIfDeviceAlredyRegistered:(id)account {
    NSArray* devicesArray = (NSArray*)account[@"customer_devices"];
    if (!devicesArray || devicesArray.count == 0) [self registerDevice];
    else {
        NSMutableArray* UIDArray = [NSMutableArray array];
        for (NSDictionary* device in devicesArray) [UIDArray addObject:device[@"uid"]];
        
        if (![UIDArray containsObject:[Constants deviceUID]]) [self registerDevice];
        else {
            for (NSDictionary* device in devicesArray) if ([device[@"uid"] isEqualToString:[Constants deviceUID]])
                [self setSipAccount:device[@"sip_account"]];
        }
    }
}

+ (void) registerDevice {
    AFHTTPSessionManager* manager = [AFHTTPSessionManager manager];
    [manager.requestSerializer setValue:API_VERSION forHTTPHeaderField:@"API-VERSION"];
    NSString* token = [AccountManager shared].userAccount.authToken;
    [manager.requestSerializer setValue:token forHTTPHeaderField:@"Authorization"];
    
    NSDictionary* params = @{@"customer_device[model]" : [Constants deviceModel],
                             @"customer_device[kind]" : [Constants deviceKind],
                             @"customer_device[uid]" : [Constants deviceUID],
                             @"customer_device[os]" : @"ios"};
    [manager POST:[API_URL stringByAppendingString:REGISTER_DEVICE] parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self setSipAccount:responseObject[@"sip_account"]];
        return;
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [ErrorHandler handleError:error];
    }];
}


@end
