//
//  MultipleButtonViewController.m
//  touchTest
//
//  Created by Song  on 12-3-27.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "MultipleButtonViewController.h"

@interface MultipleButtonViewController ()

@end

@implementation MultipleButtonViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


-(void)setButton:(UIButton*)btn attributeFromDictionary:(NSDictionary*)dictionary
{
    NSString *normalPic = [dictionary objectForKey:@"normal"];
    UIImage *normal = [UIImage imageNamed:normalPic];
    [btn setImage:normal forState:UIControlStateNormal];
    NSString *highlightPic = [dictionary objectForKey:@"highlight"];
    [btn setImage:[UIImage imageNamed:highlightPic] forState:UIControlStateHighlighted];
    
    [btn setBackgroundImage:[UIImage imageNamed:@"button_hover.png"] forState:UIControlStateHighlighted];
}

-(void)updateViewContent
{
    for(int i = 0; i < 3; i ++)
    {
        NSDictionary *dict = [datasource MultipleButton:self ButtonAttributeAtIndex:i];
        if(i == 0)
        {
            [self setButton:mainBtn attributeFromDictionary:dict];
        }
        else if(i == 1)
        {
            [self setButton:appendixBtn1 attributeFromDictionary:dict];
        }
        else if(i == 2)
        {
            [self setButton:appendixBtn2 attributeFromDictionary:dict];
        }
    }

}


-(void)setDataSource:(id<MultipleButtonDataSource>) source
{
    datasource = source;
}

-(void)showOtherBtn
{
    background.hidden = NO;
    appendixBtn2.hidden = NO;
    appendixBtn1.hidden = NO;
    
    [[[self.view superview] superview] bringSubviewToFront:[self.view superview]];
}

-(void)dismissOtherBtn
{
    background.hidden = YES;
    appendixBtn2.hidden = YES;
    appendixBtn1.hidden = YES;
    
    [mainBtn setHighlighted:NO];
    [appendixBtn1 setHighlighted:NO];
    [appendixBtn2 setHighlighted:NO];
    
    if([datasource MultipleButtonNeedSendBackAfterTouch:self])[[[self.view superview] superview] sendSubviewToBack:[self.view superview]];
}


-(BOOL)changeTouchStatusWithLocation:(CGPoint) location
{
    [mainBtn setHighlighted:NO];
    [appendixBtn1 setHighlighted:NO];
    [appendixBtn2 setHighlighted:NO];
    
    BOOL result = NO;
    
    if(CGRectContainsPoint(mainBtn.frame, location))
    {
        [mainBtn setHighlighted:YES];
        result = YES;
    }
    else if(CGRectContainsPoint(appendixBtn1.frame, location))
    {
        [appendixBtn1 setHighlighted:YES];
        result = YES;
    }
    else if(CGRectContainsPoint(appendixBtn2.frame, location))
    {
        [appendixBtn2 setHighlighted:YES];
        result = YES;
    }
    return result;
}

-(BOOL)shouldRespondWhenTouchAtPosition:(CGPoint)location
{
    if(CGRectContainsPoint(mainBtn.frame, location))
    {
        [mainBtn setHighlighted:YES];
        return YES;
    }
    return NO;
}


-(NSString*)getIdentiferAtIndex:(int)index
{
    NSDictionary *dict = [datasource MultipleButton:self ButtonAttributeAtIndex:index];
    return [dict objectForKey:@"id"];
}

-(void)doPressedStuff:(CGPoint) location
{
    if(CGRectContainsPoint(mainBtn.frame, location))
    {
        //[mainBtn setHighlighted:YES];
        NSLog(@"no0 button pressed");
        [datasource pressedButtonWithIdentifier:[self getIdentiferAtIndex:0]];
    }
    else if(CGRectContainsPoint(appendixBtn1.frame, location))
    {
        //[appendixBtn1 setHighlighted:YES];
        NSLog(@"no1 button pressed");
        [datasource pressedButtonWithIdentifier:[self getIdentiferAtIndex:1]];
        
    }
    else if(CGRectContainsPoint(appendixBtn2.frame, location))
    {
        //[appendixBtn2 setHighlighted:YES];
        NSLog(@"no2 button pressed");
        [datasource pressedButtonWithIdentifier:[self getIdentiferAtIndex:2]];
    }
    else {
        NSLog(@"nothing pressed");
    }
}



- (void) touchesBegan:(NSSet *) touches withEvent:(UIEvent *) event
{
    NSLog(@"touch begin");
    //CGPoint point = [[touches anyObject] locationInView:self];
    UITouch *touch = [[event touchesForView:self.view] anyObject];
    CGPoint location = [touch locationInView:touch.view];
    
    shouldInteractThisTouch = [self shouldRespondWhenTouchAtPosition:location];
    if(!shouldInteractThisTouch)
        return;
    
    [self showOtherBtn];
	[self changeTouchStatusWithLocation:location];
}


- (void) touchesMoved:(NSSet *) touches withEvent:(UIEvent *) event
{
    NSLog(@"touch move");
    if(!shouldInteractThisTouch)
        return;
    UITouch *touch = [[event touchesForView:self.view] anyObject];
    CGPoint location = [touch locationInView:touch.view];
    [self changeTouchStatusWithLocation:location];   
}


- (void) touchesEnded:(NSSet *) touches withEvent:(UIEvent *) event
{
	NSLog(@"touch end");
    if(!shouldInteractThisTouch)
        return;
    //mainBtn.userInteractionEnabled = YES;
    UITouch *touch = [[event touchesForView:self.view] anyObject];
    CGPoint location = [touch locationInView:touch.view];
    
    [self changeTouchStatusWithLocation:location]; 
    
    [self doPressedStuff:location];
    
    [self dismissOtherBtn];
}




- (void)viewDidLoad
{
    [super viewDidLoad];
    
    background.hidden = YES;
    appendixBtn2.hidden = YES;
    appendixBtn1.hidden = YES;
    
    [self updateViewContent];
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    background = nil;
    mainBtn = nil;
    appendixBtn1 = nil;
    appendixBtn2 = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

@end
