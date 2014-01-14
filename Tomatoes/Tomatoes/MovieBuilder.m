//
//  MovieBuilder.m
//  Tomatoes
//
//  Created by Ben Chen on 1/13/14.
//  Copyright (c) 2014 Ben Chen. All rights reserved.
//

#import "Movie.h"
#import "MovieBuilder.h"

@implementation MovieBuilder

+ (NSArray *)moviesFromJSON:(NSData *)objectNotation error:(NSError **)error
{
    NSError *localError = nil;
    NSDictionary *parsedObject = [NSJSONSerialization JSONObjectWithData:objectNotation options:0 error:&localError];
    
    if (localError != nil) {
        *error = localError;
        return nil;
    }
    
    NSMutableArray *movies = [[NSMutableArray alloc] init];
    
    NSArray *results = [parsedObject valueForKey:@"movies"];
    NSLog(@"%d movies found.", results.count);
    
    for (NSDictionary *movieDic in results) {
        Movie *movie = [[Movie alloc] init];
        
        for (NSString *key in movieDic) {
            if ([movie respondsToSelector:NSSelectorFromString(key)]) {
                [movie setValue:[movieDic valueForKey:key] forKey:key];
            }
        }
        
        [movies addObject:movie];
    }
    
    return movies;
}

@end
