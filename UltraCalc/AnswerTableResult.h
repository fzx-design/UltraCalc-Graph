//
//  AnswerTableResult.h
//  UltraCalc
//
//  Created by Song  on 12-7-15.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Note;

@interface AnswerTableResult : NSManagedObject

@property (nonatomic, retain) NSString * calc;
@property (nonatomic, retain) NSString * result;
@property (nonatomic, retain) NSDate * datetime;
@property (nonatomic, retain) Note *tableToNoteRelation;

@end
