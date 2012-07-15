//
//  DataStorage.h
//  CoreDataTest
//
//  Created by Song  on 12-7-15.
//  Copyright (c) 2012年 Song . All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyDataStorage : NSObject

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;

@end
