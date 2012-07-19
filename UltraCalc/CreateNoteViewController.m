//
//  CreateNoteViewController.m
//  UltraCalc
//
//  Created by Song  on 12-7-19.
//
//

#import "CreateNoteViewController.h"

@interface CreateNoteViewController ()

@end

@implementation CreateNoteViewController
@synthesize greyCover;
@synthesize inputView;
@synthesize noteTextView;
@synthesize okButton;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    CGRect frame = inputView.frame;
    frame.origin.y -= frame.size.height;
    inputView.frame = frame;
    frame.origin.y += frame.size.height;
    
    greyCover.alpha = 0;
    
    [UIView animateWithDuration:0.3f animations:^(void){
        greyCover.alpha = 0.6;
        inputView.frame = frame;
    }];
    
    noteTextView.text = text;
    [noteTextView becomeFirstResponder];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

- (void)viewDidUnload {
    [self setGreyCover:nil];
    [self setInputView:nil];
    [self setNoteTextView:nil];
    [self setOkButton:nil];
    [super viewDidUnload];
}

- (void)setDefaultText:(NSString*)aText
{
    text = aText;
}

- (IBAction)okPressed:(id)sender {
    NSLog(@"ok pressed on note");
    
    [self.delegate didFinishedNoteEditingWithText:noteTextView.text];
    
    CGRect frame = inputView.frame;
    frame.origin.y -= frame.size.height;
    
    
    [UIView animateWithDuration:0.3 animations:^(void){
        greyCover.alpha = 0;
        inputView.frame = frame;
    }
    completion:^(BOOL finish)
    {
        [self.view removeFromSuperview];
    }];
    
}
@end
