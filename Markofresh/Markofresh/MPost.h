//
//  MPost.h
//  markofresh
//
//  Created by Grant Wenzlau on 6/15/13.
//  Copyright (c) 2013 master. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class MUser;

@interface MPost : NSManagedObject

@property (nonatomic, retain) NSNumber * postID;
@property (nonatomic, retain) id jsonURL;
@property (nonatomic, retain) id htmlURL;
@property (nonatomic, retain) NSString * body;
@property (nonatomic, retain) NSDate * createdAt;
@property (nonatomic, retain) MUser *user;

@property (nonatomic, readonly) NSString *titleText;
@property (nonatomic, readonly) NSString *subtitleText;

@end
