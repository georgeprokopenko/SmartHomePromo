//
//  UserAccount.m
//  DomophoneApp
//
//  Created by George Prokopenko on 20.04.2018.
//  Copyright © 2018 George Prokopenko. All rights reserved.
//

#import "UserAccount.h"

@implementation UserAccount

- (SipAccount*) sipAccount {
    return [[SipAccount allObjects] firstObject];
}

@end
