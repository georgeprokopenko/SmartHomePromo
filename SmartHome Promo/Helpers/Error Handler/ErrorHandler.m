//
//  ErrorHandler.m
//  DomophoneApp
//
//  Created by George Prokopenko on 21.04.2018.
//  Copyright © 2018 George Prokopenko. All rights reserved.
//

#import "ErrorHandler.h"
#import "Constants.h"
#import <AFNetworking/AFNetworking.h>
#import "Mapper.h"

@implementation ErrorHandler

+ (void) handleError:(NSError*)error {
    if (!error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey]) {[self checkConnection]; return;}
    NSDictionary* errorResponse = [NSJSONSerialization JSONObjectWithData:(NSData *)error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey]
                                                                options:kNilOptions
                                                                  error:&error];
    if ([errorResponse[@"code"] isEqualToString:@"authorization_header_missing"] ||
        [errorResponse[@"code"] isEqualToString:@"request_not_authenticated"]) [self authTokenExpired];
    if ([errorResponse[@"code"] isEqualToString:@"wrong_customer_account_credentials"]) [self wrongSignInCredentials];
    if (!errorResponse) [self wrongSignInCredentials];
    
    NSLog(@"errResponse %@",errorResponse);
}

+ (void) checkConnection {
    [Mapper showCustomAlertWithType:kCustomAlertTypeNoInternet];
}

+ (void) authTokenExpired {
    [[NSNotificationCenter defaultCenter] postNotificationName:kAuthNeeded object:nil];
}

+ (void) wrongSignInCredentials {
    [[NSNotificationCenter defaultCenter] postNotificationName:kWrongSignInCredentials object:nil];
}

@end
