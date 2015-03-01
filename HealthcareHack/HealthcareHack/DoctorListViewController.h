//
//  DoctorListViewController.h
//  HealthcareHack
//
//  Created by Jack Arendt on 2/28/15.
//  Copyright (c) 2015 John Arendt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "DoctorManager.h"
#import "HHUtility.h"
#import "HHUser.h"

@interface DoctorListViewController : UIViewController <MKMapViewDelegate, UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) DoctorManager *manager;
@property (nonatomic, strong) HHUser *user;

@end
