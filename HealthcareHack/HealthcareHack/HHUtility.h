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


#pragma mark - String Constants

extern NSString *const kFontName;
extern NSString *const kSymptomLocation;
extern NSString *const kSymptomType;
extern NSString *const kSymptomDuration;
extern NSString *const kSymptomIntensity;
@end
