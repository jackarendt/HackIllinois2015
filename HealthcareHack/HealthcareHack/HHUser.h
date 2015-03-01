//
//  HHUser.h
//  HealthcareHack
//
//  Created by Jack Arendt on 2/28/15.
//  Copyright (c) 2015 John Arendt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <HealthKit/HealthKit.h>
#import <CoreLocation/CoreLocation.h>

@interface HHUser : NSObject <CLLocationManagerDelegate>

+(void)sharedUser:(void(^)(NSString *err, BOOL success, HHUser *user))completionHandler;
-(NSString *)getFormattedHeight;
-(NSString *)getFormattedGender;
-(void)startUpdatingUserLocation;
-(void)get:(void(^)(NSError *err, NSArray *jsonArray))completionHandler;
-(void)put:(NSDictionary *)payloadDictionary completionHandler:(void(^)(NSError *err, NSDictionary *response))completionHandler;

@property (nonatomic, strong) NSDate *dob;
@property (nonatomic) NSInteger age;
@property (nonatomic, strong) HKBiologicalSexObject *gender;
@property (nonatomic, strong) NSNumber *height;
@property (nonatomic, strong) NSNumber *weight;
@property (nonatomic, strong) CLLocation *location;
@property (nonatomic, strong) NSString *doctorRecommendation;
@property (nonatomic, strong) NSString *doctorDescription;
@property (nonatomic, strong) NSArray *doctorTips;
@end
