//
//  Brain.h
//  UltraCalc
//
//  Created by Song  on 12-4-14.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DDMathEvaluator;

@interface Brain : NSObject
{
    NSMutableArray  *expressionQueue;
    NSMutableArray  *calculateExpressionQueue;
    NSString        *lastError;
    
    NSMutableString* displayString;
    NSMutableString* calculateString;
    
    DDMathEvaluator *evaluator;
    
    NSUndoManager *undoManager;
    
    
    BOOL errorOccured;
    NSString* resultString;

    BOOL justEvaluated;
    
    NSNumber *lastResult;
}

@property (nonatomic,readonly) NSString* displayString;
@property (nonatomic,readonly) NSString* calculateString;
@property (nonatomic,readonly) NSString* resultString;
@property (nonatomic,readonly) BOOL errorOccured;
@property (nonatomic,readonly) NSUndoManager *undoManager;


+ (Brain*)sharedBrain;

- (void)appendDigit:(NSString*)str;
- (void)appendDot:(NSString*)str;
- (void)appendOperator:(NSString*)str;
- (void)appendFunction:(NSString*)str;
- (void)appendLeftParenthese;
- (void)appendRightParenthese;
- (void)appendPI;
- (void)appendPercent;
- (void)appendACompoundString:(NSString*)str;
- (void)appendFixPower:(NSString*)str;

- (void)removeLastToken;

- (void)clearQueue;

- (NSNumber*) evaluate;


- (void)previousPressed;
- (void)nextPressed;
- (void)cancelPressed;
- (void)okPressed;


@end
