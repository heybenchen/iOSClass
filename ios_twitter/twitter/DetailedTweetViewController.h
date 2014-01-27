//
//  DetailedTweetViewController.h
//  twitter
//
//  Created by Ben Chen on 1/26/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CachedImageView.h"
#import "Tweet.h"

@interface DetailedTweetViewController : UIViewController

@property (strong) Tweet *tweet;

@property (strong) NSString *filePath;

@end
