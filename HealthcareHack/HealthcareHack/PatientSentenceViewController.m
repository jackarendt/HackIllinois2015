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
@end

@implementation PatientSentenceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [HHUser sharedUser:^(NSString *err, BOOL success, HHUser *user){
        _user = user;
        NSLog(@"%@", [_user getFormattedHeight]);
    }];

    
    self.view.backgroundColor = [HHUtility getGreenColor];
    height = self.view.bounds.size.height;
    width = self.view.bounds.size.width;
    self.sentenceLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 40, width, 45)];
    self.sentenceLabel.text = @"The Problem";
    self.sentenceLabel.textAlignment = NSTextAlignmentCenter;
    self.sentenceLabel.textColor = [UIColor whiteColor];
    self.sentenceLabel.font = [UIFont fontWithName:kFontName size:45];
    
    [self.view addSubview:self.sentenceLabel];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
