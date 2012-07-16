//
//  ViewController.m
//  UltraCalc
//
//  Created by Song  on 12-3-25.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"
#import "MultipleButtonDataSource.h"
#import "MultipleButtonViewController.h"
#import "InputScrollViewController.h"
#import "FXLabel.h"
#import "MyDataStorage.h"

#import "DragNumberViewController.h"

@interface ViewController ()

@end

@implementation ViewController

@synthesize managedObjectContext;
@synthesize fetchedResultsController = _fetchedResultsController;

#pragma mark - Life Cycle and inits

- (void)loadInputScrollView
{
    inputScrollViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"InputScrollView"];
    inputScrollViewController.ancenster = self;
    [inputView addSubview:inputScrollViewController.view];
    
    CGRect rect= inputView.frame;
    rect.size.height = 40;
    rect.size.width = 248;
    [[inputScrollViewController view] setFrame:rect];
}



- (void)initResultLabel
{
    [resultLabel setFont:[UIFont fontWithName:@"Eurostile" size:32]];
    resultLabel.shadowColor = nil;
    resultLabel.shadowOffset = CGSizeMake(0.0f, 0.0f);
    resultLabel.shadowColor = [UIColor colorWithRed:58/255.0 green:250.0/255.0 blue:213.0/255.0 alpha:0.57];   
    resultLabel.shadowBlur = 5.0f;
}



- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    NSLog(@"should rotate");
    if (UIInterfaceOrientationIsLandscape(interfaceOrientation))
        return YES;
    else 
        return NO;
    //    if (UIInterfaceOrientationIsLandscape(interfaceOrientation)) {
    //        //动画开始之前，frame有一个值
    //        
    //        [UIView beginAnimations:nil context:UIGraphicsGetCurrentContext()];
    //        [UIView setAnimationCurve:UIViewAnimationCurveLinear];
    //        
    //        [UIView setAnimationDuration:0.2];
    //        //设置动画时间
    //        //[UIView setAnimationDelegate:self];
    //        //[UIView setAnimationDidStopSelector:@selector(FireworkAnimationStep_3)];
    //        //如果需要设置回调，这两句话分别交代了回调的对象和具体的回调方法
    //        //[leftView setCenter:CGPointMake(290, 375.0f)];
    //        
    //        leftView.frame = CGRectMake(0,0 ,1024 ,748);
    //        //xxx.frame = CGRectMake(, , , );
    //        //这个才是动画的目的，你最终希望是什么样，比如你的需求是，希望frame刚好占满屏幕
    //        [UIView commitAnimations];
    //        //设置好了，开始执行
    //
    //        
    //        [rightView setCenter:CGPointMake(290.0f + 600.0f, 375.0f)];
    //        [rightView setUserInteractionEnabled:YES];
    //        //UIImage *bg = [UIImage imageNamed:@"Default-Landscape.png"];
    ////        [backgroundView setImage:bg]; 
    ////        [UIView animateWithDuration:0.0 animations:^{
    ////			shadowView.alpha = 0.0;
    ////		}];
    //    }
    //    else {
    //        [leftView setCenter:CGPointMake(768.0f/2, 1024.0f/2)];
    //        
    //        
    //        //动画开始之前，frame有一个值
    //        
    //        [UIView beginAnimations:nil context:UIGraphicsGetCurrentContext()];
    //        [UIView setAnimationCurve:UIViewAnimationCurveLinear];
    //        
    //        [UIView setAnimationDuration:0.2];
    //        //设置动画时间
    //        //[UIView setAnimationDelegate:self];
    //        //[UIView setAnimationDidStopSelector:@selector(FireworkAnimationStep_3)];
    //        //如果需要设置回调，这两句话分别交代了回调的对象和具体的回调方法
    //        //[leftView setCenter:CGPointMake(768.0f/2, 1024.0f/2)];
    //        leftView.frame = CGRectMake(0,0 ,768 ,1024);
    //        //xxx.frame = CGRectMake(, , , );
    //        //这个才是动画的目的，你最终希望是什么样，比如你的需求是，希望frame刚好占满屏幕
    //        [UIView commitAnimations];
    //        //设置好了，开始执行
    //        
    //        
    //        [rightView setCenter:CGPointMake(768.0f/2 + 491.0f, 1024.0f/2)];
    //        [rightView setUserInteractionEnabled:NO];
    //        //UIImage *bg = [UIImage imageNamed:@"Default-Portrait.png"];
    ////        [backgroundView setImage:bg];
    ////		[UIView animateWithDuration:0.5 animations:^{
    ////			shadowView.alpha = 1.0;
    ////		}];
    //    }
    //return YES;
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self loadMultipleButtons];
    
    [self loadInputScrollView];
    
    [self initResultLabel];
    
    answerTableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"cell_bg.png"]];
    
    justPressedAC = NO;
    
    if(brain == nil)
        brain = [Brain sharedBrain];
    
    
    dataStorage = [[MyDataStorage alloc] init];
    self.managedObjectContext = dataStorage.managedObjectContext;
    
    NSError *error;
	if (![[self fetchedResultsController] performFetch:&error]) {
		// Update to handle the error appropriately.
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		exit(-1);  // Fail
	}
    
    [self updateUndoRedoIndicator];
    [self updateNoRecordPlaceHolder];
    
    //    for( NSString *familyName in [UIFont familyNames] ) {
    //        for( NSString *fontName in [UIFont fontNamesForFamilyName:familyName] ) {
    //            NSLog(@"%@", fontName);
    //        }
    //    }
    
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidUnload
{
    backgroundImageView = nil;
    leftView = nil;
    rightView = nil;
    logView = nil;
    sqrtView = nil;
    sinView = nil;
    arcsinView = nil;
    sinhView = nil;
    xyView = nil;
    //inputLabel = nil;
    answerTableView = nil;
    editAnswerTableBtn = nil;
    resultLabel = nil;
    editAnswerPressedIndicator = nil;
    inputView = nil;
    answerTableEditDeleteButton = nil;
    noRecordPlaceHolder = nil;
    canUndoIndicator = nil;
    canRedoIndicator = nil;
    sincosBackground = nil;
    basicFunctionView = nil;
    undoBtn = nil;
    redoBtn = nil;
    aggregateFunctionView = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

#pragma mark - Move Shield


- (void)moveUIView:(UIView*)view WithOffset:(CGPoint)offset
{
    CGRect rect = view.frame;
    rect.origin.x += offset.x;
    rect.origin.y += offset.y;
    view.frame = rect;
}


- (void)moveShield:(BOOL)up
{
    int factor = up ? 1 : -1;
    CGPoint offset = CGPointMake(0, factor * 110);
    if(up)
    {
        aggregateFunctionView.hidden = !up;
    }
    aggregateFunctionView.alpha = up ? 0 : 1.0;
    
    [UIView animateWithDuration:0.3f animations:^(void){
        [self moveUIView:sincosBackground WithOffset:offset];
        [self moveUIView:canUndoIndicator WithOffset:offset];
        [self moveUIView:canRedoIndicator WithOffset:offset];
        [self moveUIView:undoBtn WithOffset:offset];
        [self moveUIView:redoBtn WithOffset:offset];
        [self moveUIView:basicFunctionView WithOffset:offset];
        aggregateFunctionView.alpha = up ? 1.0 : 0;
    } completion:^(BOOL finished){
        if(finished)
        {
            [basicFunctionView setUserInteractionEnabled:!up];
            [undoBtn setEnabled:!up];
            [redoBtn setEnabled:!up];
            aggregateFunctionView.hidden = !up;
        }
        
    }];
}



- (void)moveShieldDown
{
    [self moveShield:NO];
}

- (void)moveShieldUp
{
    [self moveShield:YES];
}


#pragma mark - Helper Methods

- (void) evaluate {
    
    NSNumber *result = [brain evaluate];
    if(result != nil)
    {
        [resultLabel setTextColor:[UIColor whiteColor]];
        
        [resultLabel setText:brain.resultString];
        
        
        NSManagedObjectContext *context = [self managedObjectContext];
        AnswerTableResult *newResult = [NSEntityDescription
                                          insertNewObjectForEntityForName:@"AnswerTableResult"
                                          inManagedObjectContext:context];
        newResult.result = [result description];
        newResult.calc = brain.calculateString;
        newResult.datetime = [NSDate date];
        
        [dataStorage saveContext];
        
        
//        NSIndexPath *path1 = [NSIndexPath indexPathForRow:0 inSection:0];
//        
//        NSArray *indexArray = @[path1];
//        
//        [answerTableView insertRowsAtIndexPaths:indexArray withRowAnimation:UITableViewRowAnimationTop];
        
    }
    else {
        [resultLabel setText:brain.resultString];
        if(brain.errorOccured)
        {
            [resultLabel setTextColor:[UIColor redColor]];
        }
		else {
            [resultLabel setTextColor:[UIColor whiteColor]];
        }
	}
}




- (void)syncInputLabel
{
    [inputScrollViewController setText:brain.displayString];
    
    //[inputScrollViewController clearAllRect];

}

- (void)clearResultLabel
{
    if(![resultLabel.text isEqualToString:@"0"])
        resultLabel.text = @"";
}

- (void)updateUndoRedoIndicator
{
    
    if(![brain.undoManager canUndo])
    {
        [UIView animateWithDuration:0.3f animations:^
         {
             canUndoIndicator.alpha = 0.0;
         }
         ];
    }
    else {
        [UIView animateWithDuration:0.3f animations:^
         {
             canUndoIndicator.alpha = 1.0;
         }
         ];
    }
    
    if(![brain.undoManager canRedo])
    {
        [UIView animateWithDuration:0.3f animations:^
         {
             canRedoIndicator.alpha = 0.0;
         }
         ];
    }
    else {
        [UIView animateWithDuration:0.3f animations:^
         {
             canRedoIndicator.alpha = 1.0;
         }
         ];
    }
}



-(void)setNotEditingWhenPressedOtherButton
{
    if(answerTableView.isEditing)
    {
        [self editAnswerTable:nil];
    }
}


- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    
    //AnswerCellModel *cellModel = [[AnswerTableModel sharedModel] cellModelAtIndex:indexPath.row];
    
    AnswerTableResult *info = [_fetchedResultsController objectAtIndexPath:indexPath];
    
    
    UILabel *cellResultLabel = (UILabel *)[cell viewWithTag:101];
	cellResultLabel.text = info.result;
    
	UILabel *cellExpressionLabel = (UILabel *)[cell viewWithTag:102];
	cellExpressionLabel.text = info.calc;
    
    cell.selectedBackgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cell_hover_bg.png"]];
    
    
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
    [cell addGestureRecognizer:longPress];
    
    
	UIImageView * noteImageView = (UIImageView *)[cell viewWithTag:103];
    if(info.tableToNoteRelation)
    {
        noteImageView.hidden = NO;
    }
    else {
        noteImageView.hidden = YES;
    }
    

}


#pragma mark - Handle simple key press


-(IBAction)undoPressed:(id)sender
{
    [brain.undoManager undo];
    
    [self syncInputLabel];
    
    [self setNotEditingWhenPressedOtherButton];
    [self updateUndoRedoIndicator];
    
    [self clearResultLabel];
    justPressedAC = NO;
}

-(IBAction)redoPressed:(id)sender
{
    [brain.undoManager redo];
    
    [self syncInputLabel];
    
    [self setNotEditingWhenPressedOtherButton];
    [self updateUndoRedoIndicator];
    [self clearResultLabel];
    justPressedAC = NO;
}



-(IBAction)digitPressed:(id)sender
{
    NSLog(@"digitPressed");
    UIButton *btn = (UIButton*) sender;
    
    [brain appendDigit:[NSString stringWithFormat:@"%d",btn.tag]];
    
    [self syncInputLabel];
    [self setNotEditingWhenPressedOtherButton];
    [self updateUndoRedoIndicator];
    justPressedAC = NO;
    [self clearResultLabel];
}


-(IBAction)delPressed:(id)sender
{
    NSLog(@"delPressed");
    
    [brain removeLastToken];
    
    [self syncInputLabel];
    [self setNotEditingWhenPressedOtherButton];
    [self updateUndoRedoIndicator];
    justPressedAC = NO;
    [self clearResultLabel];
}

-(IBAction)allClearPressed:(id)sender
{
    NSLog(@"allClearPressed");
    if(!justPressedAC)
    {
        [brain clearQueue];
        
        [self syncInputLabel];
        
        [self clearResultLabel];
        [self setNotEditingWhenPressedOtherButton];
        [self updateUndoRedoIndicator];
        justPressedAC = YES;
    }
    else {
        [brain.undoManager removeAllActions];
        [self syncInputLabel];
        [self updateUndoRedoIndicator];
    }
}

-(IBAction)operatorPressed:(id)sender
{
    NSLog(@"operatorPressed");
    UIButton *btn = (UIButton*) sender;
    NSString *op;
    switch (btn.tag) {
        case 1:
            op = @"+";
            break;
        case 2:
            op = @"-";
            break;
        case 3:
            op = @"*";
            break;
        case 4:
            op = @"/";
        default:
            break;
    }
    [brain appendOperator:op];
    
    [self syncInputLabel];
    [self setNotEditingWhenPressedOtherButton];
    [self updateUndoRedoIndicator];
    justPressedAC = NO;
    [self clearResultLabel];
}
-(IBAction)positiveMinusPressed:(id)sender
{
    NSLog(@"positiveMinusPressed");
    
    [self setNotEditingWhenPressedOtherButton];
    justPressedAC = NO;
    [self clearResultLabel];
}

-(IBAction)dotPressed:(id)sender
{
    NSLog(@"dotPressed");
    [brain appendDot:@"."];
    [self syncInputLabel];
    
    [self setNotEditingWhenPressedOtherButton];
    [self updateUndoRedoIndicator];
    justPressedAC = NO;
    [self clearResultLabel];
}

-(IBAction)leftParenthesePressed:(id)sender
{
    [brain appendLeftParenthese];
    
    [self syncInputLabel];
    
    [self setNotEditingWhenPressedOtherButton];
    [self updateUndoRedoIndicator];
    justPressedAC = NO;
    [self clearResultLabel];
}

-(IBAction)rightParenthesePressed:(id)sender
{
    [brain appendRightParenthese];
    
    [self syncInputLabel];

    [self setNotEditingWhenPressedOtherButton];
    [self updateUndoRedoIndicator];
    justPressedAC = NO;
    [self clearResultLabel];
}

-(IBAction)piPressed:(id)sender
{
    [brain appendPI];
    
    [self syncInputLabel];
    
    [self setNotEditingWhenPressedOtherButton];
    [self updateUndoRedoIndicator];
    justPressedAC = NO;
    [self clearResultLabel];
}

-(IBAction)percentPressed:(id)sender
{
    [brain appendPercent];
    
    [self syncInputLabel];
    
    [self setNotEditingWhenPressedOtherButton];
    [self updateUndoRedoIndicator];
    justPressedAC = NO;
    [self clearResultLabel];
}


-(IBAction)goPressed:(id)sender
{
    NSLog(@"goPressed");
    [brain appendACompoundString:@"#"];
    
    [self syncInputLabel];
    
    [self evaluate];
    
    [self setNotEditingWhenPressedOtherButton];
    [self updateUndoRedoIndicator];
    justPressedAC = NO;
    
    [inputScrollViewController removePopover];
}

-(IBAction)sumPressed:(id)sender
{
    [self sumFunction];
}

-(IBAction)avePressed:(id)sender
{
    [self aveFunction];
}

-(IBAction)stddevPressed:(id)sender
{
    [self stddevFunction];
}

#pragma mark - Handle complex key press

- (void)loadMultipleButtons
{
    logMultipleButton = (MultipleButtonViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"MultipleBtn"];
    
    [logMultipleButton setDataSource:self];
    
    CGRect rect= logView.frame;
    rect.origin.x = -14;
    rect.origin.y = -108;
    rect.size.height *= 3;
    [[logMultipleButton view] setFrame:rect];
    
    [logView addSubview: logMultipleButton.view];
    
    
    
    sqrtMultipleButton = (MultipleButtonViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"MultipleBtn"];
    
    [sqrtMultipleButton setDataSource:self];
    
    rect= sqrtView.frame;
    rect.origin.x = -14;
    rect.origin.y = -108;
    rect.size.height *= 3;
    
    [[sqrtMultipleButton view] setFrame:rect];
    
    [sqrtView addSubview: sqrtMultipleButton.view];
    
    
    
    
    sinMultipleButton = (MultipleButtonViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"MultipleBtn"];
    
    [sinMultipleButton setDataSource:self];
    
    rect= sinView.frame;
    rect.origin.x = -14;
    rect.origin.y = -108;
    rect.size.height *= 3;
    
    [[sinMultipleButton view] setFrame:rect];
    
    [sinView addSubview: sinMultipleButton.view];
    
    
    
    arcsinMultipleButton = (MultipleButtonViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"MultipleBtn"];
    
    [arcsinMultipleButton setDataSource:self];
    
    rect= arcsinView.frame;
    rect.origin.x = -14;
    rect.origin.y = -108;
    rect.size.height *= 3;
    
    [[arcsinMultipleButton view] setFrame:rect];
    
    [arcsinView addSubview: arcsinMultipleButton.view];
    
    
    
    
    
    sinhMultipleButton = (MultipleButtonViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"MultipleBtn"];
    
    [sinhMultipleButton setDataSource:self];
    
    rect= sinhView.frame;
    rect.origin.x = -14;
    rect.origin.y = -108;
    rect.size.height *= 3;
    
    [[sinhMultipleButton view] setFrame:rect];
    
    [sinhView addSubview: sinhMultipleButton.view];
    
    
    
    xyMultipleButton = (MultipleButtonViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"MultipleBtn"];
    
    [xyMultipleButton setDataSource:self];
    
    rect= xyView.frame;
    rect.origin.x = -14;
    rect.origin.y = -108;
    rect.size.height *= 3;
    
    [[xyMultipleButton view] setFrame:rect];
    
    [xyView addSubview: xyMultipleButton.view];
}



-(BOOL)MultipleButtonNeedSendBackAfterTouch:(MultipleButtonViewController*)button
{
    if(button == logMultipleButton || button == sqrtMultipleButton)
        return NO;
    return YES;
}

-(NSDictionary*)MultipleButton:(MultipleButtonViewController*)button ButtonAttributeAtIndex:(int)index
{
    
    if(button == logMultipleButton)
    {
        if(index == 0)
        {
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            dict[@"normal"] = @"button_log.png";
            dict[@"highlight"] = @"button_log.png";
            dict[@"id"] = @"log";
            return dict;
        }
        else if(index == 1)
        {
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            dict[@"normal"] = @"button_ln.png";
            dict[@"highlight"] = @"button_ln.png";
            dict[@"id"] = @"ln";
            return dict;
        }
        else if(index == 2)
        {
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            dict[@"normal"] = @"button_logxy.png";
            dict[@"highlight"] = @"button_logxy.png";
            dict[@"id"] = @"logxy";
            return dict;
        }
    }
    else if(button == sqrtMultipleButton)
    {
        if(index == 0)
        {
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            dict[@"normal"] = @"button_root.png";
            dict[@"highlight"] = @"button_root.png";
            dict[@"id"] = @"root";
            return dict;
        }
        else if(index == 1)
        {
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            dict[@"normal"] = @"button_root3.png";
            dict[@"highlight"] = @"button_root3.png";
            dict[@"id"] = @"root3";
            return dict;
        }
        else if(index == 2)
        {
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            dict[@"normal"] = @"button_rootx.png";
            dict[@"highlight"] = @"button_rootx.png";
            dict[@"id"] = @"rootx";
            return dict;
        }
    }
    else if(button == sinMultipleButton)
    {
        if(index == 0)
        {
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            dict[@"normal"] = @"button_sin.png";
            dict[@"highlight"] = @"button_sin.png";
            dict[@"id"] = @"sin";
            return dict;
        }
        else if(index == 1)
        {
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            dict[@"normal"] = @"button_cos.png";
            dict[@"highlight"] = @"button_cos.png";
            dict[@"id"] = @"cos";
            return dict;
        }
        else if(index == 2)
        {
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            dict[@"normal"] = @"button_tan.png";
            dict[@"highlight"] = @"button_tan.png";
            dict[@"id"] = @"tan";
            return dict;
        }
    }
    else if(button == arcsinMultipleButton)
    {
        if(index == 0)
        {
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            dict[@"normal"] = @"button_arcsin.png";
            dict[@"highlight"] = @"button_arcsin.png";
            dict[@"id"] = @"arcsin";
            return dict;
        }
        else if(index == 1)
        {
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            dict[@"normal"] = @"button_arccos.png";
            dict[@"highlight"] = @"button_arccos.png";
            dict[@"id"] = @"arccos";
            return dict;
        }
        else if(index == 2)
        {
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            dict[@"normal"] = @"button_arctan.png";
            dict[@"highlight"] = @"button_arctan.png";
            dict[@"id"] = @"arctan";
            return dict;
        }
    }
    else if(button == sinhMultipleButton)
    {
        if(index == 0)
        {
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            dict[@"normal"] = @"button_sinh.png";
            dict[@"highlight"] = @"button_sinh.png";
            dict[@"id"] = @"sinh";
            return dict;
        }
        else if(index == 1)
        {
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            dict[@"normal"] = @"button_cosh.png";
            dict[@"highlight"] = @"button_cosh.png";
            dict[@"id"] = @"cosh";
            return dict;
        }
        else if(index == 2)
        {
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            dict[@"normal"] = @"button_tanh.png";
            dict[@"highlight"] = @"button_tanh.png";
            dict[@"id"] = @"tanh";
            return dict;
        }
    }
    else if(button == xyMultipleButton)
    {
        if(index == 0)
        {
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            dict[@"normal"] = @"button_x2.png";
            dict[@"highlight"] = @"button_x2.png";
            dict[@"id"] = @"x2";
            return dict;
        }
        else if(index == 1)
        {
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            dict[@"normal"] = @"button_x3.png";
            dict[@"highlight"] = @"button_x3.png";
            dict[@"id"] = @"x3";
            return dict;
        }
        else if(index == 2)
        {
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            dict[@"normal"] = @"button_xy.png";
            dict[@"highlight"] = @"button_xy.png";
            dict[@"id"] = @"xy";
            return dict;
        }
    }

    return nil;
}


-(void)pressedButtonWithIdentifier:(NSString*)identifier
{
    NSLog(@"%@",identifier);
    
    if([identifier isEqualToString:@"x2"])
    {
        [brain appendFixPower:@"^2"];
    }
    else if([identifier isEqualToString:@"x3"])
    {
        [brain appendFixPower:@"^3"];
    }
    else if([identifier isEqualToString:@"xy"])
    {
        [brain appendACompoundString:@"x(I)"];
    }
    else if([identifier isEqualToString:@"rootx"])
    {
        [brain appendACompoundString:@"Rootx(I,T)"];
    }
    else if([identifier isEqualToString:@"logxy"])
    {
        [brain appendACompoundString:@"logxy(I,T)"];
    }
    else
    {
        [brain appendFunction:[NSString stringWithFormat:@"%@",identifier]];
        
    }
    
    [self syncInputLabel];
    
    [self setNotEditingWhenPressedOtherButton];
    [self updateUndoRedoIndicator];
    justPressedAC = NO;
    [self clearResultLabel];
}




#pragma mark - Answer table and its datasource and delegate


- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView
		   editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if(answerTableView.isEditing)
    {
        return UITableViewCellEditingStyleDelete;
    }
    return UITableViewCellEditingStyleNone;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (editingStyle == UITableViewCellEditingStyleDelete)
	{
        NSManagedObject *objectToDelete = [_fetchedResultsController objectAtIndexPath:indexPath];
        [managedObjectContext deleteObject:objectToDelete];
        [dataStorage saveContext];
	}
}

- (void)tableView:(UITableView *)tableView 
didEndEditingRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView reloadData];
}


-(void)updateNoRecordPlaceHolder
{
    if([self tableView:answerTableView numberOfRowsInSection:0] == 0)
    {
        noRecordPlaceHolder.hidden = NO;
        [UIView animateWithDuration:0.1f animations:^{
            noRecordPlaceHolder.alpha = 1.0;
        }];
    }
    else {
        [UIView animateWithDuration:0.1f animations:^{
            noRecordPlaceHolder.alpha = 0; 
        } 
                         completion:^(BOOL finish)
        {
            noRecordPlaceHolder.hidden = YES; 
        }
       ];
    }
}

-(IBAction)editAnswerTable:(id)sender
{
    if([self tableView:answerTableView numberOfRowsInSection:0] == 0 && !answerTableView.isEditing)
    {
        return;
    }
    BOOL isEditing = answerTableView.editing;
    [answerTableView setEditing:!isEditing animated:YES];
    answerTableEditDeleteButton.hidden = isEditing;
    float expectAlpha = isEditing?0:1;
    [UIView animateWithDuration:0.1f animations:^{
        editAnswerPressedIndicator.alpha = expectAlpha;
    }];
    justPressedAC = NO;
    
    
    if(isEditing)
    {
        [self moveShieldDown];
    }
    else
    {
        [self moveShieldUp];
    }
}


-(IBAction)deleteTableCells:(id)sender
{
    NSArray* cellsToDelete = [answerTableView indexPathsForSelectedRows];

    NSMutableIndexSet *indexSet = [[NSMutableIndexSet alloc] init];
    //NSMutableSet *set = [NSMutableSet set];
    
    for(NSIndexPath *path in cellsToDelete)
    {
        NSInteger row = path.row;;
        [indexSet addIndex:row];
        
        NSManagedObject *objectToDelete = [_fetchedResultsController objectAtIndexPath:path];
        [managedObjectContext deleteObject:objectToDelete];
    }
       
    [dataStorage saveContext];
    
    //[answerTableView deleteRowsAtIndexPaths:cellsToDelete withRowAnimation:UITableViewRowAnimationTop];
    //[answerTableView reloadData];
    
    if([self tableView:answerTableView numberOfRowsInSection:0] == 0)
    {
        if(answerTableView.isEditing)
        {
            [self editAnswerTable:nil];
        }
        [self updateNoRecordPlaceHolder];
    }
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    id  sectionInfo =
    [[_fetchedResultsController sections] objectAtIndex:section];
    return [sectionInfo numberOfObjects];
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell = [tableView
                             dequeueReusableCellWithIdentifier:@"answerCell"];

    [self configureCell:cell atIndexPath:indexPath];

    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath 
{
    // Return YES if you want the specified item to be editable.
    return YES;
}
-(void)tableView:(UITableView*)tableView willBeginEditingRowAtIndexPath:(NSIndexPath *)indexPath 
{
    
}


- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex 
{
    NSLog(@"actionSheet:%d",buttonIndex);
    NSIndexPath* selected = [answerTableView indexPathForSelectedRow];
    [answerTableView deselectRowAtIndexPath:selected animated:YES];
    switch (buttonIndex) {
        case 0://copy
        {
            UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
            AnswerTableResult *object = [_fetchedResultsController objectAtIndexPath:selected];
            pasteboard.string = object.result;
        }
            break;
        case 1://use result
        {
            AnswerTableResult *object = [_fetchedResultsController objectAtIndexPath:selected];
            [brain appendACompoundString:object.result];
            
            [self syncInputLabel];
            
            [self setNotEditingWhenPressedOtherButton];
            [self updateUndoRedoIndicator];
            justPressedAC = NO;
            [self clearResultLabel];
        }
            break;
        case 2://Edit note
            break;
        case 3://Delete
        {
            NSManagedObject *objectToDelete = [_fetchedResultsController objectAtIndexPath:selected];
            [managedObjectContext deleteObject:objectToDelete];
            [dataStorage saveContext];
        }
            break;
        default:
            break;
    }
    
    
}

- (void)showCellActionListForCell:(UITableViewCell*)cell
{
    UIActionSheet *popupSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                            delegate:self 
                                                   cancelButtonTitle:nil 
                                              destructiveButtonTitle:@"Copy" 
                                                   otherButtonTitles:@"Use Result", @"Edit Note",@"Delete", nil];
    
    popupSheet.destructiveButtonIndex = 3;
    
    popupSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    //UILabel * expressionLabel = (UILabel *)cell.gestur;
    
    [popupSheet showFromRect:cell.bounds inView:cell animated:YES];
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //wierd i can only write it here...
    return 68;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView.isEditing)//high light text when multi select.
    {
        UITableViewCell *cell = [answerTableView cellForRowAtIndexPath:indexPath];
        UILabel *cellResultLabel = (UILabel *)[cell viewWithTag:101];
        [cellResultLabel setHighlighted:YES];
        
        UILabel *cellExpressionLabel = (UILabel *)[cell viewWithTag:102];
        [cellExpressionLabel setHighlighted:YES];
    }
    else {
        UITableViewCell *cell = [answerTableView cellForRowAtIndexPath:indexPath];
        
        if (!answerTableView.isEditing) {
            [self showCellActionListForCell:cell];
            [answerTableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
        }
        
    }
}





#pragma mark - Navigate Popover Protocal
-(void)leftButtonPressed:(id)sender
{
    NSLog(@"navigate left button pressed");
    
    [brain previousPressed];
    
    [self syncInputLabel];
    [self setNotEditingWhenPressedOtherButton];
    [self updateUndoRedoIndicator];
    justPressedAC = NO;
    [self clearResultLabel];
    
}

-(void)rightButtonPressed:(id)sender
{
    NSLog(@"navigate right button pressed");
    [brain nextPressed];
    [self syncInputLabel];
    [self setNotEditingWhenPressedOtherButton];
    [self updateUndoRedoIndicator];
    justPressedAC = NO;
    [self clearResultLabel];
}

-(void)centerButtonPressed:(id)sender
{
    NSLog(@"navigate center button pressed");
    NSNumber *number = (NSNumber *)sender;
    int num = [number intValue];
    int mode = num / 10;
    int position = num % 10;
    if(mode == 1)
    {
        [brain okPressed];
    }
    else
    {
        if(position != mode)
        {
            [brain cancelPressed];
        }
        else
        {
            [brain okPressed];
        }
    }
    [self syncInputLabel];
    [self setNotEditingWhenPressedOtherButton];
    [self updateUndoRedoIndicator];
    justPressedAC = NO;
    [self clearResultLabel];
}

#pragma mark - NSFetchResultDelegate


- (NSFetchedResultsController *)fetchedResultsController {
    
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"AnswerTableResult" inManagedObjectContext:managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSSortDescriptor *sort = [[NSSortDescriptor alloc]
                              initWithKey:@"datetime" ascending:NO];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObject:sort]];
    
    [fetchRequest setFetchBatchSize:20];
    
    NSFetchedResultsController *theFetchedResultsController =
    [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                        managedObjectContext:managedObjectContext sectionNameKeyPath:nil
                                                   cacheName:@"Root"];
    self.fetchedResultsController = theFetchedResultsController;
    _fetchedResultsController.delegate = self;
    
    return _fetchedResultsController;
    
}

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    // The fetch controller is about to start sending change notifications, so prepare the table view for updates.
    [answerTableView beginUpdates];
}


- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
    
    UITableView *tableView = answerTableView;
    
    switch(type) {
            
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            [self updateNoRecordPlaceHolder];
            break;
            
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [self updateNoRecordPlaceHolder];
            break;
            
        case NSFetchedResultsChangeUpdate:
            [self configureCell:[tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
            break;
            
        case NSFetchedResultsChangeMove:
            [tableView deleteRowsAtIndexPaths:[NSArray
                                               arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [tableView insertRowsAtIndexPaths:[NSArray
                                               arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}


- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id )sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type {
    
    switch(type) {
            
        case NSFetchedResultsChangeInsert:
            [answerTableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            [self updateNoRecordPlaceHolder];
            break;
            
        case NSFetchedResultsChangeDelete:
            [answerTableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            [self updateNoRecordPlaceHolder];
            break;
    }
}


- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    // The fetch controller has sent all current change notifications, so tell the table view to process all updates.
    [answerTableView endUpdates];
}


#pragma mark - Aggreate Functions


- (void)aveFunction
{
    [self aggreateFunction:@"average" displayName:@"Mean"];
}

- (void)sumFunction
{
    [self aggreateFunction:@"sum" displayName:@"Sum"];
}

- (void)stddevFunction
{
    [self aggreateFunction:@"stddev" displayName:@"Standard deviation"];
}


- (void)aggreateFunction:(NSString*)functionName displayName:(NSString*)displayName;
{
    NSArray* cells = [answerTableView indexPathsForSelectedRows];
    
    
    NSMutableString *str = [functionName mutableCopy];
    
    [str appendString:@"("];
    
    
    for(int i = 0; i < cells.count; i++)
    {
        NSIndexPath *path = cells[i];
        AnswerTableResult *object = [_fetchedResultsController objectAtIndexPath:path];
        [str appendString:object.result];
        if(i < cells.count - 1)
        {
            [str appendString:@","];
        }
    }
    
    [str appendString:@")"];
    
    [self allClearPressed:nil];

    [brain appendACompoundString:str];
    
    [self goPressed:nil];
    
    [inputScrollViewController setInfoText:[NSString stringWithFormat:@"%@ of %d number%@",displayName, cells.count,cells.count > 1 ? @"s" : @"" ]];
    
}




#pragma mark - Drag and Drop

-(void) handleLongPress: (UIGestureRecognizer *)longPress {
    if (longPress.state==UIGestureRecognizerStateBegan) {
        if(answerTableView.isEditing)
        {
            CGPoint pressPoint = [longPress locationInView:answerTableView];
            NSIndexPath *indexPath = [answerTableView indexPathForRowAtPoint:pressPoint];
            
            AnswerTableResult *result = [_fetchedResultsController objectAtIndexPath:indexPath];
            
            
            dragView = [self.storyboard instantiateViewControllerWithIdentifier:@"DragNumberView"];
            [dragView setResult:result.result];
            
//            CGRect rect = dragView.view.frame;
//            rect.origin = pressPoint;
//            rect.origin.x += answerTableView.frame.origin.x - 100;
//            rect.origin.y += answerTableView.frame.origin.y;
//            
//            rect.size.width = 248;
//            rect.size.height = 56;
//            dragView.view.frame = rect;

            CGPoint dragViewPosition = [longPress locationInView:self.view];
            dragView.view.center = dragViewPosition;
            
            [self.view addSubview:dragView.view];
        }
        
    }
//    else if(longPress.state==UIGestureRecognizerStateEnded)
//    {
//        [dragView removeFromParentViewController];
//    }
}


@end
