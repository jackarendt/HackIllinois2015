//
//  DoctorManager.m
//  HealthcareHack
//
//  Created by Jack Arendt on 3/1/15.
//  Copyright (c) 2015 John Arendt. All rights reserved.
//

#import "DoctorManager.h"

@interface DoctorManager ()
@property (nonatomic, strong) NSMutableArray *doctors;
@end

@implementation DoctorManager

-(instancetype)initWithJSONFile:(NSDictionary *)dict {
    self = [super init];
    if(self) {
        self.doctors = [[NSMutableArray alloc] init];
        if(dict) {
            [self decodeJSON:dict];
        }
    }
    return self;
}

-(void)decodeJSON:(NSDictionary *)dict {
    NSArray *data = dict[@"data"];
    for(NSDictionary *doctor in data) {
        [self.doctors addObject:[[Doctor alloc] initWithDictionary:doctor]];
    }
}

-(Doctor *)getDoctorForIndex:(NSInteger)index {
    return self.doctors[index];
}

-(NSInteger)getNumberOfDoctors {
    return self.doctors.count;
}

@end
