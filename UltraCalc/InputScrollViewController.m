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
    rect.size.width = (size.width > minWidth) ? size.width  :  minWidth;
    inputLabel.frame = rect;
    inputLabel.text = string;
    
    CGSize inputSize = inputLabel.bounds.size;;
    //size.width += 300;
    scrollView.contentSize = inputSize;

    CGRect visibleRect = rect;
    visibleRect.origin.x += rect.size.width - minWidth;
    
    
    [scrollView scrollRectToVisible:visibleRect animated:YES];
}

-(NSString*)text
{
    return inputLabel.text;
}


-(void)initLabel
{
    font = [UIFont fontWithName:@"Eurostile" size:20];
    [inputLabel setFont:font];
    
    inputLabel.shadowColor = nil;
    inputLabel.shadowOffset = CGSizeMake(0.0f, 2.0f);
    inputLabel.shadowColor = [UIColor colorWithRed:158/255.0 green:1 blue:1 alpha:0.7];  
    inputLabel.shadowBlur = 5.0f;
    
    CGRect rect= inputLabel.frame;
    minWidth = rect.size.width;

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initLabel];
    
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
