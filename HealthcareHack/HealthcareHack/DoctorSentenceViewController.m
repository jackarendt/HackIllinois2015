//
//  DoctorSentenceViewController.m
//  HealthcareHack
//
//  Created by Jack Arendt on 2/27/15.
//  Copyright (c) 2015 John Arendt. All rights reserved.
//

#import "DoctorSentenceViewController.h"
#import "HHUtility.h"
#import "HHUser.h"

@interface DoctorSentenceViewController () {
    CGFloat height;
    CGFloat width;
    HHUser *_user;
    
}
@property (nonatomic, strong) UILabel *sentenceLabel;
@property (nonatomic, strong) SentenceView *sentenceView;
@end

@implementation DoctorSentenceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [HHUser sharedUser:^(NSString *err, BOOL success, HHUser *user){
        _user = user;
        [_user startUpdatingUserLocation];
    }];
    
    height = self.view.bounds.size.height;
    width = self.view.bounds.size.width;
    self.view = [HHUtility getGradientForHeight:height width:width];
    
    [self.navigationController setNavigationBarHidden:YES animated:NO];

    self.sentenceLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 40, width, 50)];
    self.sentenceLabel.text = @"Find A Doctor";
    self.sentenceLabel.textAlignment = NSTextAlignmentCenter;
    self.sentenceLabel.textColor = [UIColor whiteColor];
    self.sentenceLabel.font = [UIFont fontWithName:kFontName size:45];
    [self.view addSubview:self.sentenceLabel];
    
    self.sentenceView = [[SentenceView alloc] initWithFrame:CGRectMake(0, 120, width, height - 120)];
    self.sentenceView.delegate = self;
    [self.sentenceView setPhrases:@[@"I want a", @"QUERY", @"Within", @"QUERY", @"Of", @"QUERY"]];
    [self.view addSubview:self.sentenceView];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}


#pragma mark - Sentence View Delgate Methods

-(BOOL)sentenceViewCanHaveAddSymptoms:(id)sentenceView {
    return NO;
}

-(void)sentenceView:(id)sentenceView didReturnItem:(NSString *)item forIndex:(NSInteger)index {
    
}

-(NSArray *)sentenceView:(id)sentenceView didRequestItemsForIndex:(NSInteger)index {
    switch (index) {
        case 1:
            return @[@"General Practicioner", @"Hospital", @"Immediate Care", @"Optometrist", @"Dentist", @"Dermatologist", @"Pediatrician"];
            break;
        case 3:
            return @[@"5 Miles", @"10 Miles", @"25 Miles", @"50 Miles", @"100 Miles"];
            break;
        case 5:
            return @[@"Me"];
        default:
            return nil;
            break;
    }
}

-(NSString *)titleForSubmitButtonForSentenceView:(id)sentenceView {
    return @"Find";
}

-(BOOL)needsSecondTypeForIndex:(NSInteger)index {
    return NO;
}

-(NSArray *)sentenceView:(id)sentenceView didRequestSecondItemsForIndex:(NSInteger)index {
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
