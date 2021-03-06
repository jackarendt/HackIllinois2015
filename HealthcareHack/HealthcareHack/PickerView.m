//
//  PickerView.m
//  HealthcareHack
//
//  Created by Jack Arendt on 2/28/15.
//  Copyright (c) 2015 John Arendt. All rights reserved.
//

#import "PickerView.h"
#import "HHUtility.h"

@interface PickerView () {
    UIToolbar *_toolbar;
    CGFloat width;
    CGFloat height;
    NSArray *titles;
    NSArray *secondTitle;
    NSInteger components;
    
    NSString *_first;
    NSString *_second;
}
@property (nonatomic, strong) UIPickerView *pickerView;
@end

@implementation PickerView

-(instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self) {
        
        UIVisualEffect *blurEffect;
        blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
        
        UIVisualEffectView *visualEffectView;
        visualEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
        
        visualEffectView.frame = self.bounds;
        [self addSubview:visualEffectView];
        
        width = frame.size.width;
        height = frame.size.height;
        _toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, width, 44)];
        _toolbar.tintColor = [HHUtility getGreenColor];
        UIBarButtonItem *button = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(dismissView)];
        UIFont *font = [UIFont fontWithName:kFontName size:21.0];
        NSDictionary *attrsDictionary = @{NSFontAttributeName : font};
        [button setTitleTextAttributes:attrsDictionary forState:UIControlStateNormal];
        [_toolbar setItems:@[[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil], button]];
        [self addSubview:_toolbar];
        
        self.pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 44, width, height - 44)];
        self.pickerView.delegate = self;
        self.pickerView.dataSource = self;
        [self addSubview:self.pickerView];
    }
    return self;
}


-(void)dismissView {
    if(self.delegate) {
        [self.delegate pickerViewDidHitDoneButton:self];
    }
}

#pragma mark - picker view

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    if(components != 0){
        return components;
    }
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if(component == 0) {
        return titles.count;
    }

    return secondTitle.count;
}

//- (NSAttributedString *)pickerView:(UIPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component
//{
//    NSString *title;
//    if(component == 0)
//        title = titles[row];
//    else {
//        title = secondTitle[row];
//    }
//    UIFont *font = [UIFont fontWithName:kFontName size:21.0];
//    NSDictionary *attrsDictionary = @{NSFontAttributeName : font, NSForegroundColorAttributeName : [UIColor whiteColor]};
//    NSAttributedString *attString = [[NSAttributedString alloc] initWithString:title attributes:attrsDictionary];
//    
//    return attString;
//    
//}

-(UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    UIView *v  = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, 40)];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, width, 40)];
    NSString *title;
        if(component == 0)
            title = titles[row];
        else {
            title = secondTitle[row];
        }
    label.text = title;
    label.font = [UIFont fontWithName:kFontName size:21.0];
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    [v addSubview:label];
    
    return v;
}

-(CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return 40;
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if(component == 0) {
        _first = titles[row];
    }
    
    else {
        _second = secondTitle[row];
    }
    
    [self.delegate pickerViewDidSelectComponentsString:_first second:_second onLoad:NO];
}


#pragma mark - public functions
-(void)setComponentValues:(NSArray *)firstComp secondComp:(NSArray *)second components:(NSInteger)comp {
    [self.pickerView selectRow:0 inComponent:0 animated:YES];
    if([self.pickerView numberOfComponents] == 2) {
        [self.pickerView selectRow:0 inComponent:1 animated:YES];
    }
    
    titles = firstComp;
    secondTitle = second;
    components = comp;
    _first = titles[0];
    if(secondTitle) {
        _second = secondTitle[0];
    }
    else {
        _second = nil;
    }
    
    [self.delegate pickerViewDidSelectComponentsString:_first second:_second onLoad:YES];
    [self.pickerView reloadAllComponents];
}

-(void)loadWithValues:(NSString *)first second:(NSString *)second {
    
    if (first) {
        for (int i = 0; i < titles.count; i++) {
            if([first isEqualToString:titles[i]]) {
                [self.pickerView selectRow:i inComponent:0 animated:YES];
            }
        }
    }
    if(!second)
        return;
    for (int i = 0; i < secondTitle.count; i++) {
        if([second isEqualToString:secondTitle[i]]) {
            [self.pickerView selectRow:i inComponent:1 animated:YES];
        }
    }

    
}
@end
