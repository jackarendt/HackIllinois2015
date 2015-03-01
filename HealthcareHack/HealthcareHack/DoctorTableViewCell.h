//
//  DoctorTableViewCell.h
//  HealthcareHack
//
//  Created by Jack Arendt on 3/1/15.
//  Copyright (c) 2015 John Arendt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HHUtility.h"
#import "Doctor.h"

@interface DoctorTableViewCell : UITableViewCell

@property (nonatomic, strong) Doctor *doctor;

@end
