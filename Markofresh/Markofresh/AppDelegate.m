//
//  AppDelegate.m
//  Markofresh
//
//  Created by Grant Wenzlau on 6/15/13.
//  Copyright (c) 2013 master. All rights reserved.
//

#import "AppDelegate.h"
#import <RestKit/RestKit.h>
#import "MasterViewController.h"
#import "Post.h"
#import <NewRelicAgent/NewRelicAgent.h>

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [NewRelicAgent startWithApplicationToken:@"AAb828214f70a789acd38dda59646f2793b54dc8bb"];
    
    NSError *error = nil;
    NSURL *modelURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"Markofresh" ofType:@"momd"]];
    // NOTE: Due to an iOS 5 bug, the managed object model returned is immutable.
    NSManagedObjectModel *managedObjectModel = [[[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL] mutableCopy];
    RKManagedObjectStore *managedObjectStore = [[RKManagedObjectStore alloc] initWithManagedObjectModel:managedObjectModel];
    
    // Initialize the Core Data stack
    [managedObjectStore createPersistentStoreCoordinator];
    
    NSPersistentStore __unused *persistentStore = [managedObjectStore addInMemoryPersistentStore:&error];
    NSAssert(persistentStore, @"Failed to add persistent store: %@", error);
    
    [managedObjectStore createManagedObjectContexts];
    
    // Configure a managed object cache to ensure we do not create duplicate objects
    managedObjectStore.managedObjectCache = [[RKInMemoryManagedObjectCache alloc] initWithManagedObjectContext:managedObjectStore.persistentStoreManagedObjectContext];

    
    // Set the default store shared instance
    [RKManagedObjectStore setDefaultStore:managedObjectStore];
    
    // Configure the object manager
    RKObjectManager *objectManager = [RKObjectManager managerWithBaseURL:[NSURL URLWithString:@"https://fierce-shore-5970.herokuapp.com"]];
    objectManager.managedObjectStore = managedObjectStore;
    
    
    [RKObjectManager setSharedManager:objectManager];
    
    RKEntityMapping *entityMapping = [RKEntityMapping mappingForEntityForName:@"Post" inManagedObjectStore:managedObjectStore];
    [entityMapping addAttributeMappingsFromDictionary:@{
     @"id":             @"postID",
     @"url":            @"jsonURL",
     @"body":           @"body",
     @"created_at":     @"createdAt"}];
    entityMapping.identificationAttributes = @[ @"postID" ];
    
    [RKObjectManager sharedManager].requestSerializationMIMEType = RKMIMETypeJSON;
    
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:entityMapping pathPattern:@"/posts" keyPath:nil statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
    
    [objectManager addResponseDescriptor:responseDescriptor];
    
    //

    
   
    /*
    RKObjectMapping *postRequestMapping = [RKObjectMapping requestMapping]; // objectClass == NSMutableDictionary
    [postRequestMapping addAttributeMappingsFromArray:@[@"body"]];
    
    
    RKRequestDescriptor *requestDescriptor = [RKRequestDescriptor requestDescriptorWithMapping:postRequestMapping objectClass:[Post class] rootKeyPath:@"/posts"];

    [objectManager addRequestDescriptor:requestDescriptor];
    
    RKObjectManager *manager = [RKObjectManager managerWithBaseURL:[NSURL URLWithString:@"https://fierce-shore-5970.herokuapp.com/posts"]];
    [manager addRequestDescriptor:requestDescriptor];
    [manager addResponseDescriptor:postDescriptor];
    
    [objectManager addRequestDescriptor:requestDescriptor];
    */
    
    
                                
    
    // Override point for customization after application launch.
    UINavigationController *navigationController = (UINavigationController *)self.window.rootViewController;
    MasterViewController *controller = (MasterViewController *)navigationController.topViewController;
    controller.managedObjectContext = managedObjectStore.mainQueueManagedObjectContext;
    return YES;
    
    // Log all HTTP traffic with request and response bodies
    RKLogConfigureByName("RestKit/Network", RKLogLevelTrace);
    
    // Log debugging info about Core Data
    RKLogConfigureByName("RestKit/CoreData", RKLogLevelDebug);
    
    // Raise logging for a block
    RKLogWithLevelWhileExecutingBlock(RKLogLevelTrace, ^{
        // Do something that generates logs
    });
}

@end
