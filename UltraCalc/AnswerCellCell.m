//
//  AnswerCellCell.m
//  UltraCalc
//
//  Created by Song  on 12-3-29.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "AnswerCellCell.h"

@implementation AnswerCellCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

//- (void)setFrame:(CGRect)frame {
//    float inset = 33;
//    frame.origin.x += inset;
//    frame.size.width -= inset + 4;
//    [super setFrame:frame];
//}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
