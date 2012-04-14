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


-(void)showRectFromCharIndex:(int)startIndex toIndex:(int)endIndex
{
    CGRect rect;
    
    UIFont *myFont = font;
    // Get the width of a string ...
    NSString *shorterString = [inputLabel.text stringByPaddingToLength:startIndex withString:@"                  " startingAtIndex:0];
    
    NSString *longerString = [inputLabel.text stringByPaddingToLength:endIndex withString:@"                           " startingAtIndex:0];
    
    
    CGSize shorterSize = [shorterString sizeWithFont:myFont];
    CGSize longerSize = [longerString sizeWithFont:myFont];
    
    float length = longerSize.width - shorterSize.width;
    
    
    float offsetX = 4.0f;
    float offsetY = 6.0f;
    
    UIView *view = [[UIView alloc] initWithFrame:inputLabel.frame];
    
    UIImageView *left = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"screen_bracket_left.png"]];
    rect = left.frame;

    
    float labelTextWidth = [inputLabel.text sizeWithFont:myFont].width;
    
    if(labelTextWidth < minWidth)
    {
        rect.origin.x = minWidth - (labelTextWidth - shorterSize.width) - offsetX ;
        //rect.origin.x + labelTextWidth = minWidht
    }
    else {
        rect.origin.x = shorterSize.width - offsetX;
    }
    rect.origin.y += offsetY;
    left.frame = rect;
    
    
    UIImageView *right = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"screen_bracket_right.png"]];
    rect = right.frame;
    if(labelTextWidth < minWidth)
    {
        rect.origin.x = minWidth - (labelTextWidth - shorterSize.width) + length  - offsetX;
    }
    else {
        rect.origin.x = longerSize.width - offsetX;
    }
    rect.origin.y += offsetY;
    right.frame = rect;
    
    UIImageView *body = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"screen_bracket_body.png"]];
    rect = left.frame;
    rect.origin.x += left.frame.size.width;
    rect.size.width = length - right.frame.size.width;
    body.frame = rect;
    
    view.userInteractionEnabled = NO;
    
    [scrollView addSubview:view];
    [view addSubview:left];
    [view addSubview:right];
    [view addSubview:body];
    [rectArray addObject:view];
    
    [scrollView bringSubviewToFront:inputLabel]; 
}

-(void)clearAllRect
{
    for(UIView* view in rectArray)
    {
        [view removeFromSuperview];
    }
    [rectArray removeAllObjects];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initLabel];
    
    rectArray = [NSMutableArray array];

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
