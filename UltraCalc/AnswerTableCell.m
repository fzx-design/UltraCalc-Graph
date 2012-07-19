//
//  AnswerTableCell.m
//  UltraCalc
//
//  Created by Song  on 12-7-18.
//
//

#import "AnswerTableCell.h"
#import "ViewController.h"
#import "Note.h"
#import "AnswerTableResult.h"

@implementation AnswerTableCell
@synthesize answerLabel;
@synthesize expressionLabel;
@synthesize noteIndicator;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (IBAction)notePressed:(id)sender
{
    AnswerTableResult *result = [self.ancenster.fetchedResultsController objectAtIndexPath:self.index];
    Note *note = result.tableToNoteRelation;
    NSLog(@"%@",note.note);
}
@end
