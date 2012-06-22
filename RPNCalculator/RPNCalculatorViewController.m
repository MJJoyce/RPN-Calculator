//
//  RPNCalculatorViewController.m
//  RPNCalculator
//
//  Created by Michael Joyce on 3/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "RPNCalculatorViewController.h"
#import "CalculatorBrain.h"
#import "GraphViewController.h"

@interface RPNCalculatorViewController()

@property (nonatomic) BOOL enteringNum;
@property (nonatomic, strong) CalculatorBrain *brain;
@property (strong, nonatomic) NSMutableDictionary* variables;

@end

@implementation RPNCalculatorViewController

@synthesize display = _display;
@synthesize enteringNum = _enteringNum;
@synthesize brain = _brain;
@synthesize history = _history;
@synthesize  variables = _variables;

- (CalculatorBrain *)brain
{
    if (!_brain) _brain = [[CalculatorBrain alloc] init];
    return _brain;
}

-(NSDictionary* )variables
{
    if (!_variables) _variables = [[NSMutableDictionary alloc] init];
    return _variables;
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

- (IBAction)backspacePressed 
{
    // When the user is entering a number, backspace should delete characters from the display.
    if (self.enteringNum)
    {
        self.display.text = [self.display.text substringToIndex:[self.display.text length] - 1];
          
        // If the user deleted everything from the display, we're no longer entering a number.
        if (([self.display.text length] == 0) || [self.display.text isEqualToString:@"-"])
        {
            self.enteringNum = NO;
        }
    }
    // Remove the top item from the stack if the user isn't entering a number
    else
    {
        [self.brain popProgramStack];
    }
    
    // If not entering a number, the display should hold the result of running the current program
    if (self.enteringNum == NO)
    {
        double tmp = [[self.brain class] runProgram:self.brain.program usingVariableValues:self.variables];
        self.display.text = @"0";
        if (tmp)
            self.display.text = [@"" stringByAppendingFormat:@"%g", tmp];
    }
        
    self.history.text = [[self.brain class] descriptionOfProgram:self.brain.program];
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
    self.history.text = [[self.brain class] descriptionOfProgram:[self.brain.program mutableCopy]];
}

- (IBAction)operatorPressed:(UIButton *)sender 
{
    if (self.enteringNum)
    {
        [self enterPressed];
    }
    
    // Push the operator and update the HUD by running the current program
    [self.brain pushOperator:[sender currentTitle]];
    self.history.text = [[self.brain class] descriptionOfProgram:self.brain.program];
    double result = [[self.brain class] runProgram:self.brain.program usingVariableValues:self.variables];
    self.display.text = [NSString stringWithFormat:@"%g", result];
}

- (IBAction)negativePressed:(UIButton *)sender 
{
    if (self.enteringNum)
    {
        // If the current number being entered is negative
        if ([self.display.text rangeOfString:@"-"].location != NSNotFound)
        {
            self.display.text = [self.display.text stringByReplacingOccurrencesOfString:@"-" withString:@""];
        }
        // Otherwise, add the negation
        else
        {
            self.display.text = [@"-" stringByAppendingString:self.display.text];
        }
    }
    else
    {
        [self operatorPressed:sender];
    }
}

- (IBAction)clearPressed 
{
    [self.brain clearState];
    self.enteringNum = NO;
    self.history.text = @"";
    self.display.text = @"0";
    self.variables = nil;
}

- (IBAction)variablePressed:(UIButton *)sender 
{
    if (!self.enteringNum)
    {
        NSString* button = [sender currentTitle];
        [self.brain pushVariable:button];
        self.history.text = [[self.brain class] descriptionOfProgram:self.brain.program];
    }
}

- (IBAction)graphPressed 
{
    // Check that we're in an iPad split view and that the slave controller is a GraphViewController
    GraphViewController* graphController = [self.splitViewController.viewControllers lastObject];
    if (graphController)
    {
        graphController.calculatorBrainDelegate = self;
        [graphController setFunction:self.brain.program];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"graphingSegue"])
    {
        GraphViewController* tmp = segue.destinationViewController;
        [tmp setFunction:self.brain.program];
        tmp.calculatorBrainDelegate = self;
    }
}

// Delegate functions for GraphViewControllerBrainDelegate
- (double)runProgramForPoint:(NSArray *)program withXValue:(double)xValue
{    
    NSNumber* numberValue = [[NSNumber alloc] initWithDouble:xValue];
    NSDictionary* values = [NSDictionary dictionaryWithObjectsAndKeys:numberValue, @"x", nil];
    double result = [[self.brain class] runProgram:program usingVariableValues:values];
    return result;
}

- (NSString *)getFunctionPrintout:(NSArray *)function
{    
    return [[self.brain class] descriptionOfProgram:function];
} 

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return YES;
}
@end
