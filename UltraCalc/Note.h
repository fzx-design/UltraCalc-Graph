//
//  Note.h
//  CoreDataTest
//
//  Created by Song  on 12-7-15.
//  Copyright (c) 2012年 Song . All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class AnswerTableResult, CanvasResult;

@interface Note : NSManagedObject

@property (nonatomic, retain) NSString * note;
@property (nonatomic, retain) CanvasResult *canvasOwner;
@property (nonatomic, retain) AnswerTableResult *calculationOwner;

@end
