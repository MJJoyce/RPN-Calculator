//
//  GraphViewController.h
//  RPNCalculator
//
//  Created by Michael Joyce on 5/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GraphViewControllerBrainDelegate <NSObject>

- (NSString *)getFunctionPrintout:(NSArray *)function;
- (double)runProgramForPoint:(NSArray *)program withXValue:(double)xValue;

@end

@interface GraphViewController : UIViewController <UISplitViewControllerDelegate>

@property (nonatomic) NSArray* function;
@property (nonatomic, strong) IBOutlet id <GraphViewControllerBrainDelegate> calculatorBrainDelegate;

@end