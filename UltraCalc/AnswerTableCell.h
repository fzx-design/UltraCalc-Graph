//
//  AnswerTableCell.h
//  UltraCalc
//
//  Created by Song  on 12-7-18.
//
//

#import <UIKit/UIKit.h>


@class ViewController;
@interface AnswerTableCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *answerLabel;
@property (weak, nonatomic) IBOutlet UILabel *expressionLabel;
@property (weak, nonatomic) IBOutlet UIButton *noteIndicator;

@property (weak, nonatomic) ViewController *ancenster;
@property (retain, nonatomic) NSIndexPath* index;

- (IBAction)notePressed:(id)sender;

@end
