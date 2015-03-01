//
//  ProfileViewController.m
//  HealthcareHack
//
//  Created by Jack Arendt on 2/27/15.
//  Copyright (c) 2015 John Arendt. All rights reserved.
//

#import "ProfileViewController.h"
#import "HHUtility.h"
#import "HHUser.h"

#define kTableViewCell @"cell"

@interface ProfileViewController () {
    CGFloat height;
    CGFloat width;
    HHUser *_user;
    
}
@property (nonatomic, strong) UILabel *sentenceLabel;
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    height = self.view.bounds.size.height;
    width = self.view.bounds.size.width;
    self.view = [HHUtility getGradientForHeight:height width:width];
    
    [HHUser sharedUser:^(NSString *err, BOOL success, HHUser *user){
        _user = user;
    }];
    
    [self.navigationController setNavigationBarHidden:YES animated:NO];

    self.sentenceLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 40, width, 50)];
    self.sentenceLabel.text = @"Profile";
    self.sentenceLabel.textAlignment = NSTextAlignmentCenter;
    self.sentenceLabel.textColor = [UIColor whiteColor];
    self.sentenceLabel.font = [UIFont fontWithName:kFontName size:45];
    
    [self.view addSubview:self.sentenceLabel];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 100, width, height-100) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kTableViewCell];
    self.tableView.backgroundColor = [UIColor clearColor];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    self.tableView.scrollEnabled = NO;
    [self.view addSubview:self.tableView];

    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kTableViewCell forIndexPath:indexPath];
    NSArray *placeholders = @[@"Gender", @"Age", @"Height", @"Weight"];
    NSArray *values = @[[_user getFormattedGender], [NSString stringWithFormat:@"%li yrs", (long)_user.age], [_user getFormattedHeight], [NSString stringWithFormat:@"%li lbs", (long)_user.weight.integerValue]];
    cell.textLabel.text = placeholders[indexPath.row];
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.textLabel.font = [UIFont fontWithName:kFontName size:25.0];
    
    
    UILabel *detailTextLabel = [[UILabel alloc] initWithFrame:CGRectMake(width - 150, 0, 120, cell.bounds.size.height)];
    detailTextLabel.text = values[indexPath.row];
    detailTextLabel.textColor = [UIColor colorWithRed:0.8 green: 0.8 blue:0.8 alpha:1];
    detailTextLabel.font = [UIFont fontWithName:kFontName size:25.0];
    detailTextLabel.textAlignment = NSTextAlignmentRight;
    [cell addSubview:detailTextLabel];

    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}
@end
