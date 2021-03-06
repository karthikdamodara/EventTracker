//
//  AppDelegate.h
//  EventTracker
//
//  Copyright (c) 2014 Karthik. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic,readonly) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic,readonly) NSManagedObjectModel *managedObjectModel;
@property (strong, nonatomic,readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (strong,nonatomic)NSMutableArray *trackingEvents;

- (NSURL *)applicationDocumentsDirectory;

@end
