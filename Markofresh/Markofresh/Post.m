//
//  Post.m
//  markofresh
//
//  Created by Grant Wenzlau on 6/15/13.
//  Copyright (c) 2013 master. All rights reserved.
//

#import "Post.h"
#import "PostViewController.h"
#import "MUser.h"


@implementation Post

@dynamic postID;
@dynamic jsonURL;
@dynamic htmlURL;
@dynamic body;
@dynamic createdAt;
@dynamic user;

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

-(void)setBody:(NSDictionary *)body forMIMEType:(NSString *)MIMEType
{
    
}

@end
