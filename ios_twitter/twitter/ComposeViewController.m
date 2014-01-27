//
//  ComposeViewViewController.m
//  twitter
//
//  Created by Ben Chen on 1/26/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import <Social/Social.h>
#import "ComposeViewController.h"
#import "CachedImageView.h"
#import "User.h"
#import "TimelineVC.h"

@interface ComposeViewController ()
@property (weak, nonatomic) IBOutlet CachedImageView *userImage;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UILabel *userScreenName;
@property (weak, nonatomic) IBOutlet UITextView *body;
@property (weak, nonatomic) IBOutlet UILabel *characterCount;

@property User *currentUser;

- (IBAction)onCancelClicked:(id)sender;
- (IBAction)onTweetClicked:(id)sender;

@end

@implementation ComposeViewController

NSInteger maxCharacterCount = 140;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.body.delegate = self;
    
    // Bind user info
    self.currentUser = [User currentUser];
    self.userName.text = [self.currentUser objectForKey:@"name"];
    self.userScreenName.text = [NSString stringWithFormat:@"@%@",[self.currentUser objectForKey:@"screen_name"]];
    
    if (self.replyToId.length != 0) {
        [self.body becomeFirstResponder];
    }
    
    // Load profile image
    NSURL *url = [NSURL URLWithString:[self.currentUser objectForKey:@"profile_image_url"]];
    if ([self.userImage isImageWithURLNew:url.absoluteString]) {
        [self.userImage setImageWithURL:url.absoluteString placeholderImage:nil success:^(BOOL cachedImage){
            if (!cachedImage) {
                self.userImage.alpha = 0.0;
                [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                    self.userImage.alpha = 1.0;
                } completion:nil];
            }
        } failure:^{
            NSLog(@"Error fetching image with url %@", url);
        }];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)textViewDidChange:(UITextView *)textView
{
    // Update character count
    int len = self.body.text.length;
    self.characterCount.text=[NSString stringWithFormat:@"%i",140-len];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    // Prevent user from typing past the character limit
    BOOL flag = NO;
    if([text length] == 0)
    {
        if([textView.text length] != 0)
        {
            flag = YES;
            return YES;
        }
        else {
            return NO;
        }
    }
    else if([[textView text] length] > 139)
    {
        return NO;
    }
    return YES;
}

- (BOOL) textViewShouldBeginEditing:(UITextView *)textView
{
    // Clear placeholder text
    if(textView.tag == 0) {
        if (self.replyToId.length != 0) {
            textView.text = [NSString stringWithFormat:@"%@ ", self.replyToId];
            [self textViewDidChange:self.body];
        } else {
            textView.text = @"";
        }
        textView.textColor = [UIColor blackColor];
        textView.tag = 1;
    }
    return YES;
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    // Add placeholder text back
    if([textView.text length] == 0)
    {
        textView.text = @"What's on your mind?";
        textView.textColor = [UIColor lightGrayColor];
        textView.tag = 0;
    }
}

- (IBAction)onCancelClicked:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)onTweetClicked:(id)sender
{
    if (self.replyToId.length != 0) {
        [[TwitterClient instance] postTweetInReply:self.body.text replyTo:self.replyToId success:^(AFHTTPRequestOperation *operation, id response) {
            NSLog(@"%@", response);
            
            // Update the timeline to show the new tweet
            Tweet *newTweet = [[Tweet alloc] initWithDictionary:response];
            [self.delegate addItemViewController:self didFinishSendingTweet:newTweet];
            [self dismissViewControllerAnimated:YES completion:nil];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"%@", error);
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Unable to post tweet."
                                                            message:@"Please check your connection and try again later."
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
        }];
    } else {
        [[TwitterClient instance] postTweet:self.body.text success:^(AFHTTPRequestOperation *operation, id response) {
            NSLog(@"%@", response);
            
            // Update the timeline to show the new tweet
            Tweet *newTweet = [[Tweet alloc] initWithDictionary:response];
            [self.delegate addItemViewController:self didFinishSendingTweet:newTweet];
            [self dismissViewControllerAnimated:YES completion:nil];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"%@", error);
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Unable to post tweet."
                                                            message:@"Please check your connection and try again later."
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
        }];
    }
}

@end
