//
//  RPNCalculatorViewController.h
//  RPNCalculator
//
//  Created by Michael Joyce on 3/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RPNCalculatorViewController : UIViewController

// The UILabel where the currently entered number or result is displayed.
@property (weak, nonatomic) IBOutlet UILabel *display;

// The UILabel that keeps track of buttons pressed on the calculator.
@property (weak, nonatomic) IBOutlet UILabel *history;

// Space for output of all the currently set variables.
@property (weak, nonatomic) IBOutlet UILabel *varDisplay;

@end
