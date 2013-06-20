//
//  PostViewController.m
//  markofresh
//
//  Created by Grant Wenzlau on 6/17/13.
//  Copyright (c) 2013 master. All rights reserved.
//

#import "PostViewController.h"
#import "Post.h"
#import <RestKit/RestKit.h>

@interface PostViewController ()

@end

@implementation PostViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//
-(void)savePost {
    /* RKManagedObjectStore *objectStore = [[RKObjectManager sharedManager] managedObjectStore];
    Post *post = [NSEntityDescription insertNewObjectForEntityForName:@"Post" inManagedObjectContext:objectStore.mainQueueManagedObjectContext];
   [[RKObjectManager sharedManager] postObject:post path:@"/posts" parameters:nil success:nil failure:nil];
    */
    //
    
    /*
    RKObjectMapping *responseMapping = [RKObjectMapping mappingForClass:[Post class]];
    [responseMapping addAttributeMappingsFromArray:@[@"body"]];
    NSIndexSet *statusCodes = RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful);
    RKResponseDescriptor *postDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:responseMapping pathPattern:@"/posts.json" keyPath:@"post" statusCodes:statusCodes];
    
    RKObjectMapping *requestMapping = [RKObjectMapping requestMapping];
    [requestMapping addAttributeMappingsFromArray:@[@"body"]];
    
    RKRequestDescriptor *requestDescriptor  = [RKRequestDescriptor requestDescriptorWithMapping:requestMapping objectClass:[Post class] rootKeyPath:@"post"];
    */
    /*
    RKObjectManager *manager = [RKObjectManager managerWithBaseURL:[NSURL URLWithString:@"https://fierce-shore-5970.herokuapp.com"]];
    [manager setRequestSerializationMIMEType:@"application/json"];
    [manager setAcceptHeaderWithMIMEType:@"application/json"];
    */
    
    //[manager addRequestDescriptor:requestDescriptor];
    //[manager addResponseDescriptor:postDescriptor];
     //this is following the stack attempt - simplifying...
    
    RKManagedObjectStore *objectStore = [[RKObjectManager sharedManager] managedObjectStore];
    Post *post = [NSEntityDescription insertNewObjectForEntityForName:@"Post" inManagedObjectContext:objectStore.mainQueueManagedObjectContext];
    [post setBody:@"This is my new body."];
   
    [[RKObjectManager sharedManager] postObject:post path:@"/posts.json" parameters:nil success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        NSLog(@"Success saving post");
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        NSLog(@"Failure saving post: %@", error.localizedDescription);
    }];
   // [RKMIMETypeSerialization registerClass:[RKNSJSONSerialization class] forMIMEType:@"text/plain"];
    
    //[RKObjectManager sharedManager].requestSerializationMIMEType = RKMIMETypeJSON;
    
   /* [manager postObject:post path:@"/posts.json" parameters:nil success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        NSLog(@"Success saving post");
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        NSLog(@"Failure saving post: %@", error.localizedDescription);
    }];
    */
    
    
   /* [[RKObjectManager sharedManager] postObject:post path:@"/posts" parameters:nil success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        NSLog(@"Success saving post");
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        NSLog(@"Failure saving post: %@", error.localizedDescription);
    }];
    */
   
    
}

- (IBAction)onCancel:(id)sender {
    [self dismiss];
}

- (void)dismiss {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)onSave:(id)sender {
    [self savePost];
    [self dismiss];
}

@end
