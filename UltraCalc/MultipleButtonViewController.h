//
//  MultipleButtonViewController.h
//  touchTest
//
//  Created by Song  on 12-3-27.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MultipleButtonDataSource.h"

@interface MultipleButtonViewController: UIViewController <UIGestureRecognizerDelegate>
{
    __weak IBOutlet UIImageView *background;
    __weak IBOutlet UIButton *mainBtn;
    __weak IBOutlet UIButton *appendixBtn1;
    __weak IBOutlet UIButton *appendixBtn2;
    
    id<MultipleButtonDataSource> datasource;
    BOOL shouldInteractThisTouch;
}

-(void)setDataSource:(id<MultipleButtonDataSource>) source;

@end
