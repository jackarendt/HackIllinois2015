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

+ (UIView *)getGradientForHeight:(CGFloat)height width:(CGFloat)width {
    UIView* view = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, width, height)];
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = view.bounds;
    gradient.colors = [NSArray arrayWithObjects:(id)[[self getDarkGreenColor] CGColor], (id)[[self getLightGreenColor] CGColor], nil];
    [view.layer insertSublayer:gradient atIndex:0];
    return view;
}

NSString *const kFontName = @"Bebas";
NSString *const kSymptomLocation = @"kSymptomLocation";
NSString *const kSymptomType = @"kSymptomType";
NSString *const kSymptomDuration = @"kSymptomDuration";
NSString *const kSymptomIntensity = @"kSymptomIntensity";

@end
