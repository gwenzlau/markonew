//
//  PostViewController.m
//  markofresh
//
//  Created by Grant Wenzlau on 6/17/13.
//  Copyright (c) 2013 master. All rights reserved.
//

#import "PostViewController.h"
#import "MPost.h"
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
-(void)saveChanges {
    RKManagedObjectStore *objectStore = [[RKObjectManager sharedManager] managedObjectStore];
    MPost *post = [NSEntityDescription insertNewObjectForEntityForName:@"Post" inManagedObjectContext:objectStore.mainQueueManagedObjectContext];
    [post setBody:@"This is the body."];
    
    [[RKObjectManager sharedManager] postObject:post path:@"/posts" parameters:nil success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        NSLog(@"Success saving post");
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        NSLog(@"Failure saving post: %@", error.localizedDescription);
    }];
    /*
    RKObjectMapping *responseMapping = [RKObjectMapping mappingForClass:[MPost class]];
    [responseMapping addAttributeMappingsFromArray:@[@"bodyText", @"postID", @"createdAt"]];
    NSIndexSet *statusCodes = RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful); // Anything in 2xx
    RKResponseDescriptor *postDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:responseMapping pathPattern:@"/posts" keyPath:@"posts" statusCodes:statusCodes];
    
    RKObjectMapping *requestMapping = [RKObjectMapping requestMapping]; // objectClass == NSMutableDictionary
    [requestMapping addAttributeMappingsFromArray:@[@"bodyText", @"postID", @"createdAt"]];
    
    RKRequestDescriptor *requestDescriptor = [RKRequestDescriptor requestDescriptorWithMapping:requestMapping objectClass:[MPost class] rootKeyPath:@"posts"];
    
    RKObjectManager *manager = [RKObjectManager managerWithBaseURL:[NSURL URLWithString:@"https://fierce-shore-5970.herokuapp.com"]];
    [manager addRequestDescriptor:requestDescriptor];
    [manager addResponseDescriptor:postDescriptor];
    
  //  MPost *post = [MPost new];
   // post.bodyText = @"This is some text.";
  
    
*/
    
}

- (IBAction)onCancel:(id)sender {
    [self dismiss];
}

- (void)dismiss {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)onSave:(id)sender {
    [self saveChanges];
    [self dismiss];
}

@end
