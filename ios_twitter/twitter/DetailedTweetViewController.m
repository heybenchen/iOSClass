//
//  DetailedTweetViewController.m
//  twitter
//
//  Created by Ben Chen on 1/26/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import "DetailedTweetViewController.h"
#import "ComposeViewController.h"
#import "TimelineVC.h"
#import "TwitterClient.h"

@interface DetailedTweetViewController ()

@property (weak, nonatomic) IBOutlet CachedImageView *userImage;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UILabel *userScreenName;
@property (weak, nonatomic) IBOutlet UITextView *body;
@property (weak, nonatomic) IBOutlet UILabel *timeStamp;
@property (weak, nonatomic) IBOutlet UILabel *retweetCount;
@property (weak, nonatomic) IBOutlet UILabel *favoriteCount;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bodyHeight;

@property (weak, nonatomic) IBOutlet UIButton *replyButton;
@property (weak, nonatomic) IBOutlet UIButton *retweetButton;
@property (weak, nonatomic) IBOutlet UIButton *favoriteButton;

- (IBAction)onReplyButton:(id)sender;
- (IBAction)onRetweetButton:(id)sender;
- (IBAction)onFavoriteButton:(id)sender;

-(void)onBackButton;
-(void)onComposeButton;

@end

@implementation DetailedTweetViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Tweet";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Nav Bar
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Home" style:UIBarButtonItemStylePlain target:self action:@selector(onBackButton)];
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor whiteColor];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(onComposeButton)];
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor whiteColor];
    
    // Bind data
    self.body.text = self.tweet.text;
    self.userName.text = self.tweet.userName;
    self.userScreenName.text = self.tweet.userScreenName;
    self.retweetCount.text = [NSString stringWithFormat:@"%@", self.tweet.retweetCount];
    self.favoriteCount.text = [NSString stringWithFormat:@"%@", self.tweet.favoriteCount];
    
    // Time created
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"M/d/yy, hh:mm a"];
    self.timeStamp.text = [dateFormatter stringFromDate:self.tweet.createdAt];
    
    // Button icons
    if (self.tweet.retweeted) {
        UIImage *retweetButtonImage = [UIImage imageNamed:@"retweet_on"];
        [self.retweetButton setImage:retweetButtonImage forState:UIControlStateNormal];
    }
    if (self.tweet.favorited) {
        UIImage *favoriteButtonImage = [UIImage imageNamed:@"favorite_on"];
        [self.favoriteButton setImage:favoriteButtonImage forState:UIControlStateNormal];
    }
    
    // Load profile image
    NSURL *url = [NSURL URLWithString:self.tweet.userProfileImage];
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
    
    
    // Resize text body to fit content
    CGSize sizeThatShouldFitTheContent = [self.body sizeThatFits:self.body.frame.size];
    self.bodyHeight.constant = sizeThatShouldFitTheContent.height;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

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

- (IBAction)onReplyButton:(id)sender {
    ComposeViewController *composeView = [[ComposeViewController alloc] initWithNibName:nil bundle:nil];
    composeView.replyToId = self.tweet.userScreenName;
    NSUInteger parentIndex = [self.navigationController.viewControllers indexOfObject:self.navigationController.topViewController];
    TimelineVC *parentVc = (TimelineVC *)[self.navigationController.viewControllers objectAtIndex:parentIndex - 1];
    composeView.delegate = parentVc;
    [self presentViewController:composeView animated:YES completion:nil];
}

- (IBAction)onRetweetButton:(id)sender {
    [[TwitterClient instance] postRetweet:self.tweet.tweetId success:^(AFHTTPRequestOperation *operation, id response) {
        NSLog(@"%@", response);
        UIImage *btnImage = [UIImage imageNamed:@"retweet_on"];
        [self.retweetButton setImage:btnImage forState:UIControlStateNormal];
        [self.tweet.data setValue:[NSNumber numberWithBool:YES] forKey:@"retweeted"];
        self.retweetCount.text = [NSString stringWithFormat:@"%d", [self.retweetCount.text integerValue] + 1];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", error);
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Unable to retweet."
                                                        message:@"Please check your connection and try again later."
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }];
}

- (IBAction)onFavoriteButton:(id)sender {
    if (!self.tweet.favorited) {
        [[TwitterClient instance] postFavoriteCreate:self.tweet.tweetId success:^(AFHTTPRequestOperation *operation, id response) {
            NSLog(@"%@", response);
            UIImage *btnImage = [UIImage imageNamed:@"favorite_on"];
            [self.favoriteButton setImage:btnImage forState:UIControlStateNormal];
            [self.tweet.data setValue:[NSNumber numberWithBool:YES] forKey:@"favorited"];
            self.favoriteCount.text = [NSString stringWithFormat:@"%d", [self.favoriteCount.text integerValue] + 1];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"%@", error);
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Unable to favorite."
                                                            message:@"Please check your connection and try again later."
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
        }];
    } else {
        [[TwitterClient instance] postFavoriteDestroy:self.tweet.tweetId success:^(AFHTTPRequestOperation *operation, id response) {
            NSLog(@"%@", response);
            UIImage *btnImage = [UIImage imageNamed:@"favorite"];
            [self.favoriteButton setImage:btnImage forState:UIControlStateNormal];
            [self.tweet.data setValue:[NSNumber numberWithBool:NO] forKey:@"favorited"];
            self.favoriteCount.text = [NSString stringWithFormat:@"%d", [self.favoriteCount.text integerValue] - 1];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"%@", error);
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Unable to remove favorite."
                                                            message:@"Please check your connection and try again later."
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
        }];
    }
    
}

-(void) onBackButton
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)onComposeButton
{
    ComposeViewController *composeView = [[ComposeViewController alloc] initWithNibName:nil bundle:nil];
    NSUInteger parentIndex = [self.navigationController.viewControllers indexOfObject:self.navigationController.topViewController];
    TimelineVC *parentVc = (TimelineVC *)[self.navigationController.viewControllers objectAtIndex:parentIndex - 1];
    composeView.delegate = parentVc;
    [self presentViewController:composeView animated:YES completion:nil];
}

@end
