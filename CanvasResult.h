//
//  CanvasResult.h
//  UltraCalc
//
//  Created by Song  on 12-7-15.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Note;

@interface CanvasResult : NSManagedObject

@property (nonatomic, retain) NSString * result;
@property (nonatomic, retain) Note *canvasToNoteRelation;

@end
