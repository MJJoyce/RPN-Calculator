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

@property (nonatomic) BOOL enteringNum;                 // Flag that dictates whether a number is being enterered
@property (nonatomic, strong) CalculatorBrain *brain;   

@end

@implementation RPNCalculatorViewController

@synthesize display = _display;
@synthesize enteringNum = _enteringNum;
@synthesize brain = _brain;
@synthesize history = _history;

- (CalculatorBrain *)brain
{
    if (!_brain) _brain = [[CalculatorBrain alloc] init];
    return _brain;
}

- (IBAction)decimalPressed 
{
    if (self.enteringNum)
    {
        // Check if the current value has a decimal point already.
        if ([self.display.text rangeOfString:@"."].location == NSNotFound)
        {
            self.display.text = [self.display.text stringByAppendingString:@"."];
        }
    }
    else // If not currently entering a number
    {
        self.display.text = @"0.";
        self.enteringNum = YES;
    }
}

- (IBAction)digitPressed:(UIButton *)sender 
{
    NSString *digit = [sender currentTitle];
    if (self.enteringNum)
    {
        self.display.text = [self.display.text stringByAppendingString:digit];
    }
    else
    {
        self.display.text = digit;
        self.enteringNum = YES;
    }
}

- (IBAction)enterPressed 
{
    [self.brain pushOperand:[self.display.text doubleValue]];
    self.enteringNum = NO;
    self.history.text = [self.history.text stringByAppendingString:[NSString stringWithFormat:@"%@ ", self.display.text]];
}


- (IBAction)operatorPressed:(UIButton *)sender 
{
    if (self.enteringNum)
    {
        [self enterPressed];
    }
    
    NSString *operation = [sender currentTitle];
    self.history.text = [self.history.text stringByAppendingString:[NSString stringWithFormat:@"%@ ", operation]]; //stringByAppendingString:operation];
    double result = [self.brain performOperation:operation];
    self.display.text = [NSString stringWithFormat:@"%g", result];
}

- (IBAction)clearPressed 
{
    [self.brain clearState];
    self.enteringNum = NO;
    self.history.text = @"";
    self.display.text = @"0";
}

/* This was automatically entered by the IDE. Don't know if it is needed
- (void)viewDidUnload {
    [self setHistory:nil];
    [self setHistory:nil];
    [super viewDidUnload];
}
 */
@end
