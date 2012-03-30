//
//  RPNCalculatorViewController.m
//  RPNCalculator
//
//  Created by Michael Joyce on 3/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "RPNCalculatorViewController.h"
#import "CalculatorBrain.h"

@interface RPNCalculatorViewController()

@property (nonatomic) BOOL enteringNum;
@property (nonatomic, strong) CalculatorBrain *brain;

@end

@implementation RPNCalculatorViewController

@synthesize display;
@synthesize enteringNum;
@synthesize brain = _brain;

- (CalculatorBrain *)brain
{
    if (!_brain) _brain = [[CalculatorBrain alloc] init];
    return _brain;
}

- (IBAction)digitPressed:(UIButton *)sender 
{
    NSString *digit = [sender currentTitle];
    if (enteringNum)
    {
        self.display.text = [self.display.text stringByAppendingString:digit];
    }
    else
    {
        self.display.text = digit;
        enteringNum = YES;
    }
}

- (IBAction)enterPressed 
{
    [self.brain pushOperand:[self.display.text doubleValue]];
    self.enteringNum = NO;
}


- (IBAction)operatorPressed:(UIButton *)sender 
{
    if (enteringNum)
    {
        [self enterPressed];
    }
    
    NSString *operation = [sender currentTitle];
    double result = [self.brain performOperation:operation];
    self.display.text = [NSString stringWithFormat:@"%g", result];
}

@end
