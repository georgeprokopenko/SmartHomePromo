//
//  NetworkLoader.h
//  DomophoneApp
//
//  Created by George Prokopenko on 19.04.2018.
//  Copyright © 2018 George Prokopenko. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NetworkLoader : NSObject

+ (instancetype) shared;
+ (NSArray*) allIntercomsInLocal;
+ (void) loadIntercomsListWithCompletion:(void (^)(NSMutableArray* intercomsList, NSError* error))completionBlock;

@end
