//
//  UserAccount.h
//  DomophoneApp
//
//  Created by George Prokopenko on 20.04.2018.
//  Copyright © 2018 George Prokopenko. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SipAccount.h"
#import <Realm/Realm.h>

@interface UserAccount : RLMObject

@property NSString* accountID;
@property NSString* apartmentID;
@property NSString* accountNumber;
@property NSString* firstName;
@property NSString* middleName;
@property NSString* lastName;
@property NSString* phone;
@property NSString* email;
@property NSString* authToken;
@property (nonatomic) SipAccount* sipAccount;

@end
