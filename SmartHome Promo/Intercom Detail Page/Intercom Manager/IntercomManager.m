//
//  IntercomManager.m
//  DomophoneApp
//
//  Created by George Prokopenko on 23.04.2018.
//  Copyright © 2018 George Prokopenko. All rights reserved.
//

#import "IntercomManager.h"
#import "Constants.h"
#import "AccountManager.h"
#import "ErrorHandler.h"
#import <AFNetworking/AFNetworking.h>

@implementation IntercomManager

+ (void) openIntercom:(IntercomObject*)intercom completion:(void (^)(BOOL))completionBlock {
    AFHTTPSessionManager* manager = [AFHTTPSessionManager manager];
    [manager.requestSerializer setValue:API_VERSION forHTTPHeaderField:@"API-VERSION"];
    NSString* token = [AccountManager shared].userAccount.authToken;
    [manager.requestSerializer setValue:token forHTTPHeaderField:@"Authorization"];
    NSString* request = [NSString stringWithFormat:@"%@%@/%li/unlock",API_URL, MY_INTERCOMS, (long)intercom.intercomID];
    [manager POST:request parameters:nil progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (completionBlock && intercom.intercomID) completionBlock(YES);
        else completionBlock(NO);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [ErrorHandler handleError:error];
        if (completionBlock) completionBlock(NO);
    }];
}

@end
