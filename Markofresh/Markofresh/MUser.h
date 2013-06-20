//
//  MUser.h
//  markofresh
//
//  Created by Grant Wenzlau on 6/15/13.
//  Copyright (c) 2013 master. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Post;

@interface MUser : NSManagedObject

@property (nonatomic, retain) NSNumber * userID;
@property (nonatomic, retain) id jsonURL;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSSet *posts;
@end

@interface MUser (CoreDataGeneratedAccessors)

- (void)addPostsObject:(Post *)value;
- (void)removePostsObject:(Post *)value;
- (void)addPosts:(NSSet *)values;
- (void)removePosts:(NSSet *)values;

@end
