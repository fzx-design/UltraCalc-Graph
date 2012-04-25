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
            mainBtn.tag = 0;
        }
        else if(i == 1)
        {
            [self setButton:appendixBtn1 attributeFromDictionary:dict];
            appendixBtn1.tag = 1;
        }
        else if(i == 2)
        {
            [self setButton:appendixBtn2 attributeFromDictionary:dict];
            appendixBtn2.tag = 2;
        }
    }

}


-(void)setDataSource:(id<MultipleButtonDataSource>) source
{
    datasource = source;
}

-(void)showOtherBtn
{
    [UIView animateWithDuration:0.1 animations:^{
        //background.hidden = NO;
        //appendixBtn2.hidden = NO;
        //appendixBtn1.hidden = NO;
        background.alpha = 1.0;
        appendixBtn1.alpha = 1.0;
        appendixBtn2.alpha = 1.0f;
        
    }];
    
    background.userInteractionEnabled = YES;
    appendixBtn1.userInteractionEnabled = YES;
    appendixBtn2.userInteractionEnabled = YES;
    
    [[[self.view superview] superview] bringSubviewToFront:[self.view superview]];
}

-(void)dismissOtherBtn
{
    [UIView animateWithDuration:0.3 animations:^{
        background.alpha = 0.0;
        appendixBtn1.alpha = 0.0;
        appendixBtn2.alpha = 0.0f;
    } completion:^(BOOL finish){
        if([datasource MultipleButtonNeedSendBackAfterTouch:self])[[[self.view superview] superview] sendSubviewToBack:[self.view superview]];
    }];
    
    background.userInteractionEnabled = NO;
    appendixBtn1.userInteractionEnabled = NO;
    appendixBtn2.userInteractionEnabled = NO;
    
    
    [mainBtn setHighlighted:NO];
    [appendixBtn1 setHighlighted:NO];
    [appendixBtn2 setHighlighted:NO];
    
    
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


-(void)swapButton:(UIButton*)btn1 With:(UIButton*)btn2
{
    int tag1 = btn1.tag;
    int tag2 = btn2.tag;
    
    btn1.tag = 10;
    btn2.tag = tag1;
    btn1.tag = tag2;
    
    NSDictionary *dict = [datasource MultipleButton:self ButtonAttributeAtIndex:btn1.tag];
    [self setButton:btn1 attributeFromDictionary:dict];
    
    dict = [datasource MultipleButton:self ButtonAttributeAtIndex:btn2.tag];
    [self setButton:btn2 attributeFromDictionary:dict];
    
}

-(void)doPressedStuff:(CGPoint) location
{
    UIButton *pressedButton = nil;
    if(CGRectContainsPoint(mainBtn.frame, location))
    {
        //[mainBtn setHighlighted:YES];
        NSLog(@"no0 button pressed");
        [datasource pressedButtonWithIdentifier:[self getIdentiferAtIndex:mainBtn.tag]];
        pressedButton = mainBtn;
    }
    else if(CGRectContainsPoint(appendixBtn1.frame, location))
    {
        //[appendixBtn1 setHighlighted:YES];
        NSLog(@"no1 button pressed");
        [datasource pressedButtonWithIdentifier:[self getIdentiferAtIndex:appendixBtn1.tag]];
        pressedButton = appendixBtn1;
    }
    else if(CGRectContainsPoint(appendixBtn2.frame, location))
    {
        //[appendixBtn2 setHighlighted:YES];
        NSLog(@"no2 button pressed");
        [datasource pressedButtonWithIdentifier:[self getIdentiferAtIndex:appendixBtn2.tag]];
        pressedButton = appendixBtn2;
    }
    else {
        NSLog(@"nothing pressed");
    }
    

    if(mainBtn.tag != pressedButton.tag)
    {
        [self swapButton:mainBtn With:pressedButton];
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
    
    background.alpha = 0.0;
    appendixBtn1.alpha = 0.0;
    appendixBtn2.alpha = 0.0f;

    background.userInteractionEnabled = NO;
    appendixBtn1.userInteractionEnabled = NO;
    appendixBtn2.userInteractionEnabled = NO;
    
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
