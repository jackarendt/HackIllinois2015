//
//  DoctorAnnotation.m
//  HealthcareHack
//
//  Created by Jack Arendt on 3/1/15.
//  Copyright (c) 2015 John Arendt. All rights reserved.
//

#import "DoctorAnnotation.h"

@implementation DoctorAnnotation

-(instancetype)initWithTitle:(NSString *)newTitle coord:(CLLocationCoordinate2D)location {
    self = [super init];
    if(self) {
        _title = newTitle;
        _coordinate = location;
    }
    return self;
}

-(MKAnnotationView *)annotationView {
    MKAnnotationView *annotationView = [[MKAnnotationView alloc] initWithAnnotation:self reuseIdentifier:@"annotation"];
    annotationView.enabled = YES;
    annotationView.canShowCallout = YES;
    
    return annotationView;
}
@end
