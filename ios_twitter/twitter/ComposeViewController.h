//
//  ComposeViewViewController.h
//  twitter
//
//  Created by Ben Chen on 1/26/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tweet.h"

@protocol ModalViewControllerDelegate<NSObject>

-(void)addItemViewController:(id)controller didFinishSendingTweet:(Tweet *)tweet;

@end

@interface ComposeViewController : UIViewController <UITextViewDelegate>

@property (nonatomic, weak) id <ModalViewControllerDelegate> delegate;

@property (strong) NSString *replyToId;

@end
