//
//  MasterViewController.h
//  Markofresh
//
//  Created by Grant Wenzlau on 6/15/13.
//  Copyright (c) 2013 master. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import <CoreData/CoreData.h>

@interface MasterViewController : UITableViewController < CLLocationManagerDelegate, UINavigationControllerDelegate, UITableViewDelegate> {
//NSArray *map;
    @private
    CLLocationManager *_locationManager;
    
}

//@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
//@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
- (IBAction)addButton:(UIBarButtonItem *)sender;
- (IBAction)takePhoto:(UIBarButtonItem *)sender;

@end
