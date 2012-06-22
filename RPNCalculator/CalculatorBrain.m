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

+ (NSMutableArray *)substituteVariableValues:(NSDictionary *)variableValues inProgram:(NSMutableArray *)program;
+ (NSString *)descriptionOfTopOfStack:(NSMutableArray *)program;
+ (BOOL)isOperator:(NSString *)inputString;
+ (BOOL)isSingleOperandOp:(NSString *)op;
+ (BOOL)isMultiOperandOp:(NSString *)op;

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
    NSMutableArray* progStack;
    if ([program isKindOfClass:[NSArray class]]) progStack = [program mutableCopy];
    else if ([program isKindOfClass:[NSMutableArray class]]) progStack = program;

    // Ensure there is something on the stack to process...
    id topOfStack = [progStack lastObject];
    NSString* retString = @"";
    if (topOfStack)
        retString = [[self class] descriptionOfTopOfStack:progStack];
    
    // If there is still content on the stack, then process it as separate from the last expression
    if ([progStack lastObject])
    {
        NSString* rest = [[self class] descriptionOfProgram:progStack];
        retString = [rest stringByAppendingFormat:@", %@", retString];
    }
    
    return retString;
}

+ (NSString *)descriptionOfTopOfStack:(NSMutableArray *)program
{
    NSString* retString;
    id topOfStack = [program lastObject];
    if (topOfStack) [program removeLastObject];
    
    // If the top of the stack is a string and an operator
    if ([topOfStack isKindOfClass:[NSString class]] && [[self class] isOperator:topOfStack])
    {
        // Single operand ops use function notation such as sin(5 + 1)
        if ([[self class] isSingleOperandOp:topOfStack])
        {
            NSString* stmt = [[self class] descriptionOfTopOfStack:program];
            retString = [@"" stringByAppendingFormat:@"%@(%@)", topOfStack, stmt];
        }
        // Binary Operations include +, -, /, *
        else if ([[self class] isMultiOperandOp:topOfStack])
        {
            NSString* rStmt = [[self class] descriptionOfTopOfStack:program];
            NSString* lStmt = @"0";
            
            if ([program lastObject])
            {
                lStmt = [[self class] descriptionOfTopOfStack:program];
            }
            retString = [@"" stringByAppendingFormat:@"(%@ %@ %@)", lStmt, topOfStack, rStmt];
        }
        // It is a single operand operator (like PI) or a variable
        else 
        {
            retString = [@"" stringByAppendingFormat:@"%@", topOfStack];
        }
    }
    // If it isn't an NSString, then it must be a NSNumber
    else 
    {
        retString = [@"" stringByAppendingFormat:@"%@", topOfStack];
    }
    
    return retString;
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

- (double)performOperation:(NSString *)operation usingVariableValues:(NSDictionary *)variableValues
{
    [self.programStack addObject:operation];
    return [[self class] runProgram:self.programStack usingVariableValues:variableValues];
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

+ (BOOL)isOperator:(NSString *)inputString
{
    BOOL isOperator = false;
    
    if ([inputString isEqualToString:@"+"] || [inputString isEqualToString:@"-"] || [inputString isEqualToString:@"*"] || [inputString isEqualToString:@"/"] || [inputString isEqualToString:@"∏"] || [inputString isEqualToString:@"e"] || [inputString isEqualToString:@"sin"] || [inputString isEqualToString:@"cos"] || [inputString isEqualToString:@"sqrt"] || [inputString isEqualToString:@"log"] || [inputString isEqualToString:@"+/-"])
    {
        isOperator = true;
    }
    
    return isOperator;
}

+ (BOOL)isSingleOperandOp:(NSString *)op
{
    BOOL isSingleOperandOp = false;
    
    if ([op isEqualToString:@"sin"] || [op isEqualToString:@"cos"] || [op isEqualToString:@"sqrt"] || [op isEqualToString:@"log"])
    {
        isSingleOperandOp = true;
    }
    
    return isSingleOperandOp;
}

+ (BOOL)isMultiOperandOp:(NSString *)op
{    
    BOOL isMultiOperandOp = false;
    
    if ([op isEqualToString:@"+"] || [op isEqualToString:@"-"] || [op isEqualToString:@"*"] || [op isEqualToString:@"/"])
    {
        isMultiOperandOp = true;
    }
    
    return isMultiOperandOp;
}

+ (NSMutableArray *)substituteVariableValues:(NSDictionary *)variableValues inProgram:(NSMutableArray *)program
{
    NSUInteger i;
    for (i = 0; i < [program count]; i++) 
    {
        if ([[program objectAtIndex:i] isKindOfClass:[NSString class]] && ![self isOperator:[program objectAtIndex:i]])
        {
            NSString* topOfStack = [program objectAtIndex:i];
            
            if ([variableValues objectForKey:topOfStack])
            {
                [program replaceObjectAtIndex:i withObject:[variableValues objectForKey:topOfStack]];
            }
            else
            {
                [program replaceObjectAtIndex:i withObject:[[NSNumber alloc] initWithDouble:0]];
            }
        }
    }
    
    return program;
}
    
+ (double)runProgram:(id)program
{
    NSMutableArray* stack;
    if ([program isKindOfClass:[NSArray class]])
    {
        stack = [program mutableCopy];
    }
    stack = [self substituteVariableValues:nil inProgram:stack];
    return [self popOperand:stack];
}

+ (double)runProgram:(id)program usingVariableValues:(NSDictionary *)variableValues
{
    NSMutableArray* stack;
    if ([program isKindOfClass:[NSArray class]])
    {
        stack = [program mutableCopy];
    }
    stack = [self substituteVariableValues:variableValues inProgram:stack];
        
    return [self popOperand:stack];
}

- (void)pushVariable:(NSString *)variable
{
    [self.programStack addObject:variable];
}

- (void)pushOperator:(NSString *)op
{
    [self.programStack addObject:op];
}

- (void)popProgramStack
{
    id tmp = [self.programStack lastObject];
    if (tmp) [self.programStack removeLastObject];
}

-(void)clearState
{
    self.programStack = nil;
}

@end
