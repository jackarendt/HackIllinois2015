//
//  Doctor.h
//  HealthcareHack
//
//  Created by Jack Arendt on 3/1/15.
//  Copyright (c) 2015 John Arendt. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Doctor : NSObject

-(instancetype)initWithDictionary:(NSDictionary *)dict;

@property (nonatomic, strong) NSString *address;
@property (nonatomic, strong) NSString *city;
@property (nonatomic, strong) NSString *country;
@property (nonatomic, strong) NSNumber *distance;
@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *state;
@property (nonatomic, strong) NSString *telephone;
@property (nonatomic, strong) NSString *website;
@property (nonatomic, strong) NSString *zipCode;

@end
