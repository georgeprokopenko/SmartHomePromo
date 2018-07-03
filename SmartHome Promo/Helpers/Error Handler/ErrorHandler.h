//
//  ErrorHandler.h
//  DomophoneApp
//
//  Created by George Prokopenko on 21.04.2018.
//  Copyright © 2018 George Prokopenko. All rights reserved.
//

#import <Foundation/Foundation.h>

//NETWORK RESPONSE ERROR HANDLER
@interface ErrorHandler : NSObject

+ (void) handleError:(NSError*)error;

@end
