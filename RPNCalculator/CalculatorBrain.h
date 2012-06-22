//
//  CalculatorBrain.h
//  RPNCalculator
//
//  Created by Michael Joyce on 3/29/12.
//
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CalculatorBrain : NSObject

- (void)pushOperand:(double)operand;
- (double)performOperation:(NSString *)operation;
- (void)clearState;

// Added for Homework 2

@property (nonatomic, readonly) id program;

- (double)performOperation:(NSString *)operation usingVariableValues:(NSDictionary *)variableValues;
- (void)pushVariable:(NSString *)variable;
- (void)pushOperator:(NSString *)op;
- (void)popProgramStack;

+ (double)popOperand:(NSMutableArray *)stack;
+ (NSString *)descriptionOfProgram:(id)program;
+ (double)runProgram:(id)program;
+ (double)runProgram:(id)program usingVariableValues:(NSDictionary *)variableValues;

@end
