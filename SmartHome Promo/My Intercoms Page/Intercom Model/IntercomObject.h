//
//  IntercomObject.h
//  DomophoneApp
//
//  Created by George Prokopenko on 23.04.2018.
//  Copyright © 2018 George Prokopenko. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Realm/Realm.h>

@interface IntercomObject : RLMObject

@property NSInteger intercomID;
@property NSString* name;
@property NSString* humanName;
@property NSInteger buildingID;
@property NSString* kind;
@property NSInteger entrance;
@property NSString* ipAddress;
@property NSInteger schemeID;
@property NSString* sipNumber;
@property BOOL isFavorite;


- (instancetype) initWithData:(NSDictionary*)data;

@end
