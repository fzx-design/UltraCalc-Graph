//
//  DragNumberViewController.h
//  UltraCalc
//
//  Created by Song  on 12-7-16.
//
//

#import <UIKit/UIKit.h>

@interface DragNumberViewController : UIViewController
{
    NSString *text;
}

@property (weak, nonatomic) IBOutlet UILabel *resultLabel;
@property (weak, nonatomic) IBOutlet UIImageView *background;
@property (weak, nonatomic) IBOutlet UIImageView *dragingShadow;


-(void)setOnDrag:(BOOL)draging;
-(void)setResult:(NSString*)str;


@end
