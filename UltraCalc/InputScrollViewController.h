//
//  InputScrollViewController.h
//  UltraCalc
//
//  Created by Song  on 12-4-11.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InputScrollViewController : UIViewController
{
    __weak IBOutlet UIScrollView *scrollView;
    __weak IBOutlet UILabel *inputLabel;
    UIFont *font;
}

-(void)setText:(NSString*)string;

@end
