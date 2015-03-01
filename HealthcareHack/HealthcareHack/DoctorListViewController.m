//
//  DoctorListViewController.m
//  HealthcareHack
//
//  Created by Jack Arendt on 2/28/15.
//  Copyright (c) 2015 John Arendt. All rights reserved.
//

#import "DoctorListViewController.h"
#import "DoctorTableViewCell.h"
#import "DoctorAnnotation.h"

@interface DoctorListViewController (){
    CGFloat width;
    CGFloat height;
    MKMapView *_mapView;
}
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation DoctorListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    height = self.view.bounds.size.height;
    width = self.view.bounds.size.width;
    self.view = [HHUtility getGradientForHeight:height width:width];
    
    
    _mapView = [[MKMapView alloc] initWithFrame:CGRectMake(0, 0, width, 0.4 * height)];
    _mapView.delegate = self;
    _mapView.showsUserLocation = YES;
    _mapView.showsBuildings = YES;
    [self.view addSubview:_mapView];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0.4*height, width, 0.6*height - 49) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[DoctorTableViewCell class] forCellReuseIdentifier:@"cell"];
    self.tableView.backgroundColor = [UIColor clearColor];
    
    [self.view addSubview:self.tableView];
    [self addAnnotations];
    
    UIButton *back = [[UIButton alloc] initWithFrame:CGRectMake(10, 30, 45, 45)];
    [back setImage:[UIImage imageNamed:@"BackDarkButton"] forState:UIControlStateNormal];
    [back setImage:[UIImage imageNamed:@"BackButtonHighlighted"] forState:UIControlStateHighlighted];
    [back addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:back];

    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)goBack {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - tableview delegate methods
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.manager getNumberOfDoctors];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DoctorTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    Doctor *doctor = [self.manager getDoctorForIndex:indexPath.row];
    cell.doctor = doctor;
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 90;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *annotations = [_mapView annotations];
    for(MKPointAnnotation *point in annotations) {
        Doctor *doctor = [self.manager getDoctorForIndex:indexPath.row];
        if([doctor.name isEqualToString:point.title]){
            [_mapView selectAnnotation:point animated:YES];
        }
    }
    
}


#pragma mark - mapview delegate methods

-(void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {
    MKCoordinateRegion mapRegion;
    mapRegion.center = mapView.userLocation.coordinate;
    mapRegion.span.latitudeDelta = 0.1;
    mapRegion.span.longitudeDelta = 0.1;
    
    [mapView setRegion:mapRegion animated: YES];
}


-(void)addAnnotations {
    for(int i = 0; i < [self.manager getNumberOfDoctors]; i++) {
        Doctor *doctor = [self.manager getDoctorForIndex:i];
        NSString *location = [NSString stringWithFormat:@"%@ %@ %@", doctor.address, doctor.city, doctor.zipCode];
        [self addAnnotationForLocation:location doctor:doctor];
    }
}

-(void)addAnnotationForLocation:(NSString *)location doctor:(Doctor *)doctor{
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder geocodeAddressString:location
                 completionHandler:^(NSArray* placemarks, NSError* error){
                     if (placemarks && placemarks.count > 0) {
                         CLPlacemark *topResult = [placemarks objectAtIndex:0];
                         MKPlacemark *placemark = [[MKPlacemark alloc] initWithPlacemark:topResult];
                         MKPointAnnotation *point = [[MKPointAnnotation alloc] init];
                         point.coordinate = placemark.coordinate;
                         point.title = doctor.name;
                         
                         point.subtitle = [NSString stringWithFormat:@"%.02f Miles Away", doctor.distance.floatValue/1609];
                         [_mapView addAnnotation:point];
                     }
                 }
     ];
}


-(void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {
    for (int i = 0; i < [self.manager getNumberOfDoctors]; i++) {
        Doctor *doctor = [self.manager getDoctorForIndex:i];
        MKPointAnnotation *point = view.annotation;
        if([doctor.name isEqualToString:point.title]) {
            [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0] animated:YES scrollPosition:UITableViewScrollPositionMiddle];
        }
    }
}


@end
