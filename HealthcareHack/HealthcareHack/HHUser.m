//
//  TTUser.m
//  HealthcareHack
//
//  Created by Jack Arendt on 2/28/15.
//  Copyright (c) 2015 John Arendt. All rights reserved.
//

#import "HHUser.h"

@interface HHUser () {
    HKHealthStore *healthKitStore;
}
@property (nonatomic) BOOL loaded;
@end

@implementation HHUser

+(void)sharedUser:(void (^)(NSString *, BOOL, HHUser *))completionHandler {
    static HHUser *sharedUser = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedUser = [[self alloc] init];
        [sharedUser authorizeHealthKit:^(NSString *err, BOOL success){
            if(success) {
                // Update the user interface based on the current user's health information.
                dispatch_async(dispatch_get_main_queue(), ^{
                    [sharedUser getDateOfBirth];
                    [sharedUser getGender];
                    [sharedUser getUserHeight:^{
                        [sharedUser getUserWeight:^{
                            NSLog(@"%@, %@", sharedUser.height, sharedUser.weight);
                            completionHandler(err, success, sharedUser);
                        }];
                    }];
                });
            }
        }];
    });
}

-(void)authorizeHealthKit:(void(^)(NSString *err, BOOL success))completionHandler {
    healthKitStore = [[HKHealthStore alloc] init];
    NSMutableSet *typesToRead = [[NSMutableSet alloc] init];
    [typesToRead addObject:[HKObjectType characteristicTypeForIdentifier:HKCharacteristicTypeIdentifierBiologicalSex]];
    [typesToRead addObject:[HKObjectType characteristicTypeForIdentifier:HKCharacteristicTypeIdentifierDateOfBirth]];
    [typesToRead addObject:[HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierHeight]];
    [typesToRead addObject:[HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierBodyMass]];
    
    if(![HKHealthStore isHealthDataAvailable]) {
        NSString *err = @"HealthKit not available on this device";
        if(completionHandler != nil) {
            completionHandler(err, NO);
        }
    }
    
    [healthKitStore requestAuthorizationToShareTypes:nil readTypes:typesToRead completion:^(BOOL success, NSError *err) {
        if (completionHandler != nil) {
            completionHandler(err.description, success);
        }
    }];
}

-(void)getDateOfBirth {
    NSError *error;
    self.dob= [healthKitStore dateOfBirthWithError:&error];
    if(!self.dob) {
        return;
    }
    
    NSDate *now = [NSDate date];
    
    NSDateComponents *ageComponents = [[NSCalendar currentCalendar] components:NSCalendarUnitYear fromDate:self.dob toDate:now options:NSCalendarWrapComponents];
    self.age = [ageComponents year];
}

-(void)getGender {
    NSError *error;
    self.gender = [healthKitStore biologicalSexWithError:&error];
}

-(void)getUserHeight:(void(^)())completionHandler{
    HKSampleType *sampleType = [HKSampleType quantityTypeForIdentifier:HKQuantityTypeIdentifierHeight];
    [self readMostRecentSample:sampleType completion:^(HKSample *sample, NSError *err) {
        if(err) {
            NSLog(@"ERROR READING HEIGHT");
            return;
        }
        
        HKQuantitySample *h = (HKQuantitySample *)sample;
        HKQuantity *hQuantity= h.quantity;
        HKUnit *inchUnit = [HKUnit inchUnit];
        double usersHeight = [hQuantity doubleValueForUnit:inchUnit];
        self.height = [NSNumber numberWithDouble:usersHeight];
        completionHandler();
    }];

}

-(void)getUserWeight:(void(^)())completionHandler {
    HKSampleType *sampleType = [HKSampleType quantityTypeForIdentifier:HKQuantityTypeIdentifierBodyMass];
    [self readMostRecentSample:sampleType completion:^(HKSample *sample, NSError *err) {
        if(err) {
            NSLog(@"ERROR READING WEIGHT");
            return;
        }
        
        HKQuantitySample *w = (HKQuantitySample *)sample;
        HKQuantity *wQuantity= w.quantity;
        HKUnit *poundUnit = [HKUnit poundUnit];
        double usersWeight = [wQuantity doubleValueForUnit:poundUnit];
        self.weight = [NSNumber numberWithDouble:usersWeight];
        completionHandler();
    }];
}

-(void)readMostRecentSample:(HKSampleType *)sampleType completion:(void(^)(HKSample *sample, NSError *err))completionHandler{
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:HKSampleSortIdentifierStartDate ascending:NO];
    int limit = 1;
    
    HKSampleQuery *sampleQuery = [[HKSampleQuery alloc] initWithSampleType:sampleType predicate:nil limit:limit sortDescriptors:@[sortDescriptor] resultsHandler:^(HKSampleQuery *query, NSArray *results, NSError *error){
        if(error) {
            if(completionHandler){
                completionHandler(nil, error);
            }
            return;
        }
        
        HKQuantitySample *firstSample = [results firstObject];
        if(completionHandler) {
            completionHandler(firstSample, nil);
        }
    }];
    [healthKitStore executeQuery:sampleQuery];
}


-(NSString *)getFormattedHeight {
    return [NSString stringWithFormat:@"%i\'%i\"", self.height.intValue/12, self.height.intValue %12];
}




@end