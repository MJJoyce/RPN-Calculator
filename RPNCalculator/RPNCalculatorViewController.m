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
// Dictionary for holding the values of the variables
@property (strong, nonatomic) NSMutableDictionary* variables;

- (void)updateVariableDisplay:(NSDictionary *)variables;

@end

@implementation RPNCalculatorViewController

@synthesize display = _display;
@synthesize enteringNum = _enteringNum;
@synthesize brain = _brain;
@synthesize history = _history;
@synthesize varDisplay = _varDisplay;
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
          
        // If the user deleted everything from the display...
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
    self.varDisplay.text = @"";
}

- (IBAction)variablePressed:(UIButton *)sender 
{
    if (!self.enteringNum)
    {
        NSString* button = [sender currentTitle];
        
        // If there is a value stored for the button that was pressed...
        if ([self.variables objectForKey:button])
        {
            // Push the variable to the program and update the history display.
            [self.brain pushVariable:button];
            self.history.text = [[self.brain class] descriptionOfProgram:self.brain.program];
        }
        // Else there wasn't a value stored for the variable...
        else 
        {
            // Use the current top of the stack as the value.
            NSNumber* value = [[NSNumber alloc] initWithDouble:[self.display.text doubleValue]];
            [self.variables setObject:value forKey:button];
            [self updateVariableDisplay:[self.variables copy]];
        }
    }
}

- (IBAction)insertTestVars:(UIButton *)sender 
{
    NSString* text = [sender currentTitle];
    
    if ([text isEqualToString:@"Test Vars 1"])
    {
        NSDictionary* tmp = [NSDictionary dictionaryWithObjectsAndKeys:[[NSNumber alloc] initWithInt:5], @"x", [[NSNumber alloc] initWithDouble:10.5], @"y", nil];
        self.variables = [tmp mutableCopy];
    }
    else // Test Vars 2 pressed
    {
        // Just setting this to nil for testing purposes per homework instructions.
        self.variables = nil;
    }
    
    // Update the UI after changing the variable values.
    [self updateVariableDisplay:self.variables];
    double result = [[self.brain class] runProgram:self.brain.program usingVariableValues:self.variables];
    self.display.text = [@"" stringByAppendingFormat:@"%g", result];
    self.history.text = [[self.brain class] descriptionOfProgram:self.brain.program];

}

- (void)updateVariableDisplay:(NSDictionary *)variables
{
    self.varDisplay.text = @"";
    
    for (id obj in [variables allKeys])
    {
        self.varDisplay.text = [self.varDisplay.text stringByAppendingFormat:@"%@ = %@ ", obj, [variables objectForKey:obj]];
    }
}
@end
