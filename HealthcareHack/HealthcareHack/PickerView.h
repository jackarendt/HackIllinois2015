//
//  PickerView.h
//  HealthcareHack
//
//  Created by Jack Arendt on 2/28/15.
//  Copyright (c) 2015 John Arendt. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PickerViewDelegate <NSObject>
-(void)pickerViewDidHitDoneButton:(id)pickerView;
-(void)pickerViewDidSelectComponentsString:(NSString *)first second:(NSString *)second onLoad:(BOOL)onLoad;
@end

@interface PickerView : UIView <UIPickerViewDelegate, UIPickerViewDataSource>
@property id<PickerViewDelegate> delegate;

-(void)setComponentValues:(NSArray *)firstComp secondComp:(NSArray *)second components:(NSInteger)comp;
-(void)loadWithValues:(NSString *)first second:(NSString *)second;
@end
