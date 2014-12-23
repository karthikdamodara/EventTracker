//
//  AppDelegate.m
//  EventTracker
//
//  Copyright (c) 2014 Karthik. All rights reserved.
//

#import "AppDelegate.h"
#import "Event.h"
#import "Constants.h"

@interface AppDelegate()
 

@end

@implementation AppDelegate
@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    [self managedObjectContext];
    
    self.trackingEvents=[[NSMutableArray alloc] init];
    
    // check whether application is launched for the first time
    if(![[NSUserDefaults standardUserDefaults] boolForKey:klaunchedbefore]){
        
      [self prePopulateDataStrore];
    }
  

    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


#pragma core data methods
- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"events.sqlite"];
    
   
      NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter:
         @{NSMigratePersistentStoresAutomaticallyOption:@YES, NSInferMappingModelAutomaticallyOption:@YES}
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}

- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"EventTracker" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSURL *)applicationDocumentsDirectory{
return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}




// method  used to load data to core data
-(void)prePopulateDataStrore{
    
    
    NSString *jsonFile = [[NSBundle mainBundle] pathForResource:@"events" ofType:@"json"];
    NSError *jsonError = nil;
    NSArray *jsonData = [NSJSONSerialization
                         JSONObjectWithData:[NSData dataWithContentsOfFile:jsonFile]
                         options:kNilOptions
                         error:&jsonError];
    
    if(!jsonData) {
        NSLog(@"Could not read JSON file: %@", jsonError);
        abort();
    }
    
    // loop json data and save it to core data
    [jsonData enumerateObjectsUsingBlock:^(id objData, NSUInteger idx, BOOL *stop) {
        
        Event *event = [NSEntityDescription
                        insertNewObjectForEntityForName:kentityname
                        inManagedObjectContext:self.managedObjectContext];
        
        event.name = [objData objectForKey:kname];
        event.address=[objData objectForKey:kaddress];
        event.eventID=[objData objectForKey:keventID];
        event.type=[objData objectForKey:ktype];
        event.date=[objData objectForKey:kdate];
        event.thumbnail=[NSString stringWithFormat:@"%u.jpeg",idx+1];
        event.mainImage=[NSString stringWithFormat:@"%u_main.jpeg",idx+1];
        
        // then save to Core Data
        NSError *error = nil;
        [self.managedObjectContext save:&error];
        
    }];
    
    //set application lauch status
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:klaunchedbefore];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}


@end
