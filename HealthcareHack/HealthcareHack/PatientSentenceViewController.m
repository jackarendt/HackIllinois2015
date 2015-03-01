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
    self.sentenceLabel.text = @"The Problem";
    self.sentenceLabel.textAlignment = NSTextAlignmentCenter;
    self.sentenceLabel.textColor = [UIColor whiteColor];
    self.sentenceLabel.font = [UIFont fontWithName:kFontName size:45];
    
    [self.view addSubview:self.sentenceLabel];
    
    self.sentenceView = [[SentenceView alloc] initWithFrame:CGRectMake(0, 120, width, height - 120)];
    self.sentenceView.delegate = self;
    [self.sentenceView setPhrases:@[@"I have", @"QUERY", @"For", @"QUERY", @"With", @"QUERY", @"Intentsity."]];
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
            return @[@"General", @"Front Of Head", @"Back Of Head", @"Eye", @"Ear", @"Nose", @"Mouth", @"Throat", @"Neck", @"Chest", @"Upper Back", @"Lower Back", @"Pelvis", @"Butt", @"Bowel", @"Shoulder", @"Upper Arm", @"Lower Arm", @"Elbow", @"Hand", @"Wrist", @"Finger", @"Upper Leg", @"Lower Leg", @"Knee", @"Ankle", @"Foot", @"Toe"];
            break;
        case 3:
            return @[@"Minutes", @"One Hour", @"Multiple Hours", @"One Day", @"Multiple Days", @"One Week", @"Multiple Weeks", @"Months", @"One Year", @"Multiple Years"];
            break;
        case 5:
            return @[@"Mild", @"Minor", @"Medium", @"Major", @"Extreme"];
        default:
            return nil;
            break;
    }
}

-(void)sentenceView:(id)sentenceView didReturnItem:(NSString *)item forIndex:(NSInteger)index {
    
}

-(BOOL)sentenceViewCanHaveAddSymptoms:(id)sentenceView {
    return YES;
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
        return @[@"Fever", @"Sweats", @"Chills", @"Dizziness", @"Vision Loss", @"Nausea" @"Burn", @"Bleeding", @"Spasms", @"Numbness", @"Rash/Itch", @"Swelling", @"Dislocation", @"Break", @"Pain", @"Other"];
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
@end
