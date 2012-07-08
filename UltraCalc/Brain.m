//
//  Brain.m
//  UltraCalc
//
//  Created by Song  on 12-4-14.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "Brain.h"
#import "DDMathParser.h"


@interface Brain()

@property BOOL justEvaluated;

@end



@implementation Brain

@synthesize displayString,calculateString,errorOccured,resultString,justEvaluated,undoManager;

-(void)customFunctions
{
    {
        DDMathFunction function = ^ DDExpression* (NSArray *args, NSDictionary *variables, DDMathEvaluator *evaluator, NSError **error) {
            if ([args count] != 2) {
                //fill in *error and return nil
            }
            NSString *string = [NSString stringWithFormat:@"log(%@)/log(%@)",args[1],args[0]];
            DDExpression *expression = [DDExpression expressionFromString:string error:error];
            NSNumber * n = [expression evaluateWithSubstitutions:variables evaluator:self.evaluator error:error];
            return [DDExpression numberExpressionWithNumber:n];
        };
        [self.evaluator registerFunction:function forName:@"logxy"];
    }
    
    {
        DDMathFunction function2 = ^ DDExpression* (NSArray *args, NSDictionary *variables, DDMathEvaluator *evaluator, NSError **error) {
            if ([args count] != 2) {
                //fill in *error and return nil
            }
            NSString *string = [NSString stringWithFormat:@"nthroot(%@,%@)",args[1],args[0]];
            DDExpression *expression = [DDExpression expressionFromString:string error:error];
            NSNumber * n = [expression evaluateWithSubstitutions:variables evaluator:self.evaluator error:error];
            return [DDExpression numberExpressionWithNumber:n];
        };
        [self.evaluator  registerFunction:function2 forName:@"Rootx"];
    }
}



- (id)init
{
    if(self  =  [super init])
    {
        expressionQueue = [[NSMutableArray alloc] init];
        undoManager = [[NSUndoManager alloc] init];
        [self customFunctions];
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
    NSString *lastStr = [expressionQueue lastObject];
    if([lastStr rangeOfString:@"I"].length > 0)
    {
        if([str rangeOfString:@"I"].length > 0)
        {
            str = [str stringByReplacingOccurrencesOfString:@"I" withString:@"K"];
        }
        NSString *leftPart = [lastStr substringToIndex:[lastStr rangeOfString:@"I"].location];
        NSString *rightPart = [lastStr substringFromIndex:[lastStr rangeOfString:@"I"].location];
        NSString *strToAdd = [NSString stringWithFormat:@"%@%@%@",leftPart,str,rightPart];
        
        if([str rangeOfString:@"K"].length > 0)
        {
            strToAdd = [strToAdd stringByReplacingOccurrencesOfString:@"I" withString:@"T"];
            strToAdd = [strToAdd stringByReplacingOccurrencesOfString:@"K" withString:@"I"];
        }        
        [expressionQueue removeLastObject];
        [expressionQueue addObject:strToAdd];
    }
    else
    {
        [expressionQueue addObject:str];
    }
}

- (void)previousPressed
{
    NSMutableString *lastStr = [[expressionQueue lastObject] mutableCopy];
    
    int lastTPos = -1;
    int iPos = -1;
    for(int i = 0; i < lastStr.length ; i++)
    {
        if([lastStr characterAtIndex:i] == 'T')
        {
            lastTPos = i;
        }
        else if([lastStr characterAtIndex:i] == 'I')
        {
            iPos = i;
            break;
        }
    }
    if(lastTPos != -1)
    {
        [lastStr replaceCharactersInRange:NSMakeRange(lastTPos, 1) withString:@"I"];
        [lastStr replaceCharactersInRange:NSMakeRange(iPos, 1) withString:@"T"];
        
        [expressionQueue removeLastObject];
        [expressionQueue addObject:lastStr];
    }
}

- (void)nextPressed
{
    NSMutableString *lastStr = [[expressionQueue lastObject] mutableCopy];
    
    int lastTPos = -1;
    int iPos = -1;
    for(int i = lastStr.length - 1; i >=0 ; i--)
    {
        if([lastStr characterAtIndex:i] == 'T')
        {
            lastTPos = i;
        }
        else if([lastStr characterAtIndex:i] == 'I')
        {
            iPos = i;
            break;
        }
    }
    if(lastTPos != -1)
    {
        [lastStr replaceCharactersInRange:NSMakeRange(lastTPos, 1) withString:@"I"];
        [lastStr replaceCharactersInRange:NSMakeRange(iPos, 1) withString:@"T"];
        
        [expressionQueue removeLastObject];
        [expressionQueue addObject:lastStr];
    }

}

- (void)cancelPressed
{
    [expressionQueue removeLastObject];
}

- (void)okPressed
{
    NSMutableString *lastStr = [[expressionQueue lastObject] mutableCopy];
    if([lastStr rangeOfString:@"I"].length > 0)
    {
        [lastStr replaceOccurrencesOfString:@"I" withString:@"" options:NSLiteralSearch range:NSMakeRange(0, lastStr.length)];
        [lastStr replaceOccurrencesOfString:@"J" withString:@"" options:NSLiteralSearch range:NSMakeRange(0, lastStr.length)];
        [expressionQueue removeLastObject];
        [expressionQueue addObject:lastStr];
    }
}



- (void)appendLeftParenthese
{
    [undoManager registerUndoWithTarget:self
                               selector:@selector(restoreExpressionQueueToThis:) 
                                 object:[expressionQueue copy]];

    if(justEvaluated)
    {
        [expressionQueue removeAllObjects];
    }
    [self append:@"("];
    justEvaluated = NO;
}

- (void)appendRightParenthese
{
    [undoManager registerUndoWithTarget:self
                               selector:@selector(restoreExpressionQueueToThis:) 
                                 object:[expressionQueue copy]];
    if(justEvaluated)
    {
        [expressionQueue removeAllObjects];
        [self append:@"("];
        [self append:[NSString stringWithFormat:@"%@",resultString]];
    }
    [self append:@")"];
    justEvaluated = NO;
}


- (void)appendDigit:(NSString*)str
{
    [undoManager registerUndoWithTarget:self
                               selector:@selector(restoreExpressionQueueToThis:) 
                                 object:[expressionQueue copy]];
    if(justEvaluated)
    {
        [expressionQueue removeAllObjects];
    }
    [self append:str];
    justEvaluated = NO;
}

- (void)appendDot:(NSString*)str
{
    [undoManager registerUndoWithTarget:self
                               selector:@selector(restoreExpressionQueueToThis:) 
                                 object:[expressionQueue copy]];
    if(justEvaluated)
    {
        [expressionQueue removeAllObjects];
    }
    if(![expressionQueue lastObject])
    {
        [self appendDigit:@"0"];
    }
    [self append:str];
    justEvaluated = NO;
}

- (void)appendACompoundString:(NSString*)str
{
    [undoManager registerUndoWithTarget:self
                               selector:@selector(restoreExpressionQueueToThis:) 
                                 object:[expressionQueue copy]];
    if(justEvaluated)
    {
        [expressionQueue removeAllObjects];
    }
    
    [self append:str];
    justEvaluated = NO;

}


- (void)appendOperator:(NSString*)str
{
    [undoManager registerUndoWithTarget:self
                               selector:@selector(restoreExpressionQueueToThis:) 
                                 object:[expressionQueue copy]];
    
    if(justEvaluated)
    {
        [expressionQueue removeAllObjects];
        [self append:[NSString stringWithFormat:@"%@",resultString]];
    }
    
    [self append:str];
    justEvaluated = NO;
}

- (void)appendFixPower:(NSString*)str
{
    [undoManager registerUndoWithTarget:self
                               selector:@selector(restoreExpressionQueueToThis:) 
                                 object:[expressionQueue copy]];
    
    if(justEvaluated)
    {
        [expressionQueue removeAllObjects];
        [self append:[NSString stringWithFormat:@"%@",resultString]];
    }
    
    [self append:str];
    justEvaluated = NO;
}


- (void)appendFunction:(NSString*)str
{
    [undoManager registerUndoWithTarget:self
                               selector:@selector(restoreExpressionQueueToThis:) 
                                 object:[expressionQueue copy]];
    if(justEvaluated)
    {
        [expressionQueue removeAllObjects];
    }
    [self append:str];
    justEvaluated = NO;
}

- (void)appendPI
{
    [undoManager registerUndoWithTarget:self
                               selector:@selector(restoreExpressionQueueToThis:) 
                                 object:[expressionQueue copy]];
    if(justEvaluated)
    {
        [expressionQueue removeAllObjects];
    }
    [self append:@"P"];
    justEvaluated = NO;
}
- (void)appendPercent
{
    [undoManager registerUndoWithTarget:self
                               selector:@selector(restoreExpressionQueueToThis:) 
                                 object:[expressionQueue copy]];
    if(justEvaluated)
    {
        [expressionQueue removeAllObjects];
        [self append:[NSString stringWithFormat:@"%@",resultString]];
    }
    [self append:@"%"];
    justEvaluated = NO;
}


- (void)removeLastToken
{
    if ([expressionQueue lastObject]) {
        [undoManager registerUndoWithTarget:self
                                   selector:@selector(restoreExpressionQueueToThis:) 
                                     object:[expressionQueue copy]];

        NSMutableString *lastStr = [[expressionQueue lastObject] mutableCopy];
        if([lastStr rangeOfString:@"I"].length > 0)
        {
            NSMutableString *remaining = [[lastStr substringFromIndex:[lastStr rangeOfString:@"("].location + 1] mutableCopy];
            NSString *funcname = [lastStr substringToIndex:[lastStr rangeOfString:@"("].location];
            remaining = [[remaining substringToIndex:remaining.length - 1] mutableCopy];

            NSRange r = [remaining rangeOfString:@"I"];
           ///FIXME: fuck...i can del sin to si = =...
            if(r.location > 0)
            {
                [remaining replaceCharactersInRange:NSMakeRange(r.location - 1, 1) withString:@""];
            }
            lastStr = [NSString stringWithFormat:@"%@(%@)",funcname,remaining];
            
            [expressionQueue removeLastObject];
            [expressionQueue addObject:lastStr];
        }
        else
        {
            [expressionQueue removeLastObject];
        }
    }
    justEvaluated = NO;
}


- (NSString*)displayString
{
    NSMutableString *s = [NSMutableString stringWithFormat:@""];
    NSMutableArray *displayExpressionQueue = [NSMutableArray arrayWithArray:expressionQueue];
    
    NSLog(@"expressionQueue: %@",expressionQueue);
    
    displayExpressionQueue = [self handleCompoundExpressionsForDisplay:displayExpressionQueue];
    //NSLog(@"displayExpressionQueue: %@",displayExpressionQueue);
    
    displayExpressionQueue = [self addParentheseToPowerForDisplay:displayExpressionQueue];
    //NSLog(@"displayExpressionQueue: %@",displayExpressionQueue);
    
    displayExpressionQueue = [self addParentheseToFunctionsForDisplay:displayExpressionQueue];
    //NSLog(@"displayExpressionQueue: %@",displayExpressionQueue);
    
    displayExpressionQueue = [self makeGreyBoxAroundInsertPoint:displayExpressionQueue];
    NSLog(@"displayExpressionQueue: %@",displayExpressionQueue);
    
    for (NSString *str in displayExpressionQueue)
    {
        [s appendString:str];
    }
    
    [s replaceOccurrencesOfString:@"arctan" withString:@"tanu-1v" options:NSLiteralSearch range:NSMakeRange(0, s.length)];
    [s replaceOccurrencesOfString:@"arccos" withString:@"cosu-1v" options:NSLiteralSearch range:NSMakeRange(0, s.length)];
    [s replaceOccurrencesOfString:@"arcsin" withString:@"sinu-1v" options:NSLiteralSearch range:NSMakeRange(0, s.length)];
    
    [s replaceOccurrencesOfString:@"root3" withString:@"B" options:NSLiteralSearch range:NSMakeRange(0, s.length)];
    [s replaceOccurrencesOfString:@"root" withString:@"A" options:NSLiteralSearch range:NSMakeRange(0, s.length)];
    [s replaceOccurrencesOfString:@"x" withString:@"^" options:NSLiteralSearch range:NSMakeRange(0, s.length)];
    return s;
}


- (BOOL) isRToDFunction:(NSString*)str
{
    BOOL result = NO;
    
    NSArray *dict = @[@"sin",@"cos",@"tan"];
    
    for(NSString* i in dict)
    {
        if([i isEqualToString:str])
        {
            result = YES;
        }
    }
    return result;
}



- (BOOL) isTriangleFunction:(NSString*)str
{
    BOOL result = NO;
    
    NSArray *dict = @[@"sin",@"cos",@"tan",@"sinh",@"cosh",@"tanh",@"arcsin",@"arccos",@"arctan"];
    
    for(NSString* i in dict)
    {
        if([i isEqualToString:str])
        {
            result = YES;
        }
    }
    return result;
}


- (BOOL) isFunctionNeedExtendParenthese:(NSString*)str
{
    BOOL result = [self isTriangleFunction:str];
    if(!result)
    {
        NSArray *dict = @[@"root",@"root3",@"log",@"ln"];
        
        for(NSString* i in dict)
        {
            if([i isEqualToString:str])
            {
                result = YES;
            }
        }
    }
    return result;
}



- (int)termRecognizerWithQueue:(NSMutableArray*)a andStartFrom:(int)start
{
    int parenthese = 0;
    BOOL numberScaned = NO;
    
    for(int i = start; i < a.count; i++)
    {
        NSString *str = a[i];
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



- (BOOL) isNumberTerminater:(NSString*)str
{
    BOOL result = NO;
    
    NSArray *dict = @[@")",@"+",@"-",@"*",@"/",@"#"];
    
    for(NSString* i in dict)
    {
        if([i isEqualToString:str])
        {
            result = YES;
        }
    }

    return result;
}



- (NSMutableArray*)addParentheseToFunctionsForDisplay:(NSMutableArray*)array
{
    NSMutableArray *a = [NSMutableArray arrayWithArray:array];
    
    BOOL isInAExtendParentheseFunction = NO;
    
    int parenthese = 0;
    int indexToRemove = -1;
    for(int i = 0; i < a.count; i++)
    {
        NSString *str = a[i];
        
        if(isInAExtendParentheseFunction)
        {
            if([str isEqualToString:@"("])
            {
                parenthese ++;
            }
            if([str isEqualToString:@")"])
            {
                parenthese --;
                
            }
            if([self isNumberTerminater:str])
            {
                if(parenthese == 0)
                {
                    isInAExtendParentheseFunction = NO;
                    [a insertObject:@"]" atIndex:i ];
                    if(i + 1 < a.count && [a[i + 1] isEqualToString:@")"])
                    {
                        [a removeObjectAtIndex:i + 1];
                        [a removeObjectAtIndex:indexToRemove];
                    }
                }
            }
        }
        
        
        if([self isFunctionNeedExtendParenthese:str])
        {
            if(!isInAExtendParentheseFunction)
            {
                [a insertObject:@"[" atIndex:i + 1];
            
                if(i + 2 < a.count && [a[i + 2] isEqualToString:@"("])
                {
                    indexToRemove = i + 2;
                }
                isInAExtendParentheseFunction = YES;
            }
        }
    }
    return a;
}


- (NSMutableArray*)addParentheseToFunctionsForCalc:(NSMutableArray*)array
{
    NSMutableArray *a = [NSMutableArray arrayWithArray:array];
      
    for(int i = 0; i < a.count; i++)
    {
        NSString *str = a[i];
        if([self isFunctionNeedExtendParenthese:str])
        {
            if([self isRToDFunction:str])
            {
                [a insertObject:@"(" atIndex:i + 1];
                [a insertObject:@"(" atIndex:i + 2];
                
                int anotherParenthesePosition = [self termRecognizerWithQueue:a andStartFrom:i + 3];
                
                if(anotherParenthesePosition >=0 )
                {
                    [a insertObject:@")" atIndex:anotherParenthesePosition];
                    [a insertObject:@"°" atIndex:anotherParenthesePosition + 1];
                    [a insertObject:@")" atIndex:anotherParenthesePosition + 2];
                }

            }
            else
            {
                if(i + 1 < a.count)
                {
                    NSString *nextStr = a[i + 1];
                    if([nextStr isEqualToString:@"("])
                    {
                        continue;
                    }
                }
                [a insertObject:@"(" atIndex:i + 1];
                
                int anotherParenthesePosition = [self termRecognizerWithQueue:a andStartFrom:i + 2];
                if(anotherParenthesePosition >=0 )
                {
                    [a insertObject:@")" atIndex:anotherParenthesePosition];
                }

            }
        }
    }
    
    return a;
}


- (NSMutableArray*)makeGreyBoxAroundInsertPoint:(NSMutableArray*)array
{
    NSMutableArray *a = [NSMutableArray arrayWithArray:array];
    
    NSMutableString *str = [[a lastObject] mutableCopy];
    if([str rangeOfString:@"I"].length > 0)
    {
        int i = [str rangeOfString:@"I"].location - 1;
        while(i >= 0)
        {
            if([str characterAtIndex:i] == '[')
            {
                [str replaceCharactersInRange:NSMakeRange(i, 1) withString:@"{"];
                break;
            }
            i--;
        }
        i = [str rangeOfString:@"I"].location + 1;
        while(i < str.length)
        {
            if([str characterAtIndex:i] == ']')
            {
                [str replaceCharactersInRange:NSMakeRange(i, 1) withString:@"}"];
                break;
            }
            i++;
        }
        [a removeLastObject];
        [a addObject:str];
    }
    
    return a;
}



- (NSMutableArray*)handleCompoundExpressionsForDisplay:(NSMutableArray*)array
{
    NSMutableArray *a = [NSMutableArray arrayWithArray:array];
    
    for(int i = a.count - 1; i >= 0; i--)
    {
        NSString *str = a[i];
        if([str hasPrefix:@"x"])//x^y
        {
            str = [str substringFromIndex:1];
            str = [str substringToIndex:str.length - 1];
            str = [NSString stringWithFormat:@"u[ %@ ]v",[str substringFromIndex:1]];
            a[i] = str;
        }
        else if([str hasPrefix:@"logxy"])
        {
            NSMutableString *leftPart;
            NSMutableString *rightPart;
            [self doubleArguementExtraction:str leftPart_p:&leftPart rightPart_p:&rightPart];
            
            str = [NSString stringWithFormat:@"logw[ %@ ]v[ %@ ]",leftPart,rightPart];
            a[i] = str;
        }
        else if([str hasPrefix:@"Rootx"])
        {
            NSMutableString *leftPart;
            NSMutableString *rightPart;
            [self doubleArguementExtraction:str leftPart_p:&leftPart rightPart_p:&rightPart];
            
            str = [NSString stringWithFormat:@"[ %@ ]A[ %@ ]",leftPart,rightPart];
            a[i] = str;
        }

    }
    
    return a;
}


- (void)doubleArguementExtraction:(NSString *)str leftPart_p:(NSMutableString **)leftPart_p rightPart_p:(NSMutableString **)rightPart_p
{
    NSString *remaining = [str substringFromIndex:[str rangeOfString:@"("].location + 1];
    *leftPart_p = [@"" mutableCopy];
    *rightPart_p = [@"" mutableCopy];
    remaining = [remaining substringToIndex:remaining.length - 1];
    int parenthese = 0;
    int k;
    BOOL commaFound = NO;
    for(k = 0; k < remaining.length; k++)
    {
        if([remaining characterAtIndex:k] == '(')
        {
            parenthese++;
        }
        else if([remaining characterAtIndex:k] == ')')
        {
            parenthese--;
        }
        else if([remaining characterAtIndex:k] == ',')
        {
            if(parenthese == 0)
            {
                commaFound = YES;
                break;
            }
        }
        [*leftPart_p appendString:[remaining substringWithRange:NSMakeRange(k, 1)]];
    }
    if(commaFound)
    {
        *rightPart_p = [[remaining substringFromIndex:k + 1] mutableCopy];
    }
    else//parenthese don't pair
    {
        if([remaining rangeOfString:@","].length > 0)
        {
            *leftPart_p = [[remaining substringToIndex:[remaining rangeOfString:@","].location ] mutableCopy];
            *rightPart_p = [[remaining substringFromIndex:[remaining rangeOfString:@","].location + 1] mutableCopy];
        }
    }
}


-(NSMutableArray*)extendParentheseForString:(NSString*)str
{
    NSArray *a = @[ @"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"0",@".",@"+",@"-",@"*",@"/",@"arcsin",@"arccos",@"arctan",@"sinh",@"cosh",@"tanh",@"sin",@"cos",@"tan",@"logxy",@"log",@"ln",@"root",@"I",@"T",];
    
    NSLog(@"extend par: %@",str);
    
    return nil;
}



- (NSMutableArray*)handleCompoundExpressionsForCalc:(NSMutableArray*)array
{
    NSMutableArray *a = [NSMutableArray arrayWithArray:array];
    
    for(int i = a.count - 1; i >= 0; i--)
    {
        NSString *str = a[i];
        if([str hasPrefix:@"x"])//x^y
        {
            //FIXME: = =|||
            [self extendParentheseForString:[str substringFromIndex:1]];
            
            
            str = [NSString stringWithFormat:@"^%@",[str substringFromIndex:1]];
            a[i] = str;
        }
        else if([str hasPrefix:@"logxy"])
        {
            NSMutableString *leftPart;
            NSMutableString *rightPart;
            [self doubleArguementExtraction:str leftPart_p:&leftPart rightPart_p:&rightPart];
            
            [self extendParentheseForString:leftPart];
            [self extendParentheseForString:rightPart];
            
            
            str = [NSString stringWithFormat:@"(log(%@)/log(%@))",rightPart,leftPart];
            a[i] = str;
        }
        else if([str hasPrefix:@"Rootx"])
        {
            NSMutableString *leftPart;
            NSMutableString *rightPart;
            [self doubleArguementExtraction:str leftPart_p:&leftPart rightPart_p:&rightPart];
            
            [self extendParentheseForString:leftPart];
            [self extendParentheseForString:rightPart];
            
            str = [NSString stringWithFormat:@"(nthroot((%@),(%@)))",rightPart,leftPart];
            a[i] = str;
        }
        
    }
    
    return a;
}






- (NSMutableArray*)addParentheseToPowerForDisplay:(NSMutableArray*)array
{
    NSMutableArray *a = [NSMutableArray arrayWithArray:array];
    
    for(int i = a.count - 1; i >= 0; i--)
    {
        NSString *str = a[i];
        if([str hasPrefix:@"^"])
        {
            int parenthese = 0;
            BOOL numberScaned = NO;
            int j;
            for(j = i - 1; j >= 0; j--)
            {
                NSString *previousStr = a[j];
                if([previousStr isEqualToString:@")"])
                {
                    parenthese--;
                }
                else if([previousStr isEqualToString:@"("])
                {
                    parenthese++;
                    if(parenthese == 0)
                    {
                        j--;
                        break;
                    }
                }
                else if([self reverseScanNumberTerminater:previousStr]  && parenthese == 0 && numberScaned)
                {
                    break;
                }
                else //preesumption : should be a number
                {
                    numberScaned = YES;
                }
                
            }
            if(1)
            {
                int substract = 0;
                NSString *power = [str substringFromIndex:1];
                [a removeObjectAtIndex:i];
                [a insertObject:@"v" atIndex:i];
                [a insertObject:power atIndex:i];
                [a insertObject:@"u" atIndex:i];
                [a insertObject:@"]" atIndex:i];
                if(!numberScaned)
                {
                    [a insertObject:@"0" atIndex:i];
                    substract++;
                }
                
                if([a[i - 1] isEqualToString:@")"])
                {
                    [a removeObjectAtIndex:i - 1];
                    substract--;
                }
                
                int anotherParenthesePosition = j + 1;
                if(anotherParenthesePosition >=0 )
                {
                    
                    [a insertObject:@"[" atIndex:anotherParenthesePosition];
                    if([a[anotherParenthesePosition + 1] isEqualToString:@"("])
                    {
                        [a removeObjectAtIndex:anotherParenthesePosition + 1];
                        substract--;
                    }
                }
                i += 5 + substract;
            }
        }
    }
    
    return a;
}


-(BOOL)reverseScanNumberTerminater:(NSString*)str
{
    BOOL result = NO;
    
    NSArray *dict = @[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"0",@"."];
    
    for(NSString* i in dict)
    {
        if([i isEqualToString:str])
        {
            result = YES;
        }
    }
    
    return !result;

}


- (NSMutableArray*)addParentheseToPowerForCalc:(NSMutableArray*)array
{
    NSMutableArray *a = [NSMutableArray arrayWithArray:array];
    
    for(int i = a.count - 1; i >= 0; i--)
    {
        NSString *str = a[i];
        if([str hasPrefix:@"^"])
        {
            int parenthese = 0;
            BOOL numberScaned = NO;
            int j;
            for(j = i - 1; j >= 0; j--)
            {
                NSString *previousStr = a[j];
                if([previousStr isEqualToString:@")"])
                {
                    parenthese--;
                }
                else if([previousStr isEqualToString:@"("])
                {
                    parenthese++;
                    if(parenthese == 0)
                    {
                        j--;
                        break;
                    }
                }
                else if([self reverseScanNumberTerminater:previousStr] && parenthese == 0 && numberScaned)
                {
                    break;
                }
                else //preesumption : should be a number
                {
                    numberScaned = YES;
                }

            }
            if(1)
            {
                int substract = 0;
                NSString *power = [str substringFromIndex:1];
                [a removeObjectAtIndex:i];
                [a insertObject:@")" atIndex:i];
                [a insertObject:@")" atIndex:i];
                [a insertObject:power atIndex:i];
                [a insertObject:@"," atIndex:i];
                [a insertObject:@")" atIndex:i];
                if(!numberScaned)
                {
                    [a insertObject:@"0" atIndex:i-1];
                    substract++;
                }

                int anotherParenthesePosition = j + 1;
                if(anotherParenthesePosition >=0 )
                {
                    
                    [a insertObject:@"(" atIndex:anotherParenthesePosition];
                    [a insertObject:@"(" atIndex:anotherParenthesePosition];
                    [a insertObject:@"pow" atIndex:anotherParenthesePosition];
                    [a insertObject:@"(" atIndex:anotherParenthesePosition];
                }
                i += 9 + substract;
            }
        }
    }
    
    return a;
}




- (NSString*)calculateString
{
    NSMutableString *s = [NSMutableString stringWithFormat:@""];
    calculateExpressionQueue = [NSMutableArray arrayWithArray:expressionQueue];
    
    calculateExpressionQueue = [self handleCompoundExpressionsForCalc:calculateExpressionQueue];
    
    calculateExpressionQueue = [self addParentheseToPowerForCalc:calculateExpressionQueue];
    
    NSLog(@"%@",calculateExpressionQueue);
    
    calculateExpressionQueue = [self addParentheseToFunctionsForCalc:calculateExpressionQueue];
    
    NSLog(@"%@",calculateExpressionQueue);
    
    for (NSString *str in calculateExpressionQueue)
    {
        [s appendString:str];
    }
    [s replaceOccurrencesOfString:@"P" withString:@"pi" options:NSLiteralSearch range:NSMakeRange(0, s.length)];
    [s replaceOccurrencesOfString:@"T" withString:@"" options:NSLiteralSearch range:NSMakeRange(0, s.length)];
    [s replaceOccurrencesOfString:@"I" withString:@"" options:NSLiteralSearch range:NSMakeRange(0, s.length)];
    [s replaceOccurrencesOfString:@"#" withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, s.length)];
    [s replaceOccurrencesOfString:@"x" withString:@"**" options:NSCaseInsensitiveSearch range:NSMakeRange(0, s.length)];
    [s replaceOccurrencesOfString:@"^" withString:@"**" options:NSLiteralSearch range:NSMakeRange(0, s.length)];
    [s replaceOccurrencesOfString:@"arcsin" withString:@"asin" options:NSLiteralSearch range:NSMakeRange(0, s.length)];
    [s replaceOccurrencesOfString:@"arccos" withString:@"acos" options:NSLiteralSearch range:NSMakeRange(0, s.length)];
    [s replaceOccurrencesOfString:@"arctan" withString:@"atan" options:NSLiteralSearch range:NSMakeRange(0, s.length)];
    [s replaceOccurrencesOfString:@"root" withString:@"sqrt" options:NSLiteralSearch range:NSMakeRange(0, s.length)];
    [s replaceOccurrencesOfString:@"nthsqrt" withString:@"nthroot" options:NSLiteralSearch range:NSMakeRange(0, s.length)];
    
    
    while([s rangeOfString:@"sqrt3"].length > 0)
    {
        NSRange r = [s rangeOfString:@"sqrt3"];
        NSString *leftPart = [s substringToIndex:r.location];
        NSMutableString *remainingPart = [[s substringFromIndex:r.length + r.location] mutableCopy];
        NSMutableString *processingPart = [@"" mutableCopy];
        
        int parenthese = 0;
        for(int i = 0; i < remainingPart.length; i++)
        {
            if([remainingPart characterAtIndex:i] == '(')
            {
                parenthese++;
                [processingPart appendString:[NSString stringWithFormat:@"%c",'(']];
            }
            else if([remainingPart characterAtIndex:i] == ')')
            {
                parenthese--;
                [processingPart appendString:[NSString stringWithFormat:@"%c",')']];
                if(parenthese == 0)
                {
                    remainingPart = [[remainingPart substringFromIndex:i + 1] mutableCopy];
                    break;
                }
            }
            else
            {
                [processingPart appendString:[NSString stringWithFormat:@"%c",[remainingPart characterAtIndex:i]]];
            }
        }
        
        
        s = [[NSString stringWithFormat:@"%@nthroot(%@,3)%@",leftPart,processingPart,remainingPart] mutableCopy];
    }
    
    
    if([s isEqualToString:@""])
    {
        return @"0";
    }
    return s;
}




- (DDMathEvaluator *)evaluator {
    if (evaluator == nil) {
        
        evaluator = [[DDMathEvaluator alloc] init];
        
    }
    return evaluator;
}

- (NSNumber*) evaluate {
    DDMathEvaluator *eval = [self evaluator];
    NSMutableDictionary * variables = [NSMutableDictionary dictionary];//useless
    
	NSString * string = self.calculateString;
        
    NSLog(@"calculate string:%@",string);
    //[inputScrollViewController setText:string];
    
	NSError *error = nil;
	if ([string length] > 0) {
		DDExpression * expression = [DDExpression expressionFromString:string error:&error];
		if (error == nil) {
			NSLog(@"parsed: %@", expression);
			//[self updateVariablesWithExpression:expression];
			NSNumber * result = [expression evaluateWithSubstitutions:variables evaluator:eval error:&error];
			if (error == nil) {
                NSLog(@"result:%@",[result description]);
                resultString = [NSString stringWithFormat:@"%.7g",[result doubleValue]];
                errorOccured = NO;
                lastResult = result;
			}
		}
	} else {
		[variables removeAllObjects];
        errorOccured = NO;
        resultString = @"";
        lastResult = nil;
	}
	if (error != nil) {
		NSLog(@"error: %@", error);
        errorOccured = YES;
        resultString = @"ERROR";
        lastResult = nil;
	}
	justEvaluated = YES;
	//[variableList reloadData];		
    return lastResult;
}


- (void)restoreExpressionQueueToThis:(NSMutableArray*)oldQueue
{
    [undoManager registerUndoWithTarget:self
                               selector:@selector(restoreExpressionQueueToThis:)
                                 object:[expressionQueue copy]];
    expressionQueue = [NSMutableArray arrayWithArray:oldQueue];
    justEvaluated = NO;
}


- (void)clearQueue
{
    [undoManager registerUndoWithTarget:self
                               selector:@selector(restoreExpressionQueueToThis:) 
                                 object:[expressionQueue copy]];
    [expressionQueue removeAllObjects];
    justEvaluated = NO;
}
@end
