//
//  Tweet.m
//  twitter
//
//  Created by Timothy Lee on 8/5/13.
//  Copyright (c) 2013 codepath. All rights reserved.
//

#import "Tweet.h"

@implementation Tweet

@synthesize text;
@synthesize userName;
@synthesize userScreenName;
@synthesize userProfileImage;
@synthesize createdAt;

// Time conversion variables
long sSecsInAYear = 31536000;
long sSecsInAMonth = 2592000;
long sSecsInADay = 86400;
long sSecsInAHour = 3600;
long sSecsInAMin = 60;

- (NSString *)text {
    NSString *string = [self.data valueOrNilForKeyPath:@"text"];
    string = [string stringByReplacingOccurrencesOfString: @"&amp;" withString:@"&"];
    string = [string stringByReplacingOccurrencesOfString: @"&lt;" withString:@"&"];
    return string;
}

- (NSString *)userName {
    if ([self.data valueOrNilForKeyPath:@"retweeted_status"] != nil){
        return [self.data valueOrNilForKeyPath:@"retweeted_status.user.name"];
    }
    return [self.data valueOrNilForKeyPath:@"user.name"];
}

- (NSString *)userScreenName {
    if ([self.data valueOrNilForKeyPath:@"retweeted_status"] != nil){
        return [@"@" stringByAppendingString: [self.data valueOrNilForKeyPath:@"retweeted_status.user.screen_name"]];
    }
    return [@"@" stringByAppendingString: [self.data valueOrNilForKeyPath:@"user.screen_name"]];
}

- (NSString *)userProfileImage {
    if ([self.data valueOrNilForKeyPath:@"retweeted_status"] != nil){
        return [self.data valueOrNilForKeyPath:@"retweeted_status.user.profile_image_url"];
    }
    return [self.data valueOrNilForKeyPath:@"user.profile_image_url"];
}

- (NSDate *)createdAt {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
    [dateFormatter setDateFormat:@"EEE MMM dd HH:mm:ss Z yyyy"];
    NSString *timeCreated = [self.data valueOrNilForKeyPath:@"created_at"];
    return[dateFormatter dateFromString:timeCreated];
}

- (NSString *)getTimeSinceCreated {
    NSDate *now = [NSDate date];
    NSTimeInterval timeDiff = [now timeIntervalSinceDate:self.createdAt];
    if((timeDiff / sSecsInAYear) >= 1) {
       return [NSString stringWithFormat:@"%.0fy", (timeDiff/sSecsInAYear)];
    } else if((timeDiff / sSecsInAMonth) >= 1) {
        return [NSString stringWithFormat:@"%.0fmon", (timeDiff/sSecsInAMonth)];
    } else if((timeDiff / sSecsInADay) >= 1) {
        return [NSString stringWithFormat:@"%.0fd", (timeDiff/sSecsInADay)];
    } else if((timeDiff / sSecsInAHour) >= 1) {
        return [NSString stringWithFormat:@"%.0fh", (timeDiff/sSecsInAHour)];
    } else if((timeDiff / sSecsInAMin) >= 1) {
        return [NSString stringWithFormat:@"%.0fm", (timeDiff/sSecsInAMin)];
    } else if((timeDiff / sSecsInAMin) >= 0){
        return [NSString stringWithFormat:@"%.0fs", timeDiff];
    } else {
        return @"now";
    }
}

+ (NSMutableArray *)tweetsWithArray:(NSArray *)array {
    NSMutableArray *tweets = [[NSMutableArray alloc] initWithCapacity:array.count];
    for (NSDictionary *params in array) {
        [tweets addObject:[[Tweet alloc] initWithDictionary:params]];
    }
    return tweets;
}

@end
