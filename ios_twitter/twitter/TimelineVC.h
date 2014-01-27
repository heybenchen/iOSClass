//
//  TimelineVC.h
//  twitter
//
//  Created by Timothy Lee on 8/4/13.
//  Copyright (c) 2013 codepath. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ComposeViewController.h"
#import "Tweet.h"

@interface TimelineVC : UITableViewController <ModalViewControllerDelegate>

@property (nonatomic) NSString *tweet;

- (void)addTweetToTop:(Tweet *)tweet;

@end
