//
//  ViewController.m
//  UltraCalc
//
//  Created by Song  on 12-3-25.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"
#import "DDMathParser.h"
#import "MultipleButtonDataSource.h"
#import "MultipleButtonViewController.h"
#import "InputScrollViewController.h"
#import "FXLabel.h"

@interface ViewController ()

@end

@implementation ViewController


- (void)syncInputLabel
{
    [inputScrollViewController setText:brain.displayString];
    
    [inputScrollViewController clearAllRect];
    [inputScrollViewController showRectFromCharIndex:0 toIndex:5];
    [inputScrollViewController showRectFromCharIndex:2 toIndex:4];
}


- (DDMathEvaluator *)evaluator {
    if (evaluator == nil) {
       
        evaluator = [[DDMathEvaluator alloc] init];
                    
    }
    return evaluator;
}

- (void) evaluate {
    DDMathEvaluator *eval = [self evaluator];
    NSMutableDictionary * variables = [NSMutableDictionary dictionary];//useless
    
	NSString * string = brain.calculateString;
    NSLog(@"calculate string:%@",string);
    //[inputScrollViewController setText:string];
    
    
	NSError *error = nil;
	if ([string length] > 0) {
		DDExpression * expression = [DDExpression expressionFromString:string error:&error];
		if (error == nil) {
			NSLog(@"parsed: %@", expression);
			//[self updateVariablesWithExpression:expression];
			NSNumber * result = [expression evaluateWithSubstitutions:variables evaluator:eval error:&error];
			if (error == nil) {
				[resultLabel setTextColor:[UIColor whiteColor]];
				[resultLabel setText:[result description]];
                
                //TODO add to answer table
                AnswerCellModel *newCell = [[AnswerCellModel alloc] init];
                newCell.result = resultLabel.text;
                newCell.note = nil;
                newCell.expression = brain.displayString;
                
                [[AnswerTableModel sharedModel] addNewCell:newCell];
                //[answerTableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationBottom];
                //[answerTableView reloadData];
                NSIndexPath *path1 = [NSIndexPath indexPathForRow:0 inSection:0];
                
                NSArray *indexArray = [NSArray arrayWithObjects:path1,nil];
                
                [answerTableView insertRowsAtIndexPaths:indexArray withRowAnimation:UITableViewRowAnimationLeft];
			}
		}
	} else {
		[resultLabel setText:@""];
		[variables removeAllObjects];
	}
	if (error != nil) {
		NSLog(@"error: %@", error);
		[resultLabel setTextColor:[UIColor redColor]];
        [resultLabel setText:@"Error"];
	}
	
	//[variableList reloadData];		
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

- (void)loadInputScrollView
{
    inputScrollViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"InputScrollView"];
    [inputView addSubview:inputScrollViewController.view];
    
    CGRect rect= inputView.frame;
    [[inputScrollViewController view] setFrame:rect];
    
}


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

- (void)initResultLabel
{
    [resultLabel setFont:[UIFont fontWithName:@"Eurostile" size:32]];
    resultLabel.shadowColor = nil;
    resultLabel.shadowOffset = CGSizeMake(0.0f, 2.0f);
    resultLabel.shadowColor = [UIColor colorWithRed:158/255.0 green:1 blue:1 alpha:0.8];  
    resultLabel.shadowBlur = 3.0f;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
        
    [self loadMultipleButtons];

    [self loadInputScrollView];
    
    [self initResultLabel];
    
    answerTableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"cell_bg.png"]];

    
    answerTableView.allowsMultipleSelectionDuringEditing = YES;
    
    
    if(brain == nil)
        brain = [Brain sharedBrain];
    
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
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}




-(IBAction)digitPressed:(id)sender
{
    NSLog(@"digitPressed");
    UIButton *btn = (UIButton*) sender;
    
    [brain appendDigit:[NSString stringWithFormat:@"%d",btn.tag]];
    
    [self syncInputLabel];
}


-(IBAction)delPressed:(id)sender
{
    NSLog(@"delPressed");
    
    [brain removeLastToken];
    
    [self syncInputLabel];
}

-(IBAction)allClearPressed:(id)sender
{
    NSLog(@"allClearPressed");
    [brain clearQueue];
    
    [self syncInputLabel];
    
    resultLabel.text = @"";
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
    
}
-(IBAction)positiveMinusPressed:(id)sender
{
    NSLog(@"positiveMinusPressed");
    
    
}
-(IBAction)dotPressed:(id)sender
{
    NSLog(@"dotPressed");
    [brain appendDot:@"."];
    [self syncInputLabel];
}

-(IBAction)leftParenthesePressed:(id)sender
{
    [brain appendLeftParenthese];
    
    [self syncInputLabel];
}

-(IBAction)rightParenthesePressed:(id)sender
{
    [brain appendRightParenthese];
    
    [self syncInputLabel];

}

-(IBAction)goPressed:(id)sender
{
    NSLog(@"goPressed");
    [self evaluate];
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
            [dict setObject:@"button_log.png" forKey:@"normal"];
            [dict setObject:@"button_log.png" forKey:@"highlight"];
            [dict setObject:@"log" forKey:@"id"];
            return dict;
        }
        else if(index == 1)
        {
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            [dict setObject:@"button_ln.png" forKey:@"normal"];
            [dict setObject:@"button_ln.png" forKey:@"highlight"];
            [dict setObject:@"ln" forKey:@"id"];
            return dict;
        }
        else if(index == 2)
        {
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            [dict setObject:@"button_logxy.png" forKey:@"normal"];
            [dict setObject:@"button_logxy.png" forKey:@"highlight"];
            [dict setObject:@"logxy" forKey:@"id"];
            return dict;
        }
    }
    else if(button == sqrtMultipleButton)
    {
        if(index == 0)
        {
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            [dict setObject:@"button_root.png" forKey:@"normal"];
            [dict setObject:@"button_root.png" forKey:@"highlight"];
            [dict setObject:@"root" forKey:@"id"];
            return dict;
        }
        else if(index == 1)
        {
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            [dict setObject:@"button_root3.png" forKey:@"normal"];
            [dict setObject:@"button_root3.png" forKey:@"highlight"];
            [dict setObject:@"root3" forKey:@"id"];
            return dict;
        }
        else if(index == 2)
        {
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            [dict setObject:@"button_rootx.png" forKey:@"normal"];
            [dict setObject:@"button_rootx.png" forKey:@"highlight"];
            [dict setObject:@"rootx" forKey:@"id"];
            return dict;
        }
    }
    else if(button == sinMultipleButton)
    {
        if(index == 0)
        {
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            [dict setObject:@"button_sin.png" forKey:@"normal"];
            [dict setObject:@"button_sin.png" forKey:@"highlight"];
            [dict setObject:@"sin" forKey:@"id"];
            return dict;
        }
        else if(index == 1)
        {
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            [dict setObject:@"button_cos.png" forKey:@"normal"];
            [dict setObject:@"button_cos.png" forKey:@"highlight"];
            [dict setObject:@"cos" forKey:@"id"];
            return dict;
        }
        else if(index == 2)
        {
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            [dict setObject:@"button_tan.png" forKey:@"normal"];
            [dict setObject:@"button_tan.png" forKey:@"highlight"];
            [dict setObject:@"tan" forKey:@"id"];
            return dict;
        }
    }
    else if(button == arcsinMultipleButton)
    {
        if(index == 0)
        {
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            [dict setObject:@"button_arcsin.png" forKey:@"normal"];
            [dict setObject:@"button_arcsin.png" forKey:@"highlight"];
            [dict setObject:@"arcsin" forKey:@"id"];
            return dict;
        }
        else if(index == 1)
        {
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            [dict setObject:@"button_arccos.png" forKey:@"normal"];
            [dict setObject:@"button_arccos.png" forKey:@"highlight"];
            [dict setObject:@"arccos" forKey:@"id"];
            return dict;
        }
        else if(index == 2)
        {
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            [dict setObject:@"button_arctan.png" forKey:@"normal"];
            [dict setObject:@"button_arctan.png" forKey:@"highlight"];
            [dict setObject:@"arctan" forKey:@"id"];
            return dict;
        }
    }
    else if(button == sinhMultipleButton)
    {
        if(index == 0)
        {
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            [dict setObject:@"button_sinh.png" forKey:@"normal"];
            [dict setObject:@"button_sinh.png" forKey:@"highlight"];
            [dict setObject:@"sinh" forKey:@"id"];
            return dict;
        }
        else if(index == 1)
        {
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            [dict setObject:@"button_cosh.png" forKey:@"normal"];
            [dict setObject:@"button_cosh.png" forKey:@"highlight"];
            [dict setObject:@"cosh" forKey:@"id"];
            return dict;
        }
        else if(index == 2)
        {
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            [dict setObject:@"button_tanh.png" forKey:@"normal"];
            [dict setObject:@"button_tanh.png" forKey:@"highlight"];
            [dict setObject:@"tanh" forKey:@"id"];
            return dict;
        }
    }
    else if(button == xyMultipleButton)
    {
        if(index == 0)
        {
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            [dict setObject:@"button_x2.png" forKey:@"normal"];
            [dict setObject:@"button_x2.png" forKey:@"highlight"];
            [dict setObject:@"x2" forKey:@"id"];
            return dict;
        }
        else if(index == 1)
        {
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            [dict setObject:@"button_x3.png" forKey:@"normal"];
            [dict setObject:@"button_x3.png" forKey:@"highlight"];
            [dict setObject:@"x3" forKey:@"id"];
            return dict;
        }
        else if(index == 2)
        {
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            [dict setObject:@"button_xy.png" forKey:@"normal"];
            [dict setObject:@"button_xy.png" forKey:@"highlight"];
            [dict setObject:@"xy" forKey:@"id"];
            return dict;
        }
    }

    return nil;
}


-(void)pressedButtonWithIdentifier:(NSString*)identifier
{
    NSLog(@"%@",identifier);
    
    [brain appendFunction:[NSString stringWithFormat:@"%@",identifier]];
    
    [self syncInputLabel];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[AnswerTableModel sharedModel] cellCount];
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell = [tableView
                             dequeueReusableCellWithIdentifier:@"answerCell"];
	AnswerCellModel *cellModel = [[AnswerTableModel sharedModel] cellModelAtIndex:indexPath.row];
    
    UILabel *cellResultLabel = (UILabel *)[cell viewWithTag:101];
	cellResultLabel.text = cellModel.result;
    
	UILabel *cellExpressionLabel = (UILabel *)[cell viewWithTag:102];
	cellExpressionLabel.text = cellModel.expression;
    
    cell.selectedBackgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cell_hover_bg.png"]];
    
    
    //cellResultLabel.highlightedTextColor = [UIColor redColor];
    //cellExpressionLabel.highlightedTextColor =  [UIColor redColor];
    
    
	UIImageView * noteImageView = (UIImageView *)[cell viewWithTag:103];
    if(cellModel.note)
    {
        noteImageView.hidden = NO;
    }
    else {
        noteImageView.hidden = YES;
    }
    
	
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
    switch (buttonIndex) {
        case 0://copy
            ;
            break;
        case 1://use result
            ;
            break;
        case 2://Edit note
            break;
        case 3://Delete
            //answerTableView.
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


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        
    
    if (!tableView.isEditing) {
        [self showCellActionListForCell:cell];
    }
    
    
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (editingStyle == UITableViewCellEditingStyleDelete)
	{
		[[AnswerTableModel sharedModel] removeCellAtIndex:indexPath.row];
		[tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
	}
}


-(IBAction)editAnswerTable:(id)sender
{
    BOOL isEditing = answerTableView.editing;
    [answerTableView setEditing:!isEditing animated:YES];
    answerTableEditDeleteButton.hidden = isEditing;
    float expectAlpha = isEditing?0:1;
    [UIView animateWithDuration:0.1f animations:^{
        editAnswerPressedIndicator.alpha = expectAlpha;
    }];
}

-(IBAction)deleteTableCells:(id)sender
{
    NSArray* cellsToDelete = [answerTableView indexPathsForSelectedRows];

    for(NSIndexPath *path in cellsToDelete)
    {
        NSInteger row = path.row;
        //NSInteger section = path.section;
        [[AnswerTableModel sharedModel] removeCellAtIndex:row];
    }
    
    [answerTableView deleteRowsAtIndexPaths:cellsToDelete withRowAnimation:UITableViewRowAnimationRight];
}

@end
