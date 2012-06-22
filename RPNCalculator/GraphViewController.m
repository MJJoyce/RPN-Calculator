//
//  GraphViewController.m
//  RPNCalculator
//
//  Created by Michael Joyce on 5/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GraphViewController.h"
#import "GraphView.h"

@interface GraphViewController() <GraphViewDelegate>
@property (nonatomic, strong) IBOutlet GraphView *graphView;
@property (nonatomic, weak) IBOutlet UILabel *functionDrawLabel;
@property (nonatomic, weak) NSUserDefaults *userDefaults;
@property (weak, nonatomic) IBOutlet UIToolbar *toolbar;
@end

@implementation GraphViewController

@synthesize function = _function;
@synthesize graphView = _graphView;
@synthesize calculatorBrainDelegate = _calculatorBrainDelegate;
@synthesize functionDrawLabel = _functionDrawLabel;
@synthesize userDefaults = _userDefaults;
@synthesize toolbar = _toolbar;

- (void)awakeFromNib
{
    self.splitViewController.delegate = self;
}

- (void)setFunction:(NSArray *)function
{
    _function = function;
    [self.graphView setNeedsDisplay];
    
    if (self.functionDrawLabel && _function && self.calculatorBrainDelegate)
    {
        self.functionDrawLabel.text = [@"y = " stringByAppendingString:[self.calculatorBrainDelegate getFunctionPrintout:_function]];
    }
}

- (void)setGraphView:(GraphView *)graphView
{    
    // If we're setting the graphview, it's also a good time to process the function for later display.
    if (self.function)
    {
        if (self.splitViewController)
        {
            self.functionDrawLabel.text = [@"y = " stringByAppendingString:[self.calculatorBrainDelegate getFunctionPrintout:self.function]];
        }
        else
        {
            self.navigationItem.title = [@"y = " stringByAppendingString:[self.calculatorBrainDelegate getFunctionPrintout:self.function]];
        }
    }
    
    _graphView = graphView;
    [self.graphView addGestureRecognizer:[[UIPinchGestureRecognizer alloc] initWithTarget:self.graphView action:@selector(pinch:)]];
    [self.graphView addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self.graphView action:@selector(pan:)]];
    UITapGestureRecognizer* tripleTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self.graphView action:@selector(tripleTap:)];
    tripleTapGesture.numberOfTapsRequired = 3;
    [self.graphView addGestureRecognizer:tripleTapGesture];

    _graphView.graphDataSource = self;
}

- (IBAction)drawModeToggle:(UISwitch *)sender 
{
    self.graphView.drawWithDots = sender.on;
    [self.graphView updateGraph];
}

- (NSUserDefaults *)userDefaults
{
    if (!_userDefaults) _userDefaults = [NSUserDefaults standardUserDefaults];
    return _userDefaults;
}

- (double)functionEval:(double)xCoordinate
{    
    return [self.calculatorBrainDelegate runProgramForPoint:self.function withXValue:xCoordinate];
}

- (double)getScale
{
    return [self.userDefaults doubleForKey:@"scale"];
}

- (void)storeScale:(double)scale
{
    [self.userDefaults setDouble:scale forKey:@"scale"];
    [self.userDefaults synchronize];
}

- (CGPoint)getOrigin
{
    return CGPointFromString([self.userDefaults stringForKey:@"origin"]);
}

- (void)storeOrigin:(CGPoint)origin
{
    [self.userDefaults setObject:NSStringFromCGPoint(origin) forKey:@"origin"];
    [self.userDefaults synchronize];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return YES;
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    [self.graphView updateAfterRotation];
}

- (void)splitViewController:(UISplitViewController *)svc 
     willHideViewController:(UIViewController *)aViewController
          withBarButtonItem:(UIBarButtonItem *)barButtonItem 
       forPopoverController:(UIPopoverController *)pc
{
    barButtonItem.title = @"Calculator";
    NSMutableArray *toolbarItems = [self.toolbar.items mutableCopy];
    [toolbarItems insertObject:barButtonItem atIndex:0];
    self.toolbar.items = toolbarItems;
}

- (BOOL)splitViewController:(UISplitViewController *)svc 
   shouldHideViewController:(UIViewController *)vc 
              inOrientation:(UIInterfaceOrientation)orientation
{
    return UIInterfaceOrientationIsPortrait(orientation);
}

- (void)splitViewController:(UISplitViewController *)svc 
     willShowViewController:(UIViewController *)aViewController 
  invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    NSMutableArray *toolbarItems = [self.toolbar.items mutableCopy];
    [toolbarItems removeObject:barButtonItem];
    self.toolbar.items = toolbarItems;
}

- (void)viewDidUnload {
    [self setToolbar:nil];
    [super viewDidUnload];
}
@end