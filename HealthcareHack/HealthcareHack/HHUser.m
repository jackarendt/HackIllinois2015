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
@property (nonatomic, strong) CLLocationManager *manager;
@end

@implementation HHUser

+(void)sharedUser:(void (^)(NSString *, BOOL, HHUser *))completionHandler {
    static HHUser *sharedUser = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedUser = [[self alloc] init];
        sharedUser.manager = [[CLLocationManager alloc] init];
        [sharedUser authorizeHealthKit:^(NSString *err, BOOL success){
            if(success) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [sharedUser getDateOfBirth];
                    [sharedUser getGender];
                    [sharedUser getUserHeight:^{
                        [sharedUser getUserWeight:^{
                            completionHandler(err, success, sharedUser);
                        }];
                    }];
                });
            }
        }];
    });
    completionHandler(nil, YES, sharedUser);
}

#pragma mark - Health Kit Methods

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

-(NSString *)getFormattedGender {
    switch (self.gender.biologicalSex) {
        case HKBiologicalSexFemale:
            return @"Female";
            break;
        case HKBiologicalSexMale:
            return @"Male";
        case HKBiologicalSexNotSet:
            return @"Not Set";
        default:
            return nil;
            break;
    }
}

#pragma mark - CL Delegate methods

-(void)startUpdatingUserLocation {
    self.manager.delegate = self;
    [self.manager requestWhenInUseAuthorization];
    [self.manager startUpdatingLocation];
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    self.location = [locations lastObject];
}

-(void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    if(status == kCLAuthorizationStatusAuthorizedWhenInUse) {
        [self.manager startUpdatingLocation];
    }
}

-(void)get:(void (^)(NSError *, NSArray *))completionHandler{
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"https://healthhoodlums.azure-mobile.net/api/IMOFactual"]];
    [[session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *err) {
        if(err) {
            completionHandler(err, nil);
        }
        NSError *error;
        NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
        if(error) {
            completionHandler(error, nil);
        }
        
        else {
            completionHandler(nil, jsonArray);
        }
    }] resume];
    
}

-(void)put:(NSDictionary *)payloadDictionary completionHandler:(void (^)(NSError *, NSDictionary *))completionHandler{
    NSError *error;
//    NSString *jsonString = @"hello";
//    NSData *newData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
//    NSLog(@"%@", jsonString);
    NSData *data = [NSJSONSerialization dataWithJSONObject:payloadDictionary options:NSJSONWritingPrettyPrinted error:&error];
    NSLog(@"%@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
    if(error) {
        completionHandler(error, nil);
        return;
    }
    
//    NSLog(@"%@", [[NSString alloc] initWithData:newData encoding:NSUTF8StringEncoding]);
    
    //NSDictionary *arr = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];

    
    NSURLSession *session = [NSURLSession sharedSession];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"https://healthhoodlums.azure-mobile.net/api/IMOFactual"]];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:data];
    [request setValue:@"application/text-plain" forHTTPHeaderField:@"content-type"];
    
    [[session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *err) {
        NSError *error;
        NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
        completionHandler(err, jsonDict);
    }] resume];
}





@end
