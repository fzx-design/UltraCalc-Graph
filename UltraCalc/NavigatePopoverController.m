//
//  NavigatePopoverController.m
//  UltraCalc
//
//  Created by Song  on 12-7-3.
//
//

#import "NavigatePopoverController.h"

@interface NavigatePopoverController ()

@end

@implementation NavigatePopoverController
@synthesize centerButton;
@synthesize leftButton;
@synthesize rightButton;

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


-(void)setModeWithBlankCount:(int)blankCount andCurrentPosition:(int)cursor
{
    if(blankCount == 1)
    {
        [centerButton setTitle:@"Done" forState:UIControlStateNormal];
        [centerButton setTitle:@"Done" forState:UIControlStateHighlighted];
        
        [leftButton setEnabled:NO];
        [rightButton setEnabled:NO];
    }
    else if(blankCount > 1)
    {
        if(cursor < blankCount)
        {
            [centerButton setTitle:@"Cancel" forState:UIControlStateNormal];
            [centerButton setTitle:@"Cancel" forState:UIControlStateHighlighted];
            
            if(cursor != 1)
            {
                [leftButton setEnabled:YES];
            }
            else
            {
                [leftButton setEnabled:NO];
            }
            [rightButton setEnabled:YES];
        }
        else
        {
            [centerButton setTitle:@"Done" forState:UIControlStateNormal];
            [centerButton setTitle:@"Done" forState:UIControlStateHighlighted];
            
            [leftButton setEnabled:YES];
            [rightButton setEnabled:NO];
        }
    }
    position = @(cursor);
    mode = @(blankCount);
}


- (void)viewDidUnload {
    [self setCenterButton:nil];
    [self setLeftButton:nil];
    [self setRightButton:nil];
    [super viewDidUnload];
}


-(IBAction)leftButtonPressed:(id)sender
{
    [self.delegate leftButtonPressed:sender];
}

-(IBAction)rightButtonPressed:(id)sender
{
    [self.delegate rightButtonPressed:sender];
}

-(IBAction)centerButtonPressed:(id)sender
{
   
    [self.delegate centerButtonPressed: @([mode intValue] * 10 + [position intValue])];
}



@end
