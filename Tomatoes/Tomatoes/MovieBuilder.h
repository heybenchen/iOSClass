//
//  MovieBuilder.h
//  Tomatoes
//
//  Created by Ben Chen on 1/13/14.
//  Copyright (c) 2014 Ben Chen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MovieBuilder : NSObject

+ (NSArray *)moviesFromJSON:(NSData *)objectNotation error:(NSError **)error;

@end
