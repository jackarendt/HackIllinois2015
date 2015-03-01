//
//  DoctorTableViewCell.m
//  HealthcareHack
//
//  Created by Jack Arendt on 3/1/15.
//  Copyright (c) 2015 John Arendt. All rights reserved.
//

#import "DoctorTableViewCell.h"

@interface DoctorTableViewCell () {
    CGFloat width;
    CGFloat height;
}
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *phoneLabel;
@property (nonatomic, strong) UILabel *addressLabel;
@end

@implementation DoctorTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self) {
        self.nameLabel = [[UILabel alloc] init];
        self.phoneLabel = [[UILabel alloc] init];
        self.addressLabel = [[UILabel alloc] init];
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        [self addSubview:self.nameLabel];
        [self addSubview:self.phoneLabel];
        [self addSubview:self.addressLabel];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    if(selected) {
        UIView *selectedView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
        selectedView.backgroundColor = [HHUtility getDarkGreenColor];
        self.selectedBackgroundView = selectedView;
    }
    
    else {
        UIView *nonselectedView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
        nonselectedView.backgroundColor = [UIColor clearColor];
        self.selectedBackgroundView = nonselectedView;
    }
}

-(void)setDoctor:(Doctor *)doctor {
    width = self.bounds.size.width;
    height = self.bounds.size.height;
    
    self.nameLabel.text = doctor.name;
    self.nameLabel.frame = CGRectMake(10, 5, width - 20, 26);
    self.nameLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:21.0];
    self.nameLabel.textColor = [UIColor whiteColor];
    
    self.addressLabel.text = [NSString stringWithFormat:@"%@ - %.02f Miles",doctor.address, [doctor.distance floatValue]/1609];
    self.addressLabel.frame = CGRectMake(10, 31, width - 20, 25);
    self.addressLabel.font = [UIFont systemFontOfSize:17.0];
    self.addressLabel.textColor = [UIColor whiteColor];
    
    self.phoneLabel.text = doctor.telephone;
    self.phoneLabel.frame = CGRectMake(10, 56, width - 20, 25);
    self.phoneLabel.font = [UIFont systemFontOfSize:17.0];
    self.phoneLabel.textColor = [UIColor whiteColor];
}


@end
