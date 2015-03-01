//
//  Doctor.m
//  HealthcareHack
//
//  Created by Jack Arendt on 3/1/15.
//  Copyright (c) 2015 John Arendt. All rights reserved.
//

#import "Doctor.h"
#import "HHUtility.h"

@implementation Doctor

-(instancetype)initWithDictionary:(NSDictionary *)dict {
    self = [super init];
    if(self) {
        self.address = dict[kFactualAddress];
        self.city = dict[kFactualCity];
        self.country = dict[kFactualCountry];
        self.distance = dict[kFactualDistance];
        self.email = dict[kFactualEmail];
        self.name = dict[kFactualName];
        self.state = dict[kFactualState];
        self.telephone = dict[kFactualTelephone];
        self.website = dict[kFactualWebsite];
        self.zipCode = dict[kFactualZipcode];
    }
    return self;
}

@end
