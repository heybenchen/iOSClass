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

@interface DetailedTweetViewController ()
@property (weak, nonatomic) IBOutlet CachedImageView *userImage;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UILabel *userScreenName;
@property (weak, nonatomic) IBOutlet UITextView *body;

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
    
    // Resize text body to fit content
    self.body.frame = CGRectMake(self.body.frame.origin.x, self.body.frame.origin.y, self.body.frame.size.width, self.body.frame.size.height + self.body.contentInset.top + self.body.contentInset.bottom);

    // Nav Bar
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Home" style:UIBarButtonItemStylePlain target:self action:@selector(onBackButton)];
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor whiteColor];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"pencil.png"] style:UIBarButtonItemStylePlain target:self action:@selector(onComposeButton)];
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor whiteColor];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) onBackButton {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)onComposeButton {
    ComposeViewController *composeView = [[ComposeViewController alloc] initWithNibName:nil bundle:nil];
    NSUInteger parentIndex = [self.navigationController.viewControllers indexOfObject:self.navigationController.topViewController];
    TimelineVC *parentVc = (TimelineVC *)[self.navigationController.viewControllers objectAtIndex:parentIndex - 1];
    composeView.delegate = parentVc;
    [self presentViewController:composeView animated:YES completion:nil];
}

@end
