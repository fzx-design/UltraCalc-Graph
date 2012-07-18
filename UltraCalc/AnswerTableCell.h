//
//  AnswerTableCell.h
//  UltraCalc
//
//  Created by Song  on 12-7-18.
//
//

#import <UIKit/UIKit.h>

@interface AnswerTableCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *answerLabel;
@property (weak, nonatomic) IBOutlet UILabel *expressionLabel;
@property (weak, nonatomic) IBOutlet UIButton *noteIndicator;

@end
