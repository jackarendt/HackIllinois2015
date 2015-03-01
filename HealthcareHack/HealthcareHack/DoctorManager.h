//
//  DoctorManager.h
//  HealthcareHack
//
//  Created by Jack Arendt on 3/1/15.
//  Copyright (c) 2015 John Arendt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Doctor.h"
#import "HHUtility.h"

@interface DoctorManager : NSObject

-(instancetype)initWithJSONFile:(NSDictionary *)dict;

-(Doctor *)getDoctorForIndex:(NSInteger)index;
-(NSInteger)getNumberOfDoctors;

@end
