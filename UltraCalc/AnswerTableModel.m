//
//  AnswerTableModel.m
//  UltraCalc
//
//  Created by Song  on 12-4-4.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "AnswerTableModel.h"

@implementation AnswerTableModel

static AnswerTableModel* instance = nil;

+(AnswerTableModel*)sharedModel
{
    if(!instance)
    {
        instance = [[AnswerTableModel alloc] init];
    }
    return instance;
}

-(void)removeCellAtIndex:(int)index
{
    [cellArray removeObjectAtIndex:index];
}

-(void)removeCellsAtIndexSet:(NSIndexSet*)set
{
    [cellArray removeObjectsAtIndexes:set];
}

- (id)init
{
   if(self = [super init])
   {
       cellArray = [NSMutableArray array];
   }
    return self;
}

-(void)addNewCell:(AnswerCellModel*) cell
{
    [cellArray insertObject:cell atIndex:0];
}

-(int)cellCount
{
    return [cellArray count];
}

-(AnswerCellModel*)cellModelAtIndex:(int)index
{
    return [cellArray objectAtIndex:index];
}

@end
