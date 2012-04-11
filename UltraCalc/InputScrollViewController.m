//
//  InputScrollViewController.m
//  UltraCalc
//
//  Created by Song  on 12-4-11.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "InputScrollViewController.h"

@interface InputScrollViewController ()

@end

@implementation InputScrollViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}



-(void)setText:(NSString*)string
{
   
    UIFont *myFont = font;
    // Get the width of a string ...
    CGSize size = [string sizeWithFont:myFont];
    
    CGRect rect= inputLabel.frame;
    rect.size.width = 0;
    
    inputLabel.text = @"0123456789987654321001234567899876543210";
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    font = [UIFont fontWithName:@"Eurostile" size:38];
    [inputLabel setFont:font];
    
    
    inputLabel.text = @"0123456789987654321001234567899876543210";
    
    
    CGSize size = inputLabel.bounds.size;;
    size.width += 300;
    scrollView.contentSize = size;
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    scrollView = nil;
    inputLabel = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

@end
