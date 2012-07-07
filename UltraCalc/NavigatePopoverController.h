//
//  NavigatePopoverController.h
//  UltraCalc
//
//  Created by Song  on 12-7-3.
//
//

#import <UIKit/UIKit.h>
#import "NavigatePopoverProtocal.h"

@interface NavigatePopoverController : UIViewController
{
    NSNumber *mode;
    NSNumber *position;
}
@property (weak, nonatomic) IBOutlet UIButton *centerButton;
@property (weak, nonatomic) IBOutlet UIButton *leftButton;
@property (weak, nonatomic) IBOutlet UIButton *rightButton;

@property (nonatomic) id<NavigatePopoverProtocal> delegate;

-(void)setModeWithBlankCount:(int)blankCount andCurrentPosition:(int)cursor;

-(IBAction)leftButtonPressed:(id)sender;
-(IBAction)rightButtonPressed:(id)sender;
-(IBAction)centerButtonPressed:(id)sender;


@end
