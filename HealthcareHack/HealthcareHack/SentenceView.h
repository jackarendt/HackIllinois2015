//
//  SentenceView.h
//  HealthcareHack
//
//  Created by Jack Arendt on 2/28/15.
//  Copyright (c) 2015 John Arendt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SelectView.h"
#import "PickerView.h"

@protocol SentenceViewDelegate <NSObject>

-(NSArray *)sentenceView:(id)sentenceView didRequestItemsForIndex:(NSInteger)index;
-(void)sentenceView:(id)sentenceView didReturnItem:(NSString *)item forIndex:(NSInteger)index;
-(NSString *)titleForSubmitButtonForSentenceView:(id)sentenceView;
-(BOOL)sentenceViewCanHaveAddSymptoms:(id)sentenceView;
-(BOOL)needsSecondTypeForIndex:(NSInteger)index;
-(NSArray *)sentenceView:(id)sentenceView didRequestSecondItemsForIndex:(NSInteger)index;
-(void)sentenceViewPickerDidBecomeActive:(BOOL)active;
-(void)submitButtonPressedWithData:(NSDictionary *)sentence;
-(void)submitRequestFinishedWithSuccess:(BOOL)success;

@end

@interface SentenceView : UIView <SelectViewDelegate, PickerViewDelegate>

-(void)setPhrases:(NSArray *)phrases;

@property id<SentenceViewDelegate> delegate;

@end
