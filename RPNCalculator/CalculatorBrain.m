//
//  CalculatorBrain.m
//  RPNCalculator
//
//  Created by Michael Joyce on 3/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CalculatorBrain.h"
#import "math.h"

@interface CalculatorBrain()
@property (nonatomic, strong) NSMutableArray *programStack;
@end

@implementation CalculatorBrain

@synthesize programStack = _programStack;

- (NSMutableArray *)programStack
{
    if (!_programStack) _programStack = [[NSMutableArray alloc] init];
    return _programStack;
}

- (id)program
{
    return [self.programStack copy];
}

+ (NSString *)descriptionOfProgram:(id)program
{
    return @"IMPLEMENT FOR HOMEWORK 2";
}

- (void)pushOperand:(double)operand
{
    [self.programStack addObject:[NSNumber numberWithDouble:operand]];
}

- (double)performOperation:(NSString *)operation
{
    [self.programStack addObject:operation];
    return [[self class] runProgram:self.programStack];
}

+ (double)popOperand:(NSMutableArray *)stack
{
    double result = 0;
    id topOfStack = [stack lastObject];
    if (topOfStack) [stack removeLastObject];
    if ([topOfStack isKindOfClass:[NSNumber class]])
    {
        result = [topOfStack doubleValue];
    }
    else if ([topOfStack isKindOfClass:[NSString class]])
    {
        NSString *operation = topOfStack;
        if ([operation isEqualToString:@"+"]) {
            result = [self popOperand:stack] + 
                     [self popOperand:stack];
        } else if ([operation isEqualToString:@"*"]) {
            result = [self popOperand:stack] * 
                     [self popOperand:stack];
        } else if ([operation isEqualToString:@"-"]) {
            double secondOperand = [self popOperand:stack];
            result = [self popOperand:stack] - secondOperand;
        } else if ([operation isEqualToString:@"/"]) {
            double divisor = [self popOperand:stack];
            if (divisor) result = [self popOperand:stack] / divisor;
        } else if ([operation isEqualToString:@"∏"]) {
            result = 3.14159265;
        } else if ([operation isEqualToString:@"e"]) {
            result = 2.71828;
        } else if ([operation isEqualToString:@"sin"]) {
            result = sin([self popOperand:stack]);
        } else if ([operation isEqualToString:@"cos"]) {
            result = cos([self popOperand:stack]);
        } else if ([operation isEqualToString:@"sqrt"]) {
            result = sqrt([self popOperand:stack]);
        } else if ([operation isEqualToString:@"log"]) {
            result = log([self popOperand:stack]);
        } else if ([operation isEqualToString:@"+/-"]) {
            result = [self popOperand:stack] * (-1.0);
        }
    }

    return result;
}
    
+ (double)runProgram:(id)program
{
    NSMutableArray *stack;
    if ([program isKindOfClass:[NSArray class]])
    {
        stack = [program mutableCopy];
    }
    return [self popOperand:stack];
}

-(void)clearState
{
    self.programStack = nil;
}

@end
