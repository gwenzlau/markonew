//
//  AppDelegate.m
//  Markofresh
//
//  Created by Grant Wenzlau on 6/15/13.
//  Copyright (c) 2013 master. All rights reserved.
//

#import "AppDelegate.h"
//#import <RestKit/RestKit.h>
#import "MasterViewController.h"
#import "Post.h"
#import <NewRelicAgent/NewRelicAgent.h>

@implementation AppDelegate
@synthesize window = _window;


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [NewRelicAgent startWithApplicationToken:@"AAb828214f70a789acd38dda59646f2793b54dc8bb"];
    //attempt to simplify like gpho

}

    
    
    
    
    /*
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
    [objectManager setRequestSerializationMIMEType:@"application/json"];
    [objectManager setAcceptHeaderWithMIMEType:@"application/json"];
    
    
    [RKObjectManager setSharedManager:objectManager];
    //setup Post Entity map
    RKEntityMapping *entityMapping = [RKEntityMapping mappingForEntityForName:@"Post" inManagedObjectStore:managedObjectStore];
    [entityMapping addAttributeMappingsFromDictionary:@{
     @"id":             @"postID",
     @"url":            @"jsonURL",
     @"body":           @"body",
     @"created_at":     @"createdAt"}];
    entityMapping.identificationAttributes = @[ @"postID" ];
    
    [RKObjectManager sharedManager].requestSerializationMIMEType = RKMIMETypeJSON;
    
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:entityMapping pathPattern:@"/posts.json" keyPath:nil statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
    
    [objectManager addResponseDescriptor:responseDescriptor];
    
    RKRequestDescriptor *requestDescriptor = [RKRequestDescriptor requestDescriptorWithMapping:[entityMapping inverseMapping] objectClass:[Post class] rootKeyPath:@"/posts.json"];
    [objectManager addRequestDescriptor:requestDescriptor];
   
    
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"https://fierce-shore-5970.herokuapp.com/posts.json"]];
    RKManagedObjectRequestOperation *operation = [[RKManagedObjectRequestOperation alloc] initWithRequest:request responseDescriptors:@[responseDescriptor]];
    operation.managedObjectContext = managedObjectStore.mainQueueManagedObjectContext;
    operation.managedObjectCache = managedObjectStore.managedObjectCache;
    [operation setCompletionBlockWithSuccess:^(RKObjectRequestOperation *operation, RKMappingResult *result) {
        Post *post = [result firstObject];
        NSLog(@"Mapped the post: %@", post);
    }failure:^(RKObjectRequestOperation *operation, NSError *error) {
        NSLog(@"Failed with error: %@", [error localizedDescription]);
    }];
    NSOperationQueue *operationQueue = [NSOperationQueue new];
    [operationQueue addOperation:operation];
    */
                                
    /*
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
}*/

@end
