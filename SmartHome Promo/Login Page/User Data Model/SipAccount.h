//
//  SipAccount.h
//  DomophoneApp
//
//  Created by George Prokopenko on 06.05.2018.
//  Copyright © 2018 George Prokopenko. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
@import Realm;

@interface SipAccount : RLMObject

@property NSString* alias;
@property NSString* ex_user;
@property NSString* password;
@property NSString* proxy;
@property NSString* remoteRequestStatus;

@end
