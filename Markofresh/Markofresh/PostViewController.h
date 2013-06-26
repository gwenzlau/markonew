//
//  PostViewController.h
//  markofresh
//
//  Created by Grant Wenzlau on 6/17/13.
//  Copyright (c) 2013 master. All rights reserved.
//
#import <UIKit/UIKit.h>

@interface PostViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *postTextField;

- (IBAction)onSave:(id)sender;
- (IBAction)onCancel:(id)sender;

@end
