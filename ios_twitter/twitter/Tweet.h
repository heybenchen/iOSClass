//
//  Tweet.h
//  twitter
//
//  Created by Timothy Lee on 8/5/13.
//  Copyright (c) 2013 codepath. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Tweet : RestObject

@property (nonatomic, strong, readonly) NSString *tweetId;
@property (nonatomic, strong, readonly) NSString *text;
@property (nonatomic, strong, readonly) NSString *userScreenName;
@property (nonatomic, strong, readonly) NSString *userName;
@property (nonatomic, strong, readonly) NSString *userProfileImage;
@property (nonatomic, strong, readonly) NSDate *createdAt;
@property (nonatomic, strong, readonly) NSNumber *retweetCount;
@property (nonatomic, strong, readonly) NSNumber *favoriteCount;
@property (nonatomic, readonly) BOOL retweeted;
@property (nonatomic, readonly) BOOL favorited;

+ (NSMutableArray *)tweetsWithArray:(NSArray *)array;
- (NSString *)getTimeSinceCreated;

@end
