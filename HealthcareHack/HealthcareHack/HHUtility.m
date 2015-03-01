//
//  HHUtility.m
//  HealthcareHack
//
//  Created by Jack Arendt on 2/28/15.
//  Copyright (c) 2015 John Arendt. All rights reserved.
//

#import "HHUtility.h"

@implementation HHUtility

#pragma mark - Color Getters
+ (UIColor *)getBlueColor { //22, 147, 204
    return [UIColor colorWithRed:0.086 green:0.5764 blue:0.8 alpha:1];
}

+(UIColor *)getDarkBlueColor {
    return [UIColor colorWithRed:0.2039 green:0.286 blue:0.368 alpha:1];
}

+ (UIColor *)getDarkGreenColor {
    return [UIColor colorWithRed:0.004 green:0.5 blue:0.3843 alpha:1];
}

+(UIColor *)getGreenColor {
    return [UIColor colorWithRed:0.004 green:0.6 blue:0.4588 alpha:1]; //1, 153, 117
}

+ (UIColor *)getLightGreenColor {
    return [UIColor colorWithRed:0.004 green:0.898 blue:0.694 alpha:1];
}

+ (UIColor *)getRedColor {
    return [UIColor colorWithRed:0.8117 green:0 blue:0.0588 alpha:1];
}

+ (UIColor *)getGrayColor {
    CGFloat scale = 0.7;
    return [UIColor colorWithRed:scale green:scale blue:scale alpha:1];
}

+ (UIView *)getGradientForHeight:(CGFloat)height width:(CGFloat)width {
    UIView* view = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, width, height)];
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = view.bounds;
    gradient.colors = [NSArray arrayWithObjects:(id)[[self getDarkGreenColor] CGColor], (id)[[self getLightGreenColor] CGColor], nil];
    [view.layer insertSublayer:gradient atIndex:0];
    return view;
}

+ (NSInteger)getMetersFromString:(NSString *)distance {
    if([distance isEqualToString:kDistance5Miles]) {
        return 8045;
    }
    if([distance isEqualToString:kDistance10Miles]) {
        return 16090;
    }
    
    if([distance isEqualToString:kDistance25Miles]) {
        return 20000; //demo only, max range of API
    }
    
    if([distance isEqualToString:kDistance50Miles]) {
        return 20000; //demo only, max range of API
    }
    
    if([distance isEqualToString:kDistance100Miles]) {
        return 20000; //demo only, max range of API
    }
    
    return 0;
}

+ (NSString *)getCodeForAnatomy:(NSString *)anatomy symptom:(NSString *)symptom duration:(NSString *)duration severity:(NSString *)severity {
    NSMutableString *code = [[NSMutableString alloc] init];
    
    NSDictionary *a = [self getAnatomyDictionary];
    NSDictionary *s = [self getSeverityDictionary];
    NSDictionary *d = [self getDurationDictionary];
    NSDictionary *m = [self getMiscDictionary];
    NSDictionary *sy = [self getSymptomDictionary];
    
    if(!sy[symptom]) { //if in misc
        [code insertString:m[symptom] atIndex:0];
        [code insertString:sy[kSymptomOther] atIndex:2];
    }
    else {
        [code insertString:a[anatomy] atIndex:0];
        [code insertString:sy[symptom] atIndex:2];
    }
    
    [code insertString:d[duration] atIndex:3];
    [code insertString:s[severity] atIndex:4];
    return code;
}

+ (NSDictionary *)getAnatomyDictionary {
    NSDictionary *anatomy = @{
                              kAnatomyForehead  : @"10",
                              kAnatomySkull     : @"11",
                              kAnatomyEye       : @"12",
                              kAnatomyEar       : @"13",
                              kAnatomyNose      : @"14",
                              kAnatomyMouth     : @"15",
                              kAnatomyThroat    : @"16",
                              kAnatomyNeck      : @"17",
                              kAnatomyChest     : @"20",
                              kAnatomyStomach   : @"21",
                              kAnatomyUpperBack : @"22",
                              kAnatomyLowerBack : @"23",
                              kAnatomyPelvis    : @"24",
                              kAnatomyGenitals  : @"25",
                              kAnatomyButt      : @"26",
                              kAnatomyBowel     : @"27",
                              kAnatomyShoulder  : @"30",
                              kAnatomyUpperArm  : @"31",
                              kAnatomyElbow     : @"32",
                              kAnatomyLowerArm  : @"33",
                              kAnatomyWrist     : @"34",
                              kAnatomyHand      : @"35",
                              kAnatomyFinger    : @"36",
                              kAnatomyUpperLeg  : @"40",
                              kAnatomyKnee      : @"41",
                              kAnatomyLowerLeg  : @"42",
                              kAnatomyAnkle     : @"43",
                              kAnatomyFoot      : @"44",
                              kAnatomyToe       : @"45"
                              };
    return anatomy;
}

+ (NSDictionary *)getMiscDictionary {
    NSDictionary *misc = @{
                           kMiscFever       : @"00",
                           kMiscSweats      : @"01",
                           kMiscChills      : @"02",
                           kMiscDizziness   : @"03",
                           kMiscVisionLoss  : @"04",
                           kMiscNausea      : @"05"
                           };
    return misc;
}

+ (NSDictionary *) getDurationDictionary {
    NSDictionary *duration = @{
                               kDurationCoupleOfMinutes : @"0",
                               kDurationOneHour         : @"1",
                               kDurationMultipleHours   : @"2",
                               kDurationOneDay          : @"3",
                               kDurationMultipleDays    : @"4",
                               kDurationOneWeek         : @"5",
                               kDurationMultipleWeeks   : @"6",
                               kDurationMonths          : @"7",
                               kDurationOneYear         : @"8",
                               kDurationMultipleYears   : @"9"
                               };
    return duration;
}

+ (NSDictionary *)getSeverityDictionary {
    NSDictionary *severity = @{
                               kSeverityMild    : @"0",
                               kSeverityMinor   : @"1",
                               kSeverityMedium  : @"2",
                               kSeverityMajor   : @"3",
                               kSeverityExtreme : @"4"
                               };
    return severity;
}

+ (NSDictionary *)getSymptomDictionary {
    NSDictionary *symptom = @{
                              kSymptomBurn          : @"0",
                              kSymptomBleeding      : @"1",
                              kSymptomSpasms        : @"2",
                              kSymptomNumbness      : @"3",
                              kSymptomRashItch      : @"4",
                              kSymptomSwelling      : @"5",
                              kSymptomDislocation   : @"6",
                              kSymptomBreak         : @"7",
                              kSymptomPain          : @"8",
                              kSymptomOther         : @"9"
                              };
    return symptom;
}


NSString *const kFontName = @"Bebas";
NSString *const kSymptomLocation = @"kSymptomLocation";
NSString *const kSymptomType = @"kSymptomType";
NSString *const kSymptomDuration = @"kSymptomDuration";
NSString *const kSymptomIntensity = @"kSymptomIntensity";


NSString *const kAnatomyGeneral = @"General";
NSString *const kAnatomyForehead = @"Forehead";
NSString *const kAnatomySkull = @"Skull";
NSString *const kAnatomyEye = @"Eye";
NSString *const kAnatomyEar = @"Ear";
NSString *const kAnatomyNose = @"Nose";
NSString *const kAnatomyMouth = @"Mouth";
NSString *const kAnatomyThroat = @"Throat";
NSString *const kAnatomyNeck = @"Neck";
NSString *const kAnatomyChest = @"Chest";
NSString *const kAnatomyStomach = @"Stomach";
NSString *const kAnatomyUpperBack = @"Upper   Back";
NSString *const kAnatomyLowerBack = @"Lower   Back";
NSString *const kAnatomyPelvis = @"Pelvis";
NSString *const kAnatomyGenitals = @"Genitals";
NSString *const kAnatomyButt = @"Butt";
NSString *const kAnatomyBowel = @"Bowel";
NSString *const kAnatomyShoulder = @"Shoulder";
NSString *const kAnatomyUpperArm = @"Upper   Arm";
NSString *const kAnatomyLowerArm = @"Lower   Arm";
NSString *const kAnatomyElbow = @"Elbow";
NSString *const kAnatomyHand = @"Hand";
NSString *const kAnatomyWrist = @"Wrist";
NSString *const kAnatomyFinger = @"Finger";
NSString *const kAnatomyUpperLeg = @"Upper   Leg";
NSString *const kAnatomyLowerLeg = @"Lower   Leg";
NSString *const kAnatomyKnee = @"Knee";
NSString *const kAnatomyAnkle =  @"Ankle";
NSString *const kAnatomyFoot = @"Foot";
NSString *const kAnatomyToe = @"Toe";

NSString *const kDurationCoupleOfMinutes = @"Couple   Of    Minutes";
NSString *const kDurationOneHour = @"One Hour";
NSString *const kDurationMultipleHours = @"Multiple   Hours";
NSString *const kDurationOneDay = @"One   Day";
NSString *const kDurationMultipleDays = @"Multiple   Days";
NSString *const kDurationOneWeek = @"One Week";
NSString *const kDurationMultipleWeeks = @"Mutliple   Weeks";
NSString *const kDurationMonths = @"Months";
NSString *const kDurationOneYear = @"One   Year";
NSString *const kDurationMultipleYears = @"Multiple   Years";

NSString *const kSeverityMild = @"Mild";
NSString *const kSeverityMinor = @"Minor";
NSString *const kSeverityMedium = @"Medium";
NSString *const kSeverityMajor = @"Major";
NSString *const kSeverityExtreme = @"Extreme";

NSString *const kMiscFever = @"Fever";
NSString *const kMiscSweats = @"Sweats";
NSString *const kMiscChills = @"Chills";
NSString *const kMiscDizziness = @"Dizziness";
NSString *const kMiscVisionLoss = @"Vision   Loss";
NSString *const kMiscNausea = @"Nausea";

NSString *const kSymptomBurn = @"Burn";
NSString *const kSymptomBleeding = @"Bleeding";
NSString *const kSymptomSpasms = @"Spasms";
NSString *const kSymptomNumbness = @"Numbness";
NSString *const kSymptomRashItch = @"Rash/Itch";
NSString *const kSymptomSwelling = @"Swelling";
NSString *const kSymptomDislocation = @"Dislocation";
NSString *const kSymptomBreak = @"Fracture";
NSString *const kSymptomPain = @"Pain";
NSString *const kSymptomOther = @"Other";

NSString *const kDoctorGeneralPracticioner = @"Family   Medicine";
NSString *const kDoctorHospital = @"Hospital";
NSString *const kDoctorImmediateCare = @"Immediate   Care";
NSString *const kDoctorOptometrist = @"Optometrist";
NSString *const kDoctorDentist = @"Dentist";
NSString *const kDoctorDermatologist = @"Dermatologist";
NSString *const kDoctorPediatrician = @"Pediatrician";
NSString *const kDoctorCardiologist = @"Cardiologist";
NSString *const kDoctorNeurologist = @"Neurologist";
NSString *const kDoctorGynecologist = @"Gynecologist";
NSString *const kDoctorPsychologist = @"Psychologist";
NSString *const kDoctorUrologist = @"Urologist";
NSString *const kDoctorPodiatrist = @"Podiatrist";
NSString *const kDoctorAnesthesiologist = @"Anesthesiologist";
NSString *const kDoctorRadiologist = @"Radiologist";
NSString *const kDoctorSelfCare = @"Self   Care";
NSString *const kDoctorENT = @"E.N.T.";

NSString *const kDistance5Miles = @"5   Miles";
NSString *const kDistance10Miles = @"10   Miles";
NSString *const kDistance25Miles  = @"25   Miles";
NSString *const kDistance50Miles = @"50   Miles";
NSString *const kDistance100Miles = @"100   Miles";

NSString *const kLocationMe = @"Me";


NSString *const kFactualAddress = @"address";
NSString *const kFactualCity = @"city";
NSString *const kFactualCountry = @"country";
NSString *const kFactualDistance = @"distance";
NSString *const kFactualEmail = @"email";
NSString *const kFactualName = @"name";
NSString *const kFactualState = @"state";
NSString *const kFactualTelephone =@"telephone";
NSString *const kFactualWebsite = @"website";
NSString *const kFactualZipcode = @"zipcode";

@end
