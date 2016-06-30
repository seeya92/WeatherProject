//
//  AppDelegate.h
//  WeatherApp2.0
//
//  Created by Kuryliak Maksym on 24.05.16.
//  Copyright © 2016 Kuryliak Maksym. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "MMDrawerController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (nonatomic) MMDrawerController *drawerController;


- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;


@end

