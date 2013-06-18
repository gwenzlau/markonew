//
//  DetailViewController.h
//  Markofresh
//
//  Created by Grant Wenzlau on 6/15/13.
//  Copyright (c) 2013 master. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController

@property (strong, nonatomic) id detailItem;

@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;
@end
