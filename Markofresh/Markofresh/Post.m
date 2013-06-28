//
//  Post.m
//  markofresh
//
//  Created by Grant Wenzlau on 6/15/13.
//  Copyright (c) 2013 master. All rights reserved.
//

#import "Post.h"
#import "MasterViewController.h"
#import "PostViewController.h"
#import "MAPIClient.h"
#import "ISO8601DateFormatter.h"
#import <BlocksKit/BlocksKit.h>
#import "AFNetworking.h"
#import "NSDictionary+JSONValueParsing.h"
#import "MUser.h"


static NSDate * NSDateFromISO8601String(NSString *string) {
    static ISO8601DateFormatter *_iso8601DateFormatter = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _iso8601DateFormatter = [[ISO8601DateFormatter alloc] init];
    });
    
    if (!string) {
        return nil;
    }
    
    return [_iso8601DateFormatter dateFromString:string];
}

static NSString * NSStringFromCoordinate(CLLocationCoordinate2D coordinate) {
    return [ NSString stringWithFormat:@"(%f, %f)", coordinate.latitude, coordinate.longitude];
}

static NSString * NSStringFromDate(NSDate *date) {
    static NSDateFormatter *_dateFormatter = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _dateFormatter = [[NSDateFormatter alloc] init];
        [_dateFormatter setLocale:[NSLocale currentLocale]];
        [_dateFormatter setDateStyle:NSDateFormatterShortStyle];
        [_dateFormatter setTimeStyle:NSDateFormatterShortStyle];
        [_dateFormatter setDoesRelativeDateFormatting:YES];
    });
    
    return [_dateFormatter stringFromDate:date];
}

@interface Post ()
@property (strong, nonatomic, readwrite) NSString *postURLString;
@property (strong, nonatomic, readwrite) NSDate *timestamp;
@property (assign, nonatomic, readwrite) CLLocationDegrees latitude;
@property (assign, nonatomic, readwrite) CLLocationDegrees longitude;
@end

@implementation Post
@dynamic postID;
@dynamic jsonURL;
@dynamic htmlURL;
//@dynamic body;
@dynamic createdAt;
@dynamic user;

@synthesize postURLString = _postURLString;
@synthesize timestamp = _timestamp;
@synthesize latitude = _latitude;
@synthesize longitude = _longitude;
@dynamic postURL;
@dynamic location;
@synthesize body;

+ (void)fetchPosts:(void (^)(NSArray *posts, NSError *error))completionBlock {
    [[MAPIClient sharedClient] getPath:@"/posts.json" parameters:nil
                               success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                   if (operation.response.statusCode == 200) {
                                       NSArray *posts = [Post postsWithJSON:responseObject];
                                       completionBlock(posts, nil);
                                   } else {
                                       NSLog(@"Received an HTTP %d: %@", operation.response.statusCode, responseObject);
                                       completionBlock(nil, nil);
                                   }
                               } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                   completionBlock(nil, error);
                               }];
}

+ (NSArray *)postsWithJSON:(NSArray *)postsJson {
    return [postsJson map:^id(id itemJson) {
        return [Post postFromJSON:itemJson];
    }];
}

+ (Post *)postFromJSON:(NSDictionary *)dictionary {
    Post *post = [[Post alloc] init];
    [post updateFromJSON:dictionary];
    
    return post;
}
     
- (void)updateFromJSON:(NSDictionary *)dictionary {
    self.body = [dictionary stringForKey:@"body"];
         
     }

- (void)saveWithCompletion:(void (^)(BOOL success, NSError *error))completionBlock {
    [self saveWithProgress:nil completion:completionBlock];
}

-(void)saveWithProgress:(void (^)(CGFloat progress))progressBlock completion:(void (^)(BOOL success, NSError *error))completionBlock {
    
    if (!self.body) self.body = @"";
    
    NSDictionary *params = @{
    @"post[body]" : self.body
    };
     
     NSURLRequest *postRequest = [[MAPIClient sharedClient] multipartFormRequestWithMethod:@"POST"
                                                                                      path:@"/posts"
                                                                                parameters:params
                                                                 constructingBodyWithBlock:^(id<AFMultipartFormData> formData)
                                                                    {
                                                                        [formData appendPartWithFormData:self.body name:@"post[body]"];
                                                                    }];
     AFHTTPRequestOperation *operation = [[AFJSONRequestOperation alloc] initWithRequest:postRequest];
     [operation setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
        CGFloat progress = ((CGFloat)totalBytesWritten) / totalBytesExpectedToWrite;
        progressBlock(progress);
    }];
     
     [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (operation.response.statusCode == 200 || operation.response.statusCode == 201) {
            NSLog(@"Created, %@", responseObject);
            NSDictionary *updatedPost = [responseObject objectForKey:@"post"];
            [self updateFromJSON:updatedPost];
            completionBlock(YES, nil);
        } else {
            completionBlock(NO, nil);
        }
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        completionBlock(NO,error);
    }];
     [[MAPIClient sharedClient] enqueueHTTPRequestOperation:operation];
};

-(id)initWithAttributes:(NSDictionary *)attributes {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    self.postURLString = [attributes valueForKeyPath:@"post_urls.original"];
    
    self.timestamp = NSDateFromISO8601String([attributes valueForKeyPath:@"created_at"]);
    
    self.latitude = [[attributes valueForKeyPath:@"lat"] doubleValue];
    self.longitude = [[attributes valueForKeyPath:@"lng"] doubleValue];
    
    return self;
}

- (NSURL *)postURL {
    return [NSURL URLWithString:self.postURLString];
}

- (CLLocation *) location {
    return [[CLLocation alloc] initWithLatitude:self.latitude longitude:self.longitude];
}

+(void)postsNearLocation:(CLLocation *)location block:(void (^)(NSSet *, NSError *))block
{
    NSMutableDictionary *mutableParameters = [NSMutableDictionary dictionary];
    [mutableParameters setObject: [NSNumber numberWithDouble: (location.coordinate.latitude)] forKey:@"lat"];
    [mutableParameters setObject: [NSNumber numberWithDouble:(location.coordinate.longitude)] forKey:@"lng"];
    
    [[MAPIClient sharedClient] getPath:@"/posts" parameters:mutableParameters success:^(AFHTTPRequestOperation *operation, id JSON) {
        NSMutableSet *mutablePosts = [NSMutableSet set];
        for (NSDictionary *attributes in [JSON valueForKeyPath:@"posts"]) {
            Post *post = [[Post alloc] initWithAttributes:attributes];
            [mutablePosts addObject:post];
        }
        
        if (block) {
            block ([NSSet setWithSet:mutablePosts], nil);
        }
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (block) {
            block(nil, error);
        }
    }];
}

+(void)uploadPostAtLocation:(CLLocation *)location
                       body:(UITextField *)body
                       block:(void (^)(Post *post, NSError *error))block
{
    NSMutableDictionary *mutableParameters = [NSMutableDictionary dictionary];
    [mutableParameters setObject:[NSNumber numberWithDouble:location.coordinate.latitude] forKey:@"post[lat]"];
    [mutableParameters setObject:[NSNumber numberWithDouble:location.coordinate.longitude] forKey:@"post[lng]"];
    
    NSMutableURLRequest *mutableURLRequest = [[MAPIClient sharedClient] multipartFormRequestWithMethod:@"POST" path:@"/posts" parameters:mutableParameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFormData:body name:@"post[body]"];
        //[formData appendPartWithFormData:TextField(body) name:@"post[body]"];
    }];
    
    AFHTTPRequestOperation *operation = [[MAPIClient sharedClient] HTTPRequestOperationWithRequest:mutableURLRequest success:^(AFHTTPRequestOperation *operation, id JSON) {
        Post *post = [[Post alloc] initWithAttributes:[JSON valueForKeyPath:@"post"]];
        
        if (block) {
            block(post, nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (block) {
            block(nil, error);
        }
    }];
    [[MAPIClient sharedClient] enqueueHTTPRequestOperation:operation];
}

#pragma mark - MKAnnotation

- (CLLocationCoordinate2D)coordinate {
    return CLLocationCoordinate2DMake(self.latitude, self.longitude);
}

- (NSString *)body {
    return NSStringFromCoordinate(self.coordinate);
}

- (NSString *)subtitle {
    return NSStringFromDate(self.timestamp);
}
/*
- (NSString *)titleText
{
    return [self.body length] ? self.body : @"(untitled)";
}

- (NSString *)subtitleText
{
    static NSDateFormatter *dateFormatter = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dateFormatter = [NSDateFormatter new];
        dateFormatter.dateFormat = @"MM/dd/yy '@' HH:mm a";
    });
    return [NSString stringWithFormat:@"by %@ on %@", self.user.name,
            [dateFormatter stringFromDate:self.createdAt]];
}

*/

@end
