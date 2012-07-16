//
//  InputScrollViewController.h
//  UltraCalc
//
//  Created by Song  on 12-4-11.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FXLabel.h"
#import "NavigatePopoverController.h"
#import "NavigatePopoverProtocal.h"

#define NORMAL_STARTER 'v'
#define UPPER_STARTER 'u'
#define LOWER_STARTER 'w'
#define INSERT_POINTER 'I'
#define ANOTHER_INSERT_POINTER 'T'


@interface InputScrollViewController : UIViewController<UIScrollViewDelegate>
{
    __weak IBOutlet UIScrollView *scrollView;
    __weak IBOutlet UIImageView *leftIndicator;
    __weak IBOutlet UIImageView *rightIndicator;
    
    NSString* text;
    
    NavigatePopoverController *popover;
    
    float cursorPosition;
    BOOL needPopover;
    CGPoint popoverPosition;
}

@property (weak, nonatomic) IBOutlet UIView *inputView;

@property (nonatomic) NSString* text;

@property (nonatomic) id<NavigatePopoverProtocal> ancenster;

-(void)removePopover;

-(void)setInfoText:(NSString*) text;


@end
