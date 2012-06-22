//
//  GraphView.m
//  RPNCalculator
//
//  Created by Michael Joyce on 5/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GraphView.h"
#import "AxesDrawer.h"

@interface GraphView()
@property (nonatomic) CGPoint origin;
@property (nonatomic) CGFloat scale;
@end

@implementation GraphView

@synthesize graphDataSource = _graphDataSource;
@synthesize drawWithDots = _drawWithDots;
@synthesize origin = _origin;
@synthesize scale = _scale;

int const DEFAULT_SCALE = 1.0;

- (void)setup
{
    self.contentMode = UIViewContentModeRedraw;
    
    // Load saved scale and origin
    self.scale = [self.graphDataSource getScale];    
    self.origin = [self.graphDataSource getOrigin]; 
}

- (void)awakeFromNib
{
    [self setup];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self setup];
    }
    return self;
}

- (BOOL)drawWithDots
{
    if (!_drawWithDots) _drawWithDots = NO;
    return _drawWithDots;
}

- (void)drawWithDots:(BOOL)value
{
    if (value != _drawWithDots)
    {
        _drawWithDots = value;
        [self setNeedsDisplay];
    }
}

- (CGPoint)origin
{
    if (CGPointEqualToPoint(_origin, CGPointZero))
    {
        CGPoint tmp;
        tmp.x = self.bounds.size.width/2;
        tmp.y = self.bounds.size.height/2;
        return tmp;
    }
    else 
    {
        return _origin;
    }
}

- (void)setOrigin:(CGPoint)origin
{
    if (!CGPointEqualToPoint(_origin, origin))
    {
        _origin = origin;
        [self setNeedsDisplay];
        [self.graphDataSource storeOrigin:origin];
    }
}

- (CGFloat)scale
{
    if (!_scale)
    {
        return DEFAULT_SCALE;
    }
    else
    {
        return _scale;
    }
}

- (void)setScale:(CGFloat)scale
{
    if (_scale != scale)
    {
        _scale = scale;
        [self setNeedsDisplay];
        [self.graphDataSource storeScale:scale];
    }
}

- (void)updateGraph
{
    [self setNeedsDisplay];
}

- (void)updateAfterRotation
{
    self.origin = CGPointZero;
    [self updateGraph];
}

- (void)pinch:(UIPinchGestureRecognizer *)gesture
{
    if ((gesture.state == UIGestureRecognizerStateChanged) ||
        (gesture.state == UIGestureRecognizerStateEnded))
    {
        self.scale *= gesture.scale;
        gesture.scale = 1;
    }
}

- (void)pan:(UIPanGestureRecognizer *)gesture
{
    if ((gesture.state == UIGestureRecognizerStateChanged) ||
        (gesture.state == UIGestureRecognizerStateEnded))
    {
        CGPoint translation = [gesture translationInView:self];
        CGPoint newOrigin;
        newOrigin.x = self.origin.x + (translation.x / 2);
        newOrigin.y = self.origin.y + (translation.y / 2);
        self.origin = newOrigin;
        [gesture setTranslation:CGPointZero inView:self];
    }
}

- (void)tripleTap:(UITapGestureRecognizer *)gesture
{
    if (gesture.state == UIGestureRecognizerStateEnded)
    {
        self.origin = [gesture locationInView:self];
    }
}

- (void)drawRect:(CGRect)rect
{   
    CGRect screenBounds;
    screenBounds.origin = CGPointZero;
    screenBounds.size = self.bounds.size;

    [[AxesDrawer class] drawAxesInRect:screenBounds originAtPoint:self.origin scale:self.scale];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetRGBStrokeColor(context, 1.0, 0.0, 0.0, 1.0);
    [[UIColor redColor] setFill];
            
    if (self.drawWithDots)
    {
        for (CGFloat i = 0; i < self.bounds.size.width; i += (1/self.contentScaleFactor))
        {
            CGFloat curX = (i - self.origin.x) / self.scale;
            CGFloat curY = self.origin.y - ([self.graphDataSource functionEval:curX] * self.scale);
            
            CGContextFillRect(context, CGRectMake(i,curY,1,1));
        }
    }
    else 
    {
        CGFloat prevX = -self.origin.x / self.scale;
        CGFloat prevY = -1 * [self.graphDataSource functionEval:prevX] * self.scale + self.origin.y;
        prevX = 0;
        
        for (CGFloat i = 0; i < self.bounds.size.width; i += (1/self.contentScaleFactor))
        {
            CGFloat curX = (i - self.origin.x) / self.scale;
            CGFloat curY = self.origin.y - ([self.graphDataSource functionEval:curX] * self.scale);
            
            CGContextMoveToPoint(context, prevX, prevY);
            CGContextAddLineToPoint(context, i, curY);
            CGContextStrokePath(context);
            
            prevX = i;
            prevY = curY;
        }
    }
}

@end