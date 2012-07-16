//
//  DragNumberViewController.m
//  UltraCalc
//
//  Created by Song  on 12-7-16.
//
//

#import "DragNumberViewController.h"

#define degreesToRadians(x) (M_PI * x / 180.0)

@interface DragNumberViewController ()

@end

@implementation DragNumberViewController
@synthesize resultLabel;
@synthesize background;
@synthesize dragingShadow;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //[self setOnDrag:NO];
    resultLabel.text = text;
    CGAffineTransform trans = CGAffineTransformMakeRotation(degreesToRadians(3.2));
    
    self.dragingShadow.transform = trans;
    
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

-(void)setOnDrag:(BOOL)draging
{
    if(draging)
    {
        self.dragingShadow.hidden = NO;
        
        CGAffineTransform trans = CGAffineTransformMakeRotation(degreesToRadians(-3.2));
        
        self.view.transform = trans;
        
    }
    else
    {
        self.dragingShadow.hidden = YES;
        
        CGAffineTransform trans = CGAffineTransformMakeRotation(0);
        
        self.view.transform = trans;
    }
}

-(void)setResult:(NSString*)str
{
    text = str;
}

- (void) touchesBegan:(NSSet *) touches withEvent:(UIEvent *) event
{
    NSLog(@"touch begin");
    //CGPoint point = [[touches anyObject] locationInView:self];
    //UITouch *touch = [[event allTouches] anyObject];
    //CGPoint location = [touch locationInView:touch.view];
    
}


- (void) touchesMoved:(NSSet *) touches withEvent:(UIEvent *) event
{
    NSLog(@"touch move");

    UITouch *touch = [[event allTouches] anyObject];
    CGPoint location = [touch locationInView:self.view.superview];
    
    self.view.center = location;
    
    [self setOnDrag:YES];
}


- (void) touchesEnded:(NSSet *) touches withEvent:(UIEvent *) event
{
	NSLog(@"touch end");
    //UITouch *touch = [[event touchesForView:self.view] anyObject];
    //CGPoint location = [touch locationInView:touch.view];
    
    [self.view removeFromSuperview];
}


- (void)viewDidUnload {
    [self setResultLabel:nil];
    [self setBackground:nil];
    [self setDragingShadow:nil];
    [super viewDidUnload];
}
@end
