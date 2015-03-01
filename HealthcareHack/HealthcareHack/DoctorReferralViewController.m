//
//  DoctorReferralViewController.m
//  HealthcareHack
//
//  Created by Jack Arendt on 2/28/15.
//  Copyright (c) 2015 John Arendt. All rights reserved.
//

#import "DoctorReferralViewController.h"
#import "DoctorListViewController.h"
#import "HHUtility.h"
#import "HHUser.h"
#import "DoctorManager.h"

@interface DoctorReferralViewController ()  {
    CGFloat height;
    CGFloat width;
    HHUser *_user;
    DoctorManager *manager;
    
}
@property (nonatomic, strong) UILabel *recommend;
@property (nonatomic, strong) UILabel *doctor;
@property (nonatomic, strong) UIButton *findOne;
@end

@implementation DoctorReferralViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    height = self.view.bounds.size.height;
    width = self.view.bounds.size.width;
    
    self.view = [HHUtility getGradientForHeight:height width:width];
    
    [HHUser sharedUser:^(NSString *err, BOOL success, HHUser *user){
        _user = user;
        [_user startUpdatingUserLocation];
        [self updateDoctorLabel];
        
    }];
    
    UIButton *back = [[UIButton alloc] initWithFrame:CGRectMake(10, 30, 45, 45)];
    [back setImage:[UIImage imageNamed:@"BackButton"] forState:UIControlStateNormal];
    [back setImage:[UIImage imageNamed:@"BackButtonHighlighted"] forState:UIControlStateHighlighted];
    [back addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:back];
    
    // Do any additional setup after loading the view.
}

-(void)updateDoctorLabel {
    self.recommend = [[UILabel alloc] initWithFrame:CGRectMake(10, 100, width - 20, 45)];
    self.recommend.font = [UIFont fontWithName:kFontName size:30];
    self.recommend.textColor = [UIColor colorWithRed:0.8 green: 0.8 blue:0.8 alpha:1];
    self.recommend.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.recommend];
    
    self.doctor = [[UILabel alloc] initWithFrame:CGRectMake(10, 160, width - 20, 50)];
    self.doctor.font = [UIFont fontWithName:kFontName size:45];
    self.doctor.textColor = [UIColor whiteColor];
    self.doctor.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.doctor];

    self.doctor.text = _user.doctorRecommendation;
    
    if([_user.doctorRecommendation isEqualToString:kDoctorSelfCare]) {
        self.recommend.text = @"We Recommend You Use";
    }
    else if([_user.doctorRecommendation isEqualToString:kDoctorHospital]){
        self.recommend.text = @"We Recommend You Go to a";
    }
    else if([_user.doctorRecommendation isEqualToString:kDoctorImmediateCare]){
        self.recommend.text = @"We Recommend You Go to an";
    }
    else if([_user.doctorRecommendation isEqualToString:kDoctorOptometrist] || [_user.doctorRecommendation isEqualToString:kDoctorUrologist] || [_user.doctorRecommendation isEqualToString:kDoctorAnesthesiologist]) {
        self.recommend.text = @"We Recommend You See an";
    }
    else if([_user.doctorRecommendation isEqualToString:kDoctorGeneralPracticioner]) {
        self.recommend.text = @"We Recommend You See a";
        self.doctor.text = @"Family Doctor";
    }
    else if ([_user.doctorRecommendation isEqualToString:kDoctorENT]) {
        self.recommend.text = @"We Recommend You See an";
        self.doctor.text = @"E.N.T. Doctor";
    }
    else {
        self.recommend.text = @"We Recommend You See a";
    }
    
    self.findOne = [[UIButton alloc] initWithFrame:CGRectMake(10, 250, width - 20, 30)];
    NSString *title = @"Need One?";
    if([_user.doctorRecommendation isEqualToString:kDoctorSelfCare])
        title = @"Need a pharmacy?";
    [self.findOne setTitle:title forState:UIControlStateNormal];
    [self.findOne setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.findOne setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    [self.findOne addTarget:self action:@selector(goToMap) forControlEvents:UIControlEventTouchUpInside];
    self.findOne.titleLabel.font = [UIFont fontWithName:kFontName size:25.0];
    [self.view addSubview:self.findOne];
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)goBack {
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)goToMap {
    NSMutableDictionary *query = [[NSMutableDictionary alloc] init];
    CLLocation *_loc = _user.location;
    NSString *recommendation = _user.doctorRecommendation;
    if([recommendation isEqualToString:kDoctorSelfCare]) {
        recommendation = @"Pharmacy";
    }
    query[@"factual"] = @{
                          @"latitude"    : [NSString stringWithFormat:@"%f", _loc.coordinate.latitude],
                          @"longitude"   : [NSString stringWithFormat:@"%f", _loc.coordinate.longitude],
                          @"doctor"      : recommendation,
                          @"radius"      : [NSString stringWithFormat:@"%li", [HHUtility getMetersFromString:kDistance25Miles]]
                          };

    [_user put:query completionHandler:^(NSError *err, NSDictionary *response) {
        if(err) {
            NSLog(@"UGH");
        }
        else {
            manager = [[DoctorManager alloc] initWithJSONFile:response];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self performSegueWithIdentifier:@"toDoctors" sender:self];
            });
        }
    }];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    DoctorListViewController *vc = [segue destinationViewController];
    vc.user = _user;
    vc.manager = manager;
}


@end
