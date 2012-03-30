//
//  CalculatorBrain.m
//  RPNCalculator
//
//  Created by Michael Joyce on 3/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CalculatorBrain.h"

@interface CalculatorBrain()
@property (nonatomic, strong) NSMutableArray *operandStack;
@end

@implementation CalculatorBrain

@synthesize operandStack = _operandStack;

- (NSMutableArray *)operandStack
{
    if (!_operandStack) _operandStack = [[NSMutableArray alloc] init];
    return _operandStack;
}

- (double)popOperand
{
    NSNumber *operandObj = [self.operandStack lastObject];
    if (operandObj) [self.operandStack removeLastObject];
    return [operandObj doubleValue];
}

- (void)pushOperand:(double)operand
{
    NSNumber *operandObj = [NSNumber numberWithDouble:operand];
    [self.operandStack addObject:operandObj];
}

-(double)performOperation:(NSString *)operation
{
    double result = 0;
    
    if ([operation isEqualToString:@"+"])
    {
        result = [self popOperand] + [self popOperand];
    }
    else if ([operation isEqualToString:@"*"])
    {
        result = [self popOperand] * [self popOperand];
    }
    else if ([operation isEqualToString:@"-"])
    {
        double secondOperand = [self popOperand];
        result = [self popOperand] - secondOperand;
    }
    else if ([operation isEqualToString:@"/"])
    {
        double divisor = [self popOperand];
        if (divisor) result = [self popOperand] / divisor;
    }
    
    [self pushOperand:result];
    
    return result;
}

@end
