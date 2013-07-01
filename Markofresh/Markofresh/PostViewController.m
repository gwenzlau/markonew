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
#import "AFJSONRequestOperation.h"

@interface PostViewController ()
@property (weak, nonatomic) IBOutlet UITextField *postTextField;
@property (strong, nonatomic, readwrite) CLLocation *locationManager;
@end

@implementation PostViewController
@synthesize locationManager = _locationManager;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self setPostTextField:nil];
//redundant?   self.navigationItem.rightBarButtonItem = [self saveButton];
    self.locationManager = [[CLLocationManager alloc] init];
}
/* this might be redundant?
 - (UIBarButtonItem *)saveButton {
    return [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave
                                                         target:self
                                                         action:@selector(savePost:)];
}*/

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)savePost {
    Post *post = [[Post alloc] init];
    post.body = self.postTextField.text;
    
    [self.view endEditing:YES];
    
    ProgressView *progressView = [ProgressView presentInWindow:self.view.window];
    
    [post saveWithProgress:^(CGFloat progress) {
        [progressView setProgress:progress];
    } completion:^(BOOL success, NSError *error) {
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
