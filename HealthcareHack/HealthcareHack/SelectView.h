//
//  SelectView.h
//  HealthcareHack
//
//  Created by Jack Arendt on 2/28/15.
//  Copyright (c) 2015 John Arendt. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SelectViewDelegate <NSObject>

-(void)selectViewTapped:(id)selectView;

@end

@interface SelectView : UIView

-(void)updateSentence:(NSString *)sentence;
-(void)setComponents:(NSString *)first second:(NSString *)second;
-(NSString *)getFirstComponent;
-(NSString *)getSecondComponent;

@property id<SelectViewDelegate> delegate;

@end
