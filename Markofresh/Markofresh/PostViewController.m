//
//  PostViewController.m
//  markofresh
//
//  Created by Grant Wenzlau on 6/17/13.
//  Copyright (c) 2013 master. All rights reserved.
//

#import "PostViewController.h"
#import "ProgressView.h"
#import "Post.h"
#import "MUser.h"
#import "ProgressView.h"
//#import <RestKit/RestKit.h>

@interface PostViewController ()
@property (weak, nonatomic) IBOutlet UITextField *postTextField;

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

#pragma mark - Actions

/*-(void)savePost {
    
    RKManagedObjectStore *objectStore = [[RKObjectManager sharedManager] managedObjectStore];
    Post *post = [NSEntityDescription insertNewObjectForEntityForName:@"Post" inManagedObjectContext:objectStore.mainQueueManagedObjectContext];
    [post setBody:self.postTextField.text];
    [objectStore.mainQueueManagedObjectContext save:nil];
   
    RKObjectManager *manager = [RKObjectManager sharedManager]; [manager postObject:post path:@"/posts.json" parameters:nil success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        NSLog(@"Success saving post");
       // [MUser setCurrentUser:self];
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        NSLog(@"Failure saving post: %@", error.localizedDescription);
    }];
    
    RKLogConfigureByName("RestKit/ObjectMapping", RKLogLevelTrace);
}*/

-(void) savePost {
    Post *post = [[Post alloc] init];
   // post.CLlocation = CLLocationCoordinate2DMake(self.latitude, self.longitude);
    post.body = self.postTextField.text;
    
    [self.view endEditing:YES];
    
    ProgressView *progressView = [ProgressView presentInWindow:self.view.window];
    
    [post saveWithProgress:^(CGFloat progress) {
        [progressView setProgress:progress];
    }completion:^(BOOL success, NSError *error) {
        [progressView dismiss];
        if (success) {
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            NSLog(@"ERROR: %@", error);
        }
    }];
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
