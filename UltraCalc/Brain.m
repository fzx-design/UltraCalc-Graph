//
//  Brain.m
//  UltraCalc
//
//  Created by Song  on 12-4-14.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "Brain.h"

@implementation Brain

@synthesize displayString,calculateString;

- (id)init
{
    if(self  =  [super init])
    {
        expressionQueue = [[NSMutableArray alloc] init];
    }
    return self;
}

static Brain* instance = nil;

+ (Brain*)sharedBrain
{
    if(!instance)
    {
        instance = [[Brain alloc] init];
    }
    return instance;
}


- (void)append:(NSString*)str
{
    [expressionQueue addObject:str];
}


- (void)appendLeftParenthese
{
    [self append:@"("];
}
- (void)appendRightParenthese
{
    [self append:@")"];
}


- (void)appendDigit:(NSString*)str
{
    [self append:str];
}

- (void)appendDot:(NSString*)str
{
    if(![expressionQueue lastObject])
    {
        [self appendDigit:@"0"];
    }
    [self append:str];
}

- (void)appendOperator:(NSString*)str
{
    if(![expressionQueue lastObject])
    {
        if([str isEqualToString:@"+"] || [str isEqualToString:@"-"])
        {
            
        }
        else {
            [self appendDigit:@"0"];
        }
    }
    [self append:str];
}

- (void)appendFunction:(NSString*)str
{
    [self append:str];
}



- (void)removeLastToken
{
    if ([expressionQueue lastObject]) {
        [expressionQueue removeLastObject];
    }
}


- (NSString*)displayString
{
    NSMutableString *s = [NSMutableString stringWithFormat:@""];
    for (NSString *str in expressionQueue)
    {
        [s appendString:str];
    }
    if([s isEqualToString:@""])
    {
        return @"0";
    }
    return s;
}



- (BOOL) isTriangleFunction:(NSString*)str
{
    BOOL result = NO;
    if([str isEqualToString:@"sin"])
    {
        result = YES;
    }
    else if([str isEqualToString:@"cos"])
    {
        result = YES;
    }
    else if([str isEqualToString:@"tan"])
    {
        result = YES;
    }
    else if([str isEqualToString:@"sinh"])
    {
        result = YES;
    }
    else if([str isEqualToString:@"cosh"])
    {
        result = YES;
    }
    else if([str isEqualToString:@"tanh"])
    {
        result = YES;
    }
    else if([str isEqualToString:@"arcsin"])
    {
        result = YES;
    }
    else if([str isEqualToString:@"arccos"])
    {
        result = YES;
    }
    else if([str isEqualToString:@"arctan"])
    {
        result = YES;
    }
    
    return result;
}


- (int)termRecognizerWithQueue:(NSMutableArray*)a andStartFrom:(int)start
{
    int parenthese = 0;
    BOOL numberScaned = NO;
    
    for(int i = start; i < a.count; i++)
    {
        NSString *str = [a objectAtIndex:i];
        if([str isEqualToString:@"("])
        {
            parenthese++;
        }
        else if([str isEqualToString:@")"])
        {
            parenthese--;
        }
        else if(([str isEqualToString:@"+"] || [str isEqualToString:@"-"] || [str isEqualToString:@"*"] || [str isEqualToString:@"/"]) && parenthese == 0 && numberScaned)
        {
            return i;
            break;
        }
        else //preesumption : should be a number
        {
            numberScaned = YES;
        }
    }
    return a.count;
}


- (NSMutableArray*)addParentheseToTriangleFunctions:(NSMutableArray*)array
{
    NSMutableArray *a = [NSMutableArray arrayWithArray:array];
      
    for(int i = 0; i < a.count; i++)
    {
        NSString *str = [a objectAtIndex:i];
        if([self isTriangleFunction:str])
        {
            [a insertObject:@"(" atIndex:i + 1];
            
            int anotherParenthesePosition = [self termRecognizerWithQueue:a andStartFrom:i + 2];
            if(anotherParenthesePosition >=0 )
            {
                [a insertObject:@")" atIndex:anotherParenthesePosition];
            }
        }
    }
    
    return a;
}


- (NSString*)calculateString
{
    NSMutableString *s = [NSMutableString stringWithFormat:@""];
    calculateExpressionQueue = [NSMutableArray arrayWithArray:expressionQueue];
    
    calculateExpressionQueue = [self addParentheseToTriangleFunctions:calculateExpressionQueue];
    
    
    for (NSString *str in calculateExpressionQueue)
    {
        [s appendString:str];
    }
    if([s isEqualToString:@""])
    {
        return @"0";
    }
    return s;
}


- (void)clearQueue
{
    [expressionQueue removeAllObjects];
}
@end
