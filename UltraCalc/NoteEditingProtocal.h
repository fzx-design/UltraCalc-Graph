//
//  NoteEditingProtocal.h
//  UltraCalc
//
//  Created by Song  on 12-7-19.
//
//

#import <Foundation/Foundation.h>

@protocol NoteEditingProtocal <NSObject>

-(void)didFinishedNoteEditingWithText:(NSString*)str;

@end
