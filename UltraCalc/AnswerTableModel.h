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


-(void)addNewCell:(AnswerCellModel*) cell;
-(void)cellCount;


@end
