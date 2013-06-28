//
//  Post.h
//  markofresh
//
//  Created by Grant Wenzlau on 6/15/13.
//  Copyright (c) 2013 master. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import <CoreData/CoreData.h>

@class MUser;

@interface Post : NSObject <MKAnnotation> {

    @private
    NSString *_postURLString;
    NSDate *_timestamp;
    
    CLLocationDegrees _latitude;
    CLLocationDegrees _longitude;
}

+ (void)fetchPosts:(void (^)(NSArray *posts, NSError *error))completionBlock;

@property (nonatomic, retain) NSNumber * postID;
@property (nonatomic, retain) id jsonURL;
@property (nonatomic, retain) id htmlURL;
@property (nonatomic, strong) NSString *body;
@property (nonatomic, retain) NSDate * createdAt;
@property (nonatomic, retain) MUser *user;

@property (nonatomic, readonly) NSString *titleText;
@property (nonatomic, readonly) NSString *subtitleText;

@property (strong, nonatomic, readonly) NSURL *postURL;
@property (strong, nonatomic, readonly) CLLocation *location;
@property (strong, nonatomic, readonly) NSDate *timestamp;

- (id)initWithAttributes:(NSDictionary *)attributes;

+ (void)postsNearLocation:(CLLocation *)location
                    block:(void (^)(NSSet *posts, NSError *error))block;

+ (void)uploadPostAtLocation:(CLLocation *)location
//not sure if the below is right - check the gpho - they did image:UIImage *)image... what is the text equiv?
                       body:(UITextField *)body
                       block:(void (^)(Post *post, NSError *error))block;

- (void)saveWithProgress:(void (^)(CGFloat progress))progressBlock completion:(void (^)(BOOL success, NSError *error))
completionBlock;
- (void)saveWithCompletion:(void (^)(BOOL success, NSError *error))completionBlock;


@end
