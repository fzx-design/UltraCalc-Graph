//
//  InputScrollViewController.m
//  UltraCalc
//
//  Created by Song  on 12-4-11.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "InputScrollViewController.h"
#import "ViewController.h"
/*
 Text formating parameter:
 u: following is upper text
 v: following is normal text, default value
 w: following is lower text
 
 P: stand for pi
 A: stand for sqrt
 B: stand for 3rd root
 */



@interface InputScrollViewController ()

@end

@implementation InputScrollViewController
@synthesize inputView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


-(NSString*)beautifulStr:(NSString*)str withSpace:(BOOL)space
{
    NSMutableString *s = [NSMutableString stringWithString:str];
    
    if(space)
    {
        [s replaceOccurrencesOfString:@"*" withString:@" × " options:NSCaseInsensitiveSearch range:NSMakeRange(0, s.length)];
        [s replaceOccurrencesOfString:@"/" withString:@" ÷ " options:NSCaseInsensitiveSearch range:NSMakeRange(0, s.length)];
        [s replaceOccurrencesOfString:@"-" withString:@" − " options:NSCaseInsensitiveSearch range:NSMakeRange(0, s.length)];
        [s replaceOccurrencesOfString:@"+" withString:@" + " options:NSCaseInsensitiveSearch range:NSMakeRange(0, s.length)];
    }
    else
    {
        [s replaceOccurrencesOfString:@"*" withString:@"×" options:NSCaseInsensitiveSearch range:NSMakeRange(0, s.length)];
        [s replaceOccurrencesOfString:@"/" withString:@"÷" options:NSCaseInsensitiveSearch range:NSMakeRange(0, s.length)];
    }
    return s;
}


-(CGSize)addPictureCharacterAtPosition:(CGPoint)position withOffset:(CGPoint)offset andScaleFactor:(float)scale withImageName:(NSString*)filename
{
    UIImage *image = [UIImage imageNamed:filename];
    
    float factor = 2.0;
    if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)] == YES && [[UIScreen mainScreen] scale] == 2.00) {
        // RETINA DISPLAY
        factor = 1.0;
    }
    
    UIImage *scaledImage = [UIImage imageWithCGImage:[image CGImage] 
                                               scale:1/(scale * factor) orientation:UIImageOrientationUp];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(position.x + offset.x, position.y + offset.y, scaledImage.size.width, scaledImage.size.height)];
    imageView.image = scaledImage;
    
    [self.inputView addSubview:imageView];
    
    return imageView.frame.size;
}


-(CGSize)addSqrtAtPosition:(CGPoint)position withOffset:(CGPoint)offset andScaleFactor:(float)scale
{
    return [self addPictureCharacterAtPosition:position withOffset:offset andScaleFactor:scale withImageName:@"sqrt.png"];
}

-(CGSize)add3rdRootAtPosition:(CGPoint)position withOffset:(CGPoint)offset andScaleFactor:(float)scale
{
    return [self addPictureCharacterAtPosition:position withOffset:offset andScaleFactor:scale withImageName:@"strt.png"];
}


-(CGSize)addPiAtPosition:(CGPoint)position withOffset:(CGPoint)offset andScaleFactor:(float)scale
{
    return [self addPictureCharacterAtPosition:position withOffset:offset andScaleFactor:scale withImageName:@"Pi.png"];
}


-(CGSize)addText:(NSString *)aText atPosition:(CGPoint)position withOffset:(CGPoint)offset andFontSize:(int)fontSize
{
    if([aText isEqualToString:@""] || [aText isEqualToString:@"#"])
        return CGSizeMake(0, 0);
    
    
    UIFont *font = [UIFont fontWithName:@"Eurostile" size:fontSize];
    
    CGSize size = [aText sizeWithFont:font];
    
    FXLabel* label = [[FXLabel alloc] initWithFrame:CGRectMake(position.x + offset.x, position.y + offset.y, size.width, size.height)];
    
    [label setFont:font];
    [label setBackgroundColor:[UIColor clearColor]];
	
	[label setText:aText];
    
    
    label.shadowColor = nil;
    label.shadowOffset = CGSizeMake(0.0f, 0.0f);
    label.textColor = [UIColor colorWithRed:158/255.0 green:254.0/255.0 blue:1 alpha:0.7];  
    label.shadowColor = [UIColor colorWithRed:58/255.0 green:250.0/255.0 blue:213.0/255.0 alpha:0.57];  
    
    label.shadowBlur = 5.0f;
    
    [self.inputView addSubview:label];
    
    return size;
}


-(void)syncContentWidth
{
    [scrollView setContentSize:CGSizeMake(cursorPosition, scrollView.contentSize.height)];
    
    CGPoint bottomOffset = CGPointMake(scrollView.contentSize.width - scrollView.bounds.size.width, scrollView.contentOffset.y);
    [scrollView setContentOffset:bottomOffset animated:NO];
    
    [self updateIndicator];
}

-(void)appendNormalString:(NSString *)str
{
    if([str isEqualToString:@"P"])
    {
        cursorPosition += [self addPiAtPosition:CGPointMake(cursorPosition, 0) withOffset:CGPointMake(0, 2) andScaleFactor:0.5].width;
    }
    else if([str isEqualToString:@"A"])
    {
        cursorPosition += [self addSqrtAtPosition:CGPointMake(cursorPosition, 0) withOffset:CGPointMake(0, 0) andScaleFactor:0.5].width;
    }
    else if([str isEqualToString:@"B"])
    {
        cursorPosition += [self add3rdRootAtPosition:CGPointMake(cursorPosition, 0) withOffset:CGPointMake(0, 0) andScaleFactor:0.5].width;
    }
    else
    {
        str = [self beautifulStr:str withSpace:YES];
        cursorPosition += [self addText:str atPosition:CGPointMake(cursorPosition, 0) withOffset:CGPointZero andFontSize:20].width;

    }
        
    [self syncContentWidth];
}

-(void)appendUpperString:(NSString *)str
{
    if([str isEqualToString:@"P"])
    {
        cursorPosition += [self addPiAtPosition:CGPointMake(cursorPosition, 0) withOffset:CGPointMake(0, -3) andScaleFactor:0.4].width;
    }
    else if([str isEqualToString:@"A"])
    {
        cursorPosition += [self addSqrtAtPosition:CGPointMake(cursorPosition, 0) withOffset:CGPointMake(0, -5) andScaleFactor:0.4].width;
    }
    else if([str isEqualToString:@"B"])
    {
        cursorPosition += [self add3rdRootAtPosition:CGPointMake(cursorPosition, 0) withOffset:CGPointMake(0, -5) andScaleFactor:0.4].width;
    }
    else
    {
        str = [self beautifulStr:str withSpace:NO];
        cursorPosition += [self addText:str atPosition:CGPointMake(cursorPosition, 0) withOffset:CGPointMake(0, -5) andFontSize:16].width;
    }
    
    [self syncContentWidth];
}

-(void)appendLowerString:(NSString *)str
{
    if([str isEqualToString:@"P"])
    {
        cursorPosition += [self addPiAtPosition:CGPointMake(cursorPosition, 0) withOffset:CGPointMake(0, 12) andScaleFactor:0.4].width;
    }
    else if([str isEqualToString:@"A"])
    {
        cursorPosition += [self addSqrtAtPosition:CGPointMake(cursorPosition, 0) withOffset:CGPointMake(0, 10) andScaleFactor:0.4].width;
    }
    else if([str isEqualToString:@"B"])
    {
        cursorPosition += [self add3rdRootAtPosition:CGPointMake(cursorPosition, 0) withOffset:CGPointMake(0, 10) andScaleFactor:0.4].width;
    }
    else
    {
        str = [self beautifulStr:str withSpace:NO];
        cursorPosition += [self addText:str atPosition:CGPointMake(cursorPosition, 0) withOffset:CGPointMake(0, 10) andFontSize:16].width;
    }
    [self syncContentWidth];
}


-(void)addRect:(CGRect)rect grey:(BOOL)Grey
{
    UIEdgeInsets inset = UIEdgeInsetsMake(5, 5, 5, 5);
    UIImage *resizeableImage = [[UIImage imageNamed:Grey?@"bracket_edit.png":@"bracket.png"] resizableImageWithCapInsets:inset];
    
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:rect];
    imageView.image = resizeableImage;
    
    [self.inputView addSubview:imageView];
    [self.inputView sendSubviewToBack:imageView];

}


-(void)updateIndicator
{
    float scrollViewWidth = scrollView.frame.size.width;
    float scrollContentSizeWidth = scrollView.contentSize.width;
    float scrollOffset = scrollView.contentOffset.x;
    
    if (scrollOffset <= 0)
    {
        // then we are at the top
        leftIndicator.hidden = YES;
        rightIndicator.hidden = NO;
    }
    else if (scrollOffset + scrollViewWidth >= scrollContentSizeWidth)
    {
        // then we are at the end
        leftIndicator.hidden = NO;
        rightIndicator.hidden = YES;
    }
    else
    {
        leftIndicator.hidden = NO;
        rightIndicator.hidden = NO;
    }
    if(cursorPosition < scrollViewWidth)
    {
        leftIndicator.hidden = YES;
        rightIndicator.hidden = YES;
    }
    
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self updateIndicator];
    [self syncPopover];
}


-(void)cleanView
{
    NSArray *array = [self.inputView subviews];
    for(UIView *i in array)
    {
        [i removeFromSuperview];
    }
    [self removePopover];
}


-(void)appendRectFromPosition:(float)startPosition toPosition:(float)endPosition onState:(int)state andIsGrey:(BOOL)grey
{
    CGRect rect;
    rect.size.width = endPosition - startPosition;
    
    if(state == 1)
    {
        rect.size.height = 25;
    }
    else
    {
        rect.size.height =  22;
    }
    rect.origin.x = startPosition;
    switch (state) {
        case 0:
            rect.origin.y = 8;
            break;
        case 1:
            rect.origin.y = -3;
            break;
        case 2:
            rect.origin.y = -7;
            break;
        default:
            break;
    }
    
    [self addRect:rect grey:grey];

}


-(void)removePopover
{
    popover.view.hidden = YES;
    needPopover = NO;
}

-(void)setPopoverModeWithBlankCount:(int)blankCount andCurrentPosition:(int)cursor
{
    [popover setModeWithBlankCount:blankCount andCurrentPosition:cursor];
}


-(void)syncPopover;
{
    if(!needPopover)
        return;
    
    float minX,maxX;
    minX = -72;
    maxX = 216;
    
    
    
    CGRect rect= popover.view.frame;
    
    rect.origin.x = popoverPosition.x - scrollView.contentOffset.x;
    
    popover.view.frame = rect;

    NSLog(@"popover x:%f",rect.origin.x);
    
    if(rect.origin.x < minX)
    {
        if(minX - rect.origin.x < 20)
        {
            [UIView animateWithDuration:0.15f animations:^
             {
                 popover.view.alpha = 1.0 - (minX - rect.origin.x) / 20 ;
             }
             ];
        }
        else
        {
            [UIView animateWithDuration:0.15f animations:^
             {
                 popover.view.alpha = 0.0;
             }
             ];
        }
    }
    else if(rect.origin.x > maxX)
    {
        if(rect.origin.x - maxX < 20)
        {
            [UIView animateWithDuration:0.15f animations:^
             {
                 popover.view.alpha = 1.0 - (rect.origin.x - maxX) / 20 ;
             }
             ];
        }
        else
        {
            [UIView animateWithDuration:0.15f animations:^
             {
                 popover.view.alpha = 0.0;
             }
             ];
        }
    }
    else
    {
        popover.view.hidden = NO;
        [UIView animateWithDuration:0.15f animations:^
         {
             popover.view.alpha = 1.0;
         }
         ];

    }
    
}


-(void)addPopoverAtPosition:(CGPoint)position withOffset:(CGPoint)offset
{
    needPopover = YES;
        
    CGRect rect= popover.view.frame;
    rect.origin.x = position.x + offset.x - rect.size.width / 2 + 14 + 53;
    rect.origin.y = position.y + offset.y + 4.5 + 83;
    
    popoverPosition = rect.origin;
    rect.origin.x -= scrollView.contentOffset.x;
    
    popover.view.frame = rect;

    popover.view.hidden = NO;
    
    [popover.view.superview bringSubviewToFront:popover.view];
    
    [self syncPopover];
}



-(void)setText:(NSString *)newtext
{
    [self cleanView];
    
    cursorPosition = 0;
    
    NSMutableString *newText = [newtext mutableCopy];
    
    
    //Parse start
    int state = 1; //1 for normal, 0 for lower, 2 for upper
    
    int blueFrameCount = 0;
    
    float startBlueFramePosition;
    int startBlueState;
    float endBlueFramePosition;
    int endBlueState;
    BOOL needRecordNextPositionToStartBlueFramePosition = NO;
    
    
    int greyFrameCount = 0;
    
    float startGreyFramePosition;
    int startGreyState;
    float endGreyFramePosition;
    int endGreyState;
    BOOL needRecordNextPositionToStartGreyFramePosition = NO;
    
    
    int waitingInsertingCount = 0;
    int insertIndex = -1;
        
    for (int i = 0; i < newText.length; i++) {
        if([newText characterAtIndex:i] == UPPER_STARTER )
        {
            state = 2;
            continue;
        }
        else if([newText characterAtIndex:i] == LOWER_STARTER)
        {
            state = 0;
            continue;
        }
        else if([newText characterAtIndex:i] == NORMAL_STARTER)
        {
            state = 1;
            continue;
        }
        else if([newText characterAtIndex:i] == ANOTHER_INSERT_POINTER)
        {
            waitingInsertingCount++;
            continue;
        }
        else if([newText characterAtIndex:i] == INSERT_POINTER)
        {
            waitingInsertingCount++;
            insertIndex = waitingInsertingCount;
            CGPoint offset;
            offset.x = 0;
            switch (state) {
                case 0:
                    offset.y = 10;
                    break;
                case 1:
                    offset.y = 0;
                    break;
                case 2:
                    offset.y = -7;
                default:
                    break;
            }
            [self addPopoverAtPosition:CGPointMake(cursorPosition, 0) withOffset:offset];
            continue;
        }
        else if([newText characterAtIndex:i] == '[')
        {
            blueFrameCount ++;
            if(blueFrameCount == 1)
            {
                needRecordNextPositionToStartBlueFramePosition = YES;
            }
            else
            {
                NSRange r;
                r.length = 1;
                r.location = i;
                [newText replaceCharactersInRange:r withString:@"("];
                i--;
            }
            continue;
        }
        else if([newText characterAtIndex:i] == '{')
        {
            greyFrameCount ++;
            if(greyFrameCount == 1)
            {
                needRecordNextPositionToStartGreyFramePosition = YES;
            }
            else
            {
                NSRange r;
                r.length = 1;
                r.location = i;
                [newText replaceCharactersInRange:r withString:@"("];
                i--;
            }
            continue;
        }
        else if([newText characterAtIndex:i] == ']')
        {
            blueFrameCount --;
            if(blueFrameCount == 0)
            {
                if(startBlueState != endBlueState)
                {
                    NSLog(@"ERROR start state != end state when draw blue rect");
                }
                [self appendRectFromPosition:startBlueFramePosition toPosition:endBlueFramePosition onState:startBlueState andIsGrey:NO];
            }
            else
            {
                NSRange r;
                r.length = 1;
                r.location = i;
                [newText replaceCharactersInRange:r withString:@")"];
                i--;
            }
            continue;
        }
        else if([newText characterAtIndex:i] == '}')
        {
            greyFrameCount --;
            if(greyFrameCount == 0)
            {
                if(startGreyState != endGreyState)
                {
                    NSLog(@"ERROR start state != end state when draw blue rect");
                }
                [self appendRectFromPosition:startGreyFramePosition toPosition:endGreyFramePosition onState:startGreyState andIsGrey:YES];
            }
            else
            {
                NSRange r;
                r.length = 1;
                r.location = i;
                [newText replaceCharactersInRange:r withString:@")"];
                i--;
            }
            continue;
        }

        if(needRecordNextPositionToStartBlueFramePosition)
        {
            needRecordNextPositionToStartBlueFramePosition = NO;
            startBlueFramePosition = cursorPosition;
            startBlueState = state;
        }
        if(needRecordNextPositionToStartGreyFramePosition)
        {
            needRecordNextPositionToStartGreyFramePosition = NO;
            startGreyFramePosition = cursorPosition;
            startGreyState = state;
        }

        
        switch (state) {
                case 1:
                    [self appendNormalString:[NSString stringWithFormat:@"%c",[newText characterAtIndex:i]]];
                    break;
                case 0:
                    [self appendLowerString:[NSString stringWithFormat:@"%c",[newText characterAtIndex:i]]];
                    break;
                case 2:
                    [self appendUpperString:[NSString stringWithFormat:@"%c",[newText characterAtIndex:i]]];
                    break;
                default:
                    break;
        }

        if(blueFrameCount > 0)
        {
            endBlueFramePosition = cursorPosition;
            endBlueState = state;
        }
        if(greyFrameCount > 0)
        {
            endGreyFramePosition = cursorPosition;
            endGreyState = state;
        }
    }
    [self updateIndicator];
    
    if(insertIndex >= 0)
    {
        [self setPopoverModeWithBlankCount:waitingInsertingCount andCurrentPosition:insertIndex];
    }
    
    text = newText;
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    leftIndicator.hidden = YES;
    rightIndicator.hidden = YES;
    
    
    [self initPopover];
    [self cleanView];

    //[self setText:@"logw[2T]v{8+PI}"];
}

-(void)initPopover
{
    popover = [self.storyboard instantiateViewControllerWithIdentifier:@"navigatePopup"];
    popover.delegate = _ancenster;
    ViewController *v = (ViewController *)_ancenster;
    [v.view addSubview:popover.view];
    popover.view.hidden = YES;

}

- (void)viewDidUnload
{
    scrollView = nil;
    leftIndicator = nil;
    rightIndicator = nil;
    [self setInputView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

@end
