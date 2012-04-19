//
//  ViewController.h
//  UltraCalc
//
//  Created by Song  on 12-3-25.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MultipleButtonDataSource.h"
#import "MultipleButtonViewController.h"
#import "InputScrollViewController.h"
#import "FXLabel.h"
#import "Brain.h"
#import "AnswerTableModel.h"

@class DDMathEvaluator;

@interface ViewController : UIViewController <MultipleButtonDataSource,UITableViewDataSource,UIActionSheetDelegate>
{
    DDMathEvaluator *evaluator;
    Brain *brain;
    
    
    
    __weak IBOutlet UIImageView *backgroundImageView;
    __weak IBOutlet UIView *leftView;
    __weak IBOutlet UIView *rightView;
    
    __weak IBOutlet UIView *logView;
    MultipleButtonViewController *logMultipleButton;
    
    __weak IBOutlet UIView *sqrtView;
    MultipleButtonViewController *sqrtMultipleButton;
    
    __weak IBOutlet UIView *sinView;
    MultipleButtonViewController *sinMultipleButton;
    
    __weak IBOutlet UIView *arcsinView;
    MultipleButtonViewController *arcsinMultipleButton;
    
    __weak IBOutlet UIView *sinhView;
    MultipleButtonViewController *sinhMultipleButton;
    
    __weak IBOutlet UIView *xyView;
    MultipleButtonViewController *xyMultipleButton;
    

    
    __weak IBOutlet UIView *inputView;
    InputScrollViewController *inputScrollViewController;
    
    
    __weak IBOutlet FXLabel *resultLabel;
    
    
    __weak IBOutlet UITableView *answerTableView;
    
    __weak IBOutlet UIButton *editAnswerTableBtn;
    __weak IBOutlet UIImageView *editAnswerPressedIndicator;
    __weak IBOutlet UIButton *answerTableEditDeleteButton;
    
}

-(IBAction)digitPressed:(id)sender;
-(IBAction)delPressed:(id)sender;
-(IBAction)allClearPressed:(id)sender;
-(IBAction)operatorPressed:(id)sender;
-(IBAction)positiveMinusPressed:(id)sender;
-(IBAction)dotPressed:(id)sender;
-(IBAction)goPressed:(id)sender;
-(IBAction)leftParenthesePressed:(id)sender;
-(IBAction)rightParenthesePressed:(id)sender;


-(IBAction)editAnswerTable:(id)sender;

-(IBAction)deleteTableCells:(id)sender;

@end
