//
//  SentenceView.m
//  HealthcareHack
//
//  Created by Jack Arendt on 2/28/15.
//  Copyright (c) 2015 John Arendt. All rights reserved.
//

#import "SentenceView.h"
#import "HHUtility.h"


#define kQuery @"QUERY"
#define kFontHeight 45
#define kTextSize 25
#define kPickerHeight 230

@interface SentenceView () {
    NSArray *_phrases;
    NSMutableArray *symptoms;
    
    CGFloat width;
    CGFloat height;
    UIButton *addMoreSymptoms;
    UIButton *submit;
    UIColor *textColor;
    SelectView *openSelectView;
    PickerView *picker;
}

@end

@implementation SentenceView

-(instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self) {
        width = self.bounds.size.width;
        height = self.bounds.size.height;
    }
    return self;
}

-(void)setPhrases:(NSArray *)phrases {
    _phrases = phrases;
    [self createView];
}

-(void)createView {
    textColor = [UIColor colorWithRed:0.8 green: 0.8 blue:0.8 alpha:1];
    int i = 0;
    for(NSString *_phrase in _phrases) {
        [self createLine:_phrase index:i];
        i++;
    }
    
    
    if([self.delegate sentenceViewCanHaveAddSymptoms:self]) {
        addMoreSymptoms = [[UIButton alloc] initWithFrame:CGRectMake(0, height - 160, width, 40)];
        [addMoreSymptoms setTitle:@"add   more   symptoms" forState:UIControlStateNormal];
        [addMoreSymptoms setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [addMoreSymptoms setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
        addMoreSymptoms.titleLabel.font = [UIFont fontWithName:kFontName size:25.0];
        [addMoreSymptoms addTarget:self action:@selector(addSymptoms) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:addMoreSymptoms];
    }
    
    NSString *submitTitle = [self.delegate titleForSubmitButtonForSentenceView:self];
    
    submit = [[UIButton alloc] initWithFrame:CGRectMake(0, height - 110, width, 40)];
    [submit setTitle:submitTitle forState:UIControlStateNormal];
    [submit setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [submit setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    submit.titleLabel.font = [UIFont fontWithName:kFontName size:35.0];
    [submit addTarget:self action:@selector(submit) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:submit];
    
    
    picker = [[PickerView alloc] initWithFrame:CGRectMake(0, height, width, kPickerHeight)];
    picker.delegate = self;
    [self addSubview:picker];
}

-(void)createLine:(NSString *)phrase index:(NSInteger)index{
    NSArray *words = [phrase componentsSeparatedByString:@" "];
    NSInteger pos = [self findQueryPosition:words];
    NSArray *reconstructed = [self reconstructArray:words queryPos:pos];
    [self addSubviewsForReconstructedArray:reconstructed atHeight:(kFontHeight) * index index:index];
}

-(NSInteger)findQueryPosition:(NSArray *)words {
    for (int i = 0; i < words.count; i++) {
        if([words[i] isEqualToString:kQuery]) {
            return i;
        }
    }
    return -1;
}

-(NSArray *)reconstructArray:(NSArray *)orig queryPos:(NSInteger)queryPos {
    if (queryPos == -1) { //no query in line. straight text
        NSString *str = [orig componentsJoinedByString:@" "];
        return @[str];
    }
    
    if (queryPos == 0) { //query is last part of list, omit first entry
        NSArray *sub = [orig subarrayWithRange:NSMakeRange(1, orig.count - 1)];
        NSString *str = [sub componentsJoinedByString:@" "];
        return @[kQuery, str];
    }
    
    if (queryPos == 1) {
        return orig;
    }
    
    if (queryPos == 2) {
        NSArray *sub = [orig subarrayWithRange:NSMakeRange(0, orig.count - 1)];
        NSString *str = [sub componentsJoinedByString:@" "];
        return @[str, kQuery];
    }
    
    return nil;
}

-(void)addSubviewsForReconstructedArray:(NSArray *)reconstruct atHeight:(CGFloat)labelHeight index:(NSInteger)index{
    if(reconstruct.count == 1) { //no query
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, labelHeight, width - 20, kFontHeight)];
        label.text = reconstruct[0];
        label.font = [UIFont fontWithName:kFontName size:kTextSize];
        label.textColor = textColor;
        [self addSubview:label];
    }
    
    if(reconstruct.count == 2 && [reconstruct[0] isEqualToString:kQuery]) { //first index
        UIFont *font = [UIFont fontWithName:kFontName size:kTextSize];
        CGSize fontSize = [reconstruct[1] sizeWithFont:font];
        CGFloat strikeWidth = fontSize.width;
        
        UILabel *firstLabel = [[UILabel alloc] initWithFrame:CGRectMake(width - (strikeWidth + 20), labelHeight, strikeWidth + 20, kFontHeight)];
        firstLabel.text = reconstruct[1];
        firstLabel.font = font;
        firstLabel.textColor = textColor;
        [self addSubview:firstLabel];
        
        SelectView *select = [[SelectView alloc] initWithFrame:CGRectMake(10, labelHeight, width - strikeWidth - 20, kFontHeight)];
        select.tag = index;
        select.delegate = self;
        [self addSubview:select];
    }
    
    if(reconstruct.count == 2 && [reconstruct[1] isEqualToString:kQuery]) { //last index
        UIFont *font = [UIFont fontWithName:kFontName size:kTextSize];
        CGSize fontSize = [reconstruct[0] sizeWithFont:font];
        CGFloat strikeWidth = fontSize.width;
        UILabel *firstLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, labelHeight, strikeWidth + 20, kFontHeight)];
        firstLabel.text = reconstruct[0];
        firstLabel.font = font;
        firstLabel.textColor = textColor;
        [self addSubview:firstLabel];
        
        SelectView *select = [[SelectView alloc] initWithFrame:CGRectMake(strikeWidth + 50, labelHeight, width - (strikeWidth+20) -10, kFontHeight)];
        select.tag = index;
        select.delegate = self;
        [self addSubview:select];

    }
    
    if(reconstruct.count == 3) {
        UIFont *font = [UIFont fontWithName:kFontName size:kTextSize];
        CGSize firstFontSize = [reconstruct[0] sizeWithFont:font];
        CGFloat firstStrikeWidth = firstFontSize.width;
        CGSize secondFontSize = [reconstruct[2] sizeWithFont:font];
        CGFloat secondStrikeWidth = secondFontSize.width;
        
        UILabel *firstLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, labelHeight, firstStrikeWidth + 20, kFontHeight)];
        firstLabel.text = reconstruct[0];
        firstLabel.font = font;
        firstLabel.textColor = textColor;
        [self addSubview:firstLabel];
        
        UILabel *secondLabel = [[UILabel alloc] initWithFrame:CGRectMake(width - (secondStrikeWidth + 20), labelHeight, secondStrikeWidth + 20, kFontHeight)];
        secondLabel.text = reconstruct[2];
        secondLabel.font = font;
        secondLabel.textColor = textColor;
        [self addSubview:secondLabel];
        
        SelectView *select = [[SelectView alloc] initWithFrame:CGRectMake(firstStrikeWidth + 20, labelHeight, width - firstStrikeWidth - secondStrikeWidth - 50, kFontHeight)];
        select.tag = index;
        select.delegate = self;
        [self addSubview:select];
    }
}

-(void)addSymptoms{
    
}

-(void)submit {
    if(self.delegate) {
        [self.delegate submitButtonPressedWithData:nil];
    }
}

#pragma selectView/PickerView Delegate methods
-(void)selectViewTapped:(id)selectView {
    if(openSelectView == selectView) {
        return;
    }
    NSInteger tag = ((SelectView *)selectView).tag;
    openSelectView = selectView;
    if(self.delegate) {
        NSArray *first = [self.delegate sentenceView:self didRequestItemsForIndex:tag];
        NSArray *second;
        NSInteger components = 1;
        if([self.delegate needsSecondTypeForIndex:tag]) {
            second = [self.delegate sentenceView:self didRequestSecondItemsForIndex:tag];
            components = 2;
        }
        [picker setComponentValues:first secondComp:second components:components];
        [picker loadWithValues:[openSelectView getFirstComponent] second:[openSelectView getSecondComponent]];
    }
    [self.delegate sentenceViewPickerDidBecomeActive:YES];
    [UIView animateKeyframesWithDuration:0.3 delay:0 options:UIViewKeyframeAnimationOptionCalculationModeCubic animations:^{
        picker.frame = CGRectMake(0, height - kPickerHeight, width, kPickerHeight);
    }completion:^(BOOL finished){
        
    }];
}

-(void)pickerViewDidHitDoneButton:(id)pickerView {
    [self.delegate sentenceViewPickerDidBecomeActive:NO];
    [UIView animateKeyframesWithDuration:0.3 delay:0.05 options:UIViewKeyframeAnimationOptionCalculationModeCubic animations:^{
        picker.frame = CGRectMake(0, height, width, kPickerHeight);
    }completion:^(BOOL finished){
        
    }];

}

-(void)pickerViewDidSelectComponentsString:(NSString *)first second:(NSString *)second onLoad:(BOOL)onLoad{
    if(!onLoad) {
        [openSelectView setComponents:first second:second];
    
        if(first && second) {
            if([second isEqualToString:@"Fever"] || [second isEqualToString:@"Sweats"] || [second isEqualToString:@"Chills"] || [second isEqualToString:@"Dizziness"] || [second isEqualToString:@"Vision Loss"] || [second isEqualToString:@"Nausea"]) {
                [openSelectView updateSentence:[NSString stringWithFormat:@"%@", second]];
            }
            else {
                [openSelectView updateSentence:[NSString stringWithFormat:@"%@   %@", first, second]];
            }
        }
        else {
            [openSelectView updateSentence:first];
        }
    }
    
    else {
        NSString *_first = [openSelectView getFirstComponent];
        NSString *_second = [openSelectView getSecondComponent];
        if(_first && _second) {
            if([_second isEqualToString:@"Fever"] || [_second isEqualToString:@"Sweats"] || [_second isEqualToString:@"Chills"] || [_second isEqualToString:@"Dizziness"] || [_second isEqualToString:@"Vision Loss"] || [_second isEqualToString:@"Nausea"]) {
                [openSelectView updateSentence:[NSString stringWithFormat:@"%@", _second]];
            }
            else {
                [openSelectView updateSentence:[NSString stringWithFormat:@"%@\t%@", _first, _second]];
            }
        }
        else {
            [openSelectView updateSentence:_first];
        }
    }
}


@end
