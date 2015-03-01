//
//  SelectView.m
//  HealthcareHack
//
//  Created by Jack Arendt on 2/28/15.
//  Copyright (c) 2015 John Arendt. All rights reserved.
//

#import "SelectView.h"
#import "HHUtility.h"

@interface SelectView () {
    CGFloat height;
    CGFloat width;
}
@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) UIButton *button;
@property (nonatomic, strong) UILabel *resultLabel;
@end

@implementation SelectView

-(instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self) {
        height = frame.size.height;
        width = frame.size.width;
        
        self.bottomView = [[UIView alloc] initWithFrame:CGRectMake(5, height - 2, width - 30, 2)];
        self.bottomView.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.bottomView];
        
        CGPoint startPoint = CGPointMake(width - 20, 20), endPoint = CGPointMake(width - 5, 20);
        
        CGFloat angle = M_PI/3; // 60 degrees in radians
        // v1 = vector from startPoint to endPoint:
        CGPoint v1 = CGPointMake(endPoint.x - startPoint.x, endPoint.y - startPoint.y);
        // v2 = v1 rotated by 60 degrees:
        CGPoint v2 = CGPointMake(cosf(angle) * v1.x - sinf(angle) * v1.y,
                                 sinf(angle) * v1.x + cosf(angle) * v1.y);
        // thirdPoint = startPoint + v2:
        CGPoint thirdPoint = CGPointMake(startPoint.x + v2.x, startPoint.y + v2.y);
        
        UIBezierPath *triangle = [UIBezierPath bezierPath];
        [triangle moveToPoint:startPoint];
        [triangle addLineToPoint:endPoint];
        [triangle addLineToPoint:thirdPoint];
        [triangle closePath];
        
        CAShapeLayer *layer = [[CAShapeLayer alloc] init];
        layer.lineWidth = 1;
        layer.path = triangle.CGPath;
        layer.fillColor = [UIColor whiteColor].CGColor;
        layer.fillRule = kCAFillRuleEvenOdd;
        [self.layer addSublayer:layer];
        
        
        self.resultLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, width - 30, height)];
        self.resultLabel.textAlignment = NSTextAlignmentLeft;
        self.resultLabel.textColor = [UIColor whiteColor];
        self.resultLabel.font = [UIFont fontWithName:kFontName size:30];
        [self addSubview:self.resultLabel];
        
        self.button = [[UIButton alloc] initWithFrame:CGRectMake(10, 0, width-20, height)];
        [self.button addTarget:self action:@selector(buttonTapped) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.button];
    }
    return self;
}


-(void)buttonTapped {
    if(self.delegate) {
        [self.delegate selectViewTapped:self];
    }
}

-(void)updateSentence:(NSString *)sentence {
    self.resultLabel.text = sentence;
    [self.bottomView setHidden:YES];
}

@end
