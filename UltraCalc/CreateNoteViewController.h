//
//  CreateNoteViewController.h
//  UltraCalc
//
//  Created by Song  on 12-7-19.
//
//

#import <UIKit/UIKit.h>
#import "NoteEditingProtocal.h"
@interface CreateNoteViewController : UIViewController
{
    NSString *text;
}
@property (weak, nonatomic) IBOutlet UIView *greyCover;
@property (weak, nonatomic) IBOutlet UIView *inputView;
@property (weak, nonatomic) IBOutlet UITextView *noteTextView;
@property (weak, nonatomic) IBOutlet UIButton *okButton;

@property (strong,nonatomic) id<NoteEditingProtocal> delegate;

- (IBAction)okPressed:(id)sender;
- (void)setDefaultText:(NSString*)text;


@end
