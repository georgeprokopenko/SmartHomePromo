//
//  IntercomObject.m
//  DomophoneApp
//
//  Created by George Prokopenko on 23.04.2018.
//  Copyright © 2018 George Prokopenko. All rights reserved.
//

#define NULL_TO_ZERO(object) (object == [NSNull null])? 0 : [object integerValue]

#import "IntercomObject.h"

@implementation IntercomObject

- (instancetype) initWithData:(NSDictionary*)data {
    self = [[IntercomObject alloc] init];
    self.intercomID = NULL_TO_ZERO(data[@"id"]);
    self.name = data[@"name"];
    self.humanName = data[@"human_name"];
    self.entrance = NULL_TO_ZERO(data[@"entrance"]);
    self.buildingID = NULL_TO_ZERO(data[@"building_id"]);
    self.ipAddress = data[@"ip_address"];
    self.kind = data[@"kind"];
    self.schemeID = NULL_TO_ZERO(data[@"scheme_id"]);
    NSDictionary* sipData = data[@"sip_account"];
    self.isFavorite = NO;
    if (![sipData isKindOfClass:[NSNull class]]) {
        NSString* sipNum = [NSString stringWithFormat:@"%@", sipData[@"ex_user"]];
        self.sipNumber = sipNum;
    }
    
    return self;
}

@end
