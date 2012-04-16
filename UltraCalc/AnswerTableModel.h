//
//  AnswerTableModel.h
//  UltraCalc
//
//  Created by Song  on 12-4-4.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AnswerCellModel.h"
@interface AnswerTableModel : NSObject
{
    NSMutableArray *cellArray;
}

-(void)addNewCell:(AnswerCellModel*) cell;
-(int)cellCount;
-(AnswerCellModel*)cellModelAtIndex:(int)index;

-(void)removeCellAtIndex:(int)index;

+(AnswerTableModel*)sharedModel;



@end
