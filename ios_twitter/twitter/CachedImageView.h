//
//  CachedImageView.h
//  twitter
//
//  Created by Ben Chen on 1/26/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UIImageView+AFNetworking.h>

@interface CachedImageView : UIImageView

@property (strong) NSString *filePath;

- (NSString *)cachedPNGFilePathForURL:(NSString *)url;
- (void)setImageWithURL:(NSString *)url
       placeholderImage:(UIImage *)placeholderImage
                success:(void (^)(BOOL cachedImage))success
                failure:(void (^)(void))failure;
- (BOOL)isImageWithURLNew:(NSString *)url;

@end
