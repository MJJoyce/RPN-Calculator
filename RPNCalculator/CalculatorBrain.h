//
//  CalculatorBrain.h
//  RPNCalculator
//
//  Created by Michael Joyce on 3/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CalculatorBrain : NSObject

- (double)popOperand;
- (void)pushOperand:(double)operand;
- (double)performOperation:(NSString *)operation;

@end
