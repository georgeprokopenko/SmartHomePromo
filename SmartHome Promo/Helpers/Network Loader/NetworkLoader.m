//
//  NetworkLoader.m
//  DomophoneApp
//
//  Created by George Prokopenko on 19.04.2018.
//  Copyright © 2018 George Prokopenko. All rights reserved.
//

#import "NetworkLoader.h"
#import "AccountManager.h"
#import "MyIntercomsViewController.h"
#import "ErrorHandler.h"
#import "Constants.h"
#import "IntercomObject.h"
#import "ActivitySpinner.h"
#import <AFNetworking/AFNetworking.h>

@implementation NetworkLoader

+ (instancetype) shared {
    static dispatch_once_t once;
    static id sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

+ (NSArray*) allIntercomsInLocal {
    RLMResults* results = [IntercomObject allObjects];
    NSMutableArray* array = [NSMutableArray array];
    for (id obj in results) [array addObject:obj];
    return array;
}

+ (void) loadIntercomsListWithCompletion:(void (^)(NSMutableArray* intercomsList, NSError* error))completionBlock {
    AFHTTPSessionManager* manager = [AFHTTPSessionManager manager];
    [manager.requestSerializer setValue:API_VERSION forHTTPHeaderField:@"API-VERSION"];
    NSString* token = [AccountManager shared].userAccount.authToken;
    [manager.requestSerializer setValue:token forHTTPHeaderField:@"Authorization"];
    
    [manager GET:[API_URL stringByAppendingString:MY_INTERCOMS] parameters:nil progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSMutableArray* allIntercoms;
        allIntercoms = [NSMutableArray array];
        for (NSDictionary* dataDict in responseObject) {
            [allIntercoms addObject:[self createAndSaveIntercom:dataDict]];
        }
        
        if (completionBlock) completionBlock(allIntercoms, nil);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (completionBlock) completionBlock(nil, error);
    }];
}

+ (IntercomObject*) createAndSaveIntercom:(NSDictionary*)dataDict {
    RLMRealm* realm = [RLMRealm defaultRealm];
    [realm beginWriteTransaction];
    IntercomObject* intercom = [[IntercomObject alloc] initWithData:dataDict];
    [realm commitWriteTransaction];
    return intercom;
}

@end
