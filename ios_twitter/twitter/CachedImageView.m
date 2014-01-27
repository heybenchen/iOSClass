//
//  CachedImageView.m
//  twitter
//
//  Created by Ben Chen on 1/26/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import "CachedImageView.h"
#import <UIImageView+AFNetworking.h>

@implementation CachedImageView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (NSString *)cachedPNGFilePathForURL:(NSString *)url
{
    NSString *fileName = [url lastPathComponent];
    NSString *cachePath = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0];
    NSString *pathExtension = [fileName pathExtension];
    NSRange extensionRange = [fileName rangeOfString:pathExtension];
    NSString *cachedFileName = [fileName stringByReplacingCharactersInRange:extensionRange withString:@"png"];
    NSString *cachedFilePath = [cachePath stringByAppendingPathComponent:cachedFileName];
    return cachedFilePath;
}

- (void)setImageWithURL:(NSString *)url
       placeholderImage:(UIImage *)placeholderImage
                success:(void (^)(BOOL cachedImage))success
                failure:(void (^)(void))failure
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        _filePath = [self cachedPNGFilePathForURL:url];
        if ([[NSFileManager defaultManager] fileExistsAtPath:_filePath]) {
            UIImage *image = [UIImage imageWithContentsOfFile:_filePath];
            dispatch_sync(dispatch_get_main_queue(), ^{
                self.image = image;
                if (self.image) {
                    success(YES);
                } else {
                    failure();
                }
            });
        } else {
            dispatch_sync(dispatch_get_main_queue(), ^{
                self.image = nil; // As we probably don't want to view an old image while downloading a new one
            });
            NSString *filePath = [_filePath copy];
            NSURLRequest *urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
            [self setImageWithURLRequest:urlRequest
                        placeholderImage:nil
                                 success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                     self.image = image;
                                     dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                                         NSError *error = nil;
                                         [UIImagePNGRepresentation(image) writeToFile:filePath
                                                                              options:NSDataWritingAtomic
                                                                                error:&error];
                                         if (error) {
                                             NSLog(@"error: %@", error.localizedDescription);
                                         }
                                     });
                                     success(NO);
                                 } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                                     failure();
                                 }];
        }
    });
}

- (BOOL)isImageWithURLNew:(NSString *)url
{
    if (!self.image) {
        return YES;
    }
    if ([[self cachedPNGFilePathForURL:url] isEqualToString:_filePath]) {
        return NO;
    }
    return YES;
}



@end
