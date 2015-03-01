//
//  PatientSentenceViewController.m
//  HealthcareHack
//
//  Created by Jack Arendt on 2/27/15.
//  Copyright (c) 2015 John Arendt. All rights reserved.
//

#import "PatientSentenceViewController.h"
#import "HHUtility.h"
#import "HHUser.h"
#import "DoctorReferralViewController.h"


@interface PatientSentenceViewController () {
    CGFloat height;
    CGFloat width;
    HHUser *_user;
}
@property (nonatomic, strong) UILabel *sentenceLabel;
@property (nonatomic, strong) SentenceView *sentenceView;
@end

@implementation PatientSentenceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    height = self.view.bounds.size.height;
    width = self.view.bounds.size.width;
    self.view = [HHUtility getGradientForHeight:height width:width];
    
    [HHUser sharedUser:^(NSString *err, BOOL success, HHUser *user){
        _user = user;
    }];

    
    //self.view.backgroundColor = [HHUtility getGreenColor];

    self.sentenceLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 40, width, 55)];
    self.sentenceLabel.text = @"The\tProblem";
    self.sentenceLabel.textAlignment = NSTextAlignmentCenter;
    self.sentenceLabel.textColor = [UIColor whiteColor];
    self.sentenceLabel.font = [UIFont fontWithName:kFontName size:45];
    
    [self.view addSubview:self.sentenceLabel];
    
    self.sentenceView = [[SentenceView alloc] initWithFrame:CGRectMake(0, 120, width, height - 120)];
    self.sentenceView.delegate = self;
    [self.sentenceView setPhrases:@[@"I   have", @"QUERY", @"For", @"QUERY", @"With", @"QUERY", @"Intentsity."]];
    [self.view addSubview:self.sentenceView];
    
    
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    //self.view.backgroundColor = [HHUtility getBlueColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - sentence View delegate methods

-(NSArray *)sentenceView:(id)sentenceView didRequestItemsForIndex:(NSInteger)index {
    switch (index) {
        case 1:
            return @[kAnatomyGeneral, kAnatomyForehead, kAnatomySkull, kAnatomyEye, kAnatomyEar, kAnatomyNose, kAnatomyMouth, kAnatomyThroat, kAnatomyNeck, kAnatomyChest, kAnatomyUpperBack, kAnatomyLowerBack, kAnatomyPelvis, kAnatomyGenitals, kAnatomyButt, kAnatomyBowel, kAnatomyShoulder, kAnatomyUpperArm, kAnatomyLowerArm, kAnatomyElbow, kAnatomyHand, kAnatomyWrist, kAnatomyFinger, kAnatomyUpperLeg, kAnatomyLowerLeg, kAnatomyKnee, kAnatomyAnkle, kAnatomyFoot, kAnatomyToe];
            break;
        case 3:
            return @[kDurationCoupleOfMinutes, kDurationOneHour, kDurationMultipleHours, kDurationOneDay, kDurationMultipleDays, kDurationOneWeek, kDurationMultipleWeeks, kDurationMonths, kDurationOneYear, kDurationMultipleYears];
            break;
        case 5:
            return @[kSeverityMild, kSeverityMinor, kSeverityMedium, kSeverityMajor, kSeverityExtreme];
        default:
            return nil;
            break;
    }
}

-(void)sentenceView:(id)sentenceView didReturnItem:(NSString *)item forIndex:(NSInteger)index {
    
}

-(BOOL)sentenceViewCanHaveAddSymptoms:(id)sentenceView {
    return NO;
}

-(NSString *)titleForSubmitButtonForSentenceView:(id)sentenceView {
    return @"Submit";
}

-(BOOL)needsSecondTypeForIndex:(NSInteger)index {
    if(index == 1) {
        return YES;
    }
    return NO;
}

-(NSArray *)sentenceView:(id)sentenceView didRequestSecondItemsForIndex:(NSInteger)index {
    if(index == 1) {
        return @[kMiscFever, kMiscSweats, kMiscChills, kMiscDizziness, kMiscVisionLoss, kMiscNausea, kSymptomBurn, kSymptomBleeding, kSymptomSpasms, kSymptomNumbness, kSymptomRashItch, kSymptomSwelling, kSymptomDislocation, kSymptomBreak, kSymptomPain, kSymptomOther];
    }
    return nil;
}

-(void)sentenceViewPickerDidBecomeActive:(BOOL)active {
    if(active) {
        self.tabBarController.tabBar.hidden = YES;
    }
    
    else {
        self.tabBarController.tabBar.hidden = NO;
    }
}

-(void)submitButtonPressedWithData:(NSDictionary *)sentence {
    NSArray *keywords = [self.sentenceView getKeyWords];
    if(keywords.count != 4) {
        return;
    }
    NSString *code = [HHUtility getCodeForAnatomy:keywords[0] symptom:keywords[1] duration:keywords[2] severity:keywords[3]];
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    dict[@"imo"] = [NSDictionary dictionaryWithObject:code forKey:@"code"];
    [_user put:dict completionHandler:^(NSError *err, NSDictionary *jsonDict){
        if(err) {
            [[[UIAlertView alloc] initWithTitle:@"Error" message:@"Something Went Wrong" delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil] show];
        }
        else {
            _user.doctorRecommendation = jsonDict[@"doctorType"];
            _user.doctorDescription = jsonDict[@"description"];
            _user.doctorTips = @[jsonDict[@"tip1"], jsonDict[@"tip2"], jsonDict[@"tip3"]];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self performSegueWithIdentifier:@"toDoctorReferral" sender:self];
            });
        }
    }];
}

-(void)segueToReferral {
    [self performSegueWithIdentifier:@"toDoctorReferral" sender:self];
}

-(void)submitRequestFinishedWithSuccess:(BOOL)success {
}
@end
