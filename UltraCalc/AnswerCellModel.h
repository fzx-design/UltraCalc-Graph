//
//  AnswerCellModel.h
//  UltraCalc
//
//  Created by Song  on 12-4-4.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum
{
    AnswerCellText,
    AnswerCellGraph
}CellType;

@interface AnswerCellModel : NSObject
{
    NSString *expression;
    NSString *result;
    NSString *note;
    CellType cellType;
}

@property (nonatomic,retain)  NSString *expression;
@property (nonatomic,retain)  NSString *result;
@property (nonatomic,retain)  NSString *note;

@end
