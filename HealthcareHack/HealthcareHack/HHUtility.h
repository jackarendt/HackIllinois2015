//
//  HHUtility.h
//  HealthcareHack
//
//  Created by Jack Arendt on 2/28/15.
//  Copyright (c) 2015 John Arendt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface HHUtility : NSObject

+ (UIColor *)getBlueColor;
+ (UIColor *)getDarkBlueColor;
+ (UIColor *)getDarkGreenColor;
+ (UIColor *)getGreenColor;
+ (UIColor *)getLightGreenColor;
+ (UIColor *)getRedColor;

+ (UIView *)getGradientForHeight:(CGFloat)height width:(CGFloat)width;

+ (NSString *)getCodeForAnatomy:(NSString *)anatomy symptom:(NSString *)symptom duration:(NSString *)duration severity:(NSString *)severity;

+ (NSInteger)getMetersFromString:(NSString *)distance;

+ (NSDictionary *)getAnatomyDictionary;
+ (NSDictionary *)getMiscDictionary;
+ (NSDictionary *) getDurationDictionary;
+ (NSDictionary *)getSeverityDictionary;


#pragma mark - String Constants

extern NSString *const kFontName;
extern NSString *const kSymptomLocation;
extern NSString *const kSymptomType;
extern NSString *const kSymptomDuration;
extern NSString *const kSymptomIntensity;

extern NSString *const kAnatomyGeneral;
extern NSString *const kAnatomyForehead;
extern NSString *const kAnatomySkull;
extern NSString *const kAnatomyEye;
extern NSString *const kAnatomyEar;
extern NSString *const kAnatomyNose;
extern NSString *const kAnatomyMouth;
extern NSString *const kAnatomyThroat;
extern NSString *const kAnatomyNeck;
extern NSString *const kAnatomyChest;
extern NSString *const kAnatomyStomach;
extern NSString *const kAnatomyUpperBack;
extern NSString *const kAnatomyLowerBack;
extern NSString *const kAnatomyPelvis;
extern NSString *const kAnatomyGenitals;
extern NSString *const kAnatomyButt;
extern NSString *const kAnatomyBowel;
extern NSString *const kAnatomyShoulder;
extern NSString *const kAnatomyUpperArm;
extern NSString *const kAnatomyLowerArm;
extern NSString *const kAnatomyElbow;
extern NSString *const kAnatomyHand;
extern NSString *const kAnatomyWrist;
extern NSString *const kAnatomyFinger;
extern NSString *const kAnatomyUpperLeg;
extern NSString *const kAnatomyLowerLeg;
extern NSString *const kAnatomyKnee;
extern NSString *const kAnatomyAnkle;
extern NSString *const kAnatomyFoot;
extern NSString *const kAnatomyToe;

extern NSString *const kDurationCoupleOfMinutes;
extern NSString *const kDurationOneHour;
extern NSString *const kDurationMultipleHours;
extern NSString *const kDurationOneDay;
extern NSString *const kDurationMultipleDays;
extern NSString *const kDurationOneWeek;
extern NSString *const kDurationMultipleWeeks;
extern NSString *const kDurationMonths;
extern NSString *const kDurationOneYear;
extern NSString *const kDurationMultipleYears;

extern NSString *const kSeverityMild;
extern NSString *const kSeverityMinor;
extern NSString *const kSeverityMedium;
extern NSString *const kSeverityMajor;
extern NSString *const kSeverityExtreme;

extern NSString *const kMiscFever;
extern NSString *const kMiscSweats;
extern NSString *const kMiscChills;
extern NSString *const kMiscDizziness;
extern NSString *const kMiscVisionLoss;
extern NSString *const kMiscNausea;

extern NSString *const kSymptomBurn;
extern NSString *const kSymptomBleeding;
extern NSString *const kSymptomSpasms;
extern NSString *const kSymptomNumbness;
extern NSString *const kSymptomRashItch;
extern NSString *const kSymptomSwelling;
extern NSString *const kSymptomDislocation;
extern NSString *const kSymptomBreak;
extern NSString *const kSymptomPain;
extern NSString *const kSymptomOther;

extern NSString *const kDoctorGeneralPracticioner;
extern NSString *const kDoctorHospital;
extern NSString *const kDoctorImmediateCare;
extern NSString *const kDoctorOptometrist;
extern NSString *const kDoctorDentist;
extern NSString *const kDoctorDermatologist;
extern NSString *const kDoctorPediatrician;
extern NSString *const kDoctorCardiologist;
extern NSString *const kDoctorNeurologist;
extern NSString *const kDoctorGynecologist;
extern NSString *const kDoctorPsychologist;
extern NSString *const kDoctorUrologist;
extern NSString *const kDoctorPodiatrist;
extern NSString *const kDoctorAnesthesiologist;
extern NSString *const kDoctorRadiologist;
extern NSString *const kDoctorSelfCare;
extern NSString *const kDoctorENT;

extern NSString *const kDistance5Miles;
extern NSString *const kDistance10Miles;
extern NSString *const kDistance25Miles;
extern NSString *const kDistance50Miles;
extern NSString *const kDistance100Miles;

extern NSString *const kLocationMe;

extern NSString *const kFactualAddress;
extern NSString *const kFactualCity;
extern NSString *const kFactualCountry;
extern NSString *const kFactualDistance;
extern NSString *const kFactualEmail;
extern NSString *const kFactualName;
extern NSString *const kFactualState;
extern NSString *const kFactualTelephone;
extern NSString *const kFactualWebsite;
extern NSString *const kFactualZipcode;




@end
