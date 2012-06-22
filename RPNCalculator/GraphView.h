//
//  GraphView.h
//  RPNCalculator
//
//  Created by Michael Joyce on 5/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GraphViewDelegate <NSObject>
- (double)functionEval:(double)xCoordinate;
- (double)getScale;
- (void)storeScale:(double)scale;
- (CGPoint)getOrigin;
- (void)storeOrigin:(CGPoint)origin;
@end

@interface GraphView : UIView 

@property (nonatomic, weak) IBOutlet id <GraphViewDelegate> graphDataSource;
@property (nonatomic) BOOL drawWithDots;
- (void)updateGraph;
- (void)updateAfterRotation;

@end