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
+ (UIColor *)getBlueColor {
    return [UIColor colorWithRed:0.086 green:0.5764 blue:0.8 alpha:1]; //22, 147, 204
}

+(UIColor *)getGreenColor {
    return [UIColor colorWithRed:0.004 green:0.6 blue:0.4588 alpha:1]; //1, 153, 117
}

+ (UIColor *)getRedColor {
    return [UIColor colorWithRed:0.8117 green:0 blue:0.0588 alpha:1];
}


NSString *const kFontName = @"Bebas";

@end
