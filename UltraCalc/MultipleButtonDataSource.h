//
//  MultipleButtonDataSource.h
//  touchTest
//
//  Created by Song  on 12-3-27.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MultipleButtonViewController;

@protocol MultipleButtonDataSource <NSObject>

-(NSDictionary*)MultipleButton:(MultipleButtonViewController*)button ButtonAttributeAtIndex:(int)index;


-(void)pressedButtonWithIdentifier:(NSString*)identifier;

-(BOOL)MultipleButtonNeedSendBackAfterTouch:(MultipleButtonViewController*)button;

@end
