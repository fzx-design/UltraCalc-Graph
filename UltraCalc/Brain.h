//
//  Brain.h
//  UltraCalc
//
//  Created by Song  on 12-4-14.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Brain : NSObject
{
    NSMutableArray  *expressionQueue;
    NSMutableArray  *calculateExpressionQueue;
    NSString        *lastError;
    
    NSMutableString* displayString;
    NSMutableString* calculateString;
}

@property (nonatomic,readonly) NSString* displayString;
@property (nonatomic,readonly) NSString* calculateString;

+ (Brain*)sharedBrain;

- (void)appendDigit:(NSString*)str;
- (void)appendDot:(NSString*)str;
- (void)appendOperator:(NSString*)str;
- (void)appendFunction:(NSString*)str;
- (void)appendLeftParenthese;
- (void)appendRightParenthese;

- (void)removeLastToken;

- (void)clearQueue;

@end
