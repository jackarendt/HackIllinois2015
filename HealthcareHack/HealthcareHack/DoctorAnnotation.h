//
//  DoctorAnnotation.h
//  HealthcareHack
//
//  Created by Jack Arendt on 3/1/15.
//  Copyright (c) 2015 John Arendt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface DoctorAnnotation : NSObject <MKAnnotation>

-(instancetype)initWithTitle:(NSString *)newTitle coord:(CLLocationCoordinate2D)location;
-(MKAnnotationView *)annotationView;

@property (nonatomic, copy) NSString *title;
@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;

@end
