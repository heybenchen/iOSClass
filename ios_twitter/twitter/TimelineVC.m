//
//  TimelineVC.m
//  twitter
//
//  Created by Timothy Lee on 8/4/13.
//  Copyright (c) 2013 codepath. All rights reserved.
//

#import "TimelineVC.h"
#import "TweetCell.h"
#import "ComposeViewController.h"
#import "Tweet.h"

@interface TimelineVC ()

@property (nonatomic, strong) NSMutableArray *tweets;
@property (strong) TweetCell *cellPrototype;

- (void)onSignOutButton;
- (void)reload;

@end

@implementation TimelineVC

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        self.title = @"Twitter";
        [self reload];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Nav Bar
    UINavigationBar *navBar = self.navigationController.navigationBar;
    navBar.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor]};
    navBar.barTintColor = [UIColor colorWithRed:85/255.0f green:172/255.0f blue:238/255.0f alpha:1.0f];
    navBar.translucent = NO;
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Sign Out" style:UIBarButtonItemStylePlain target:self action:@selector(onSignOutButton)];
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor whiteColor];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"pencil.png"] style:UIBarButtonItemStylePlain target:self action:@selector(onComposeButton)];
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor whiteColor];
    
    //load prototype table cell nib
    static NSString *CellIdentifier = @"TweetCell";
    [self.tableView registerNib:[UINib nibWithNibName:@"TweetCell" bundle:nil] forCellReuseIdentifier:CellIdentifier];
    self.cellPrototype = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.tweets.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"TweetCell";
    TweetCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    Tweet *tweet = self.tweets[indexPath.row];
    
    //set width depending on device orientation
    cell.frame = CGRectMake(cell.frame.origin.x, cell.frame.origin.y, tableView.frame.size.width, cell.frame.size.height);
    CGFloat bodyLabelHeight = [self sizeOfLabel:cell.body withText:tweet.text].height;
    
    cell.body.frame = CGRectMake(cell.body.frame.origin.x, cell.body.frame.origin.y, cell.body.frame.size.width, bodyLabelHeight);
    
    // Bind data
    cell.body.text = tweet.text;
    cell.userName.text = tweet.userName;
    cell.userScreenName.text = tweet.userScreenName;
    cell.timeStamp.text = [tweet getTimeSinceCreated];
    
    // Load profile image
    NSURL *url = [NSURL URLWithString:tweet.userProfileImage];
    if ([cell.userImage isImageWithURLNew:url.absoluteString]) {
        [cell.userImage setImageWithURL:url.absoluteString placeholderImage:nil success:^(BOOL cachedImage){
            if (!cachedImage) {
                cell.userImage.alpha = 0.0;
                [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                    cell.userImage.alpha = 1.0;
                } completion:nil];
            }
        } failure:^{
            NSLog(@"Error fetching image with url %@", url);
        }];
    }
    
    return cell;
}

- (CGSize)sizeOfLabel:(UILabel *)label withText:(NSString *)text {
    return [text sizeWithFont:label.font constrainedToSize:label.frame.size lineBreakMode:label.lineBreakMode];
}

// Adjust cell height automagically
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    Tweet *tweet = self.tweets[indexPath.row];
    
    //set width depending on device orientation
    self.cellPrototype.frame = CGRectMake(self.cellPrototype.frame.origin.x, self.cellPrototype.frame.origin.y, tableView.frame.size.width, self.cellPrototype.frame.size.height);
    
    CGFloat bodyLabelHeight = [self sizeOfLabel:self.cellPrototype.body withText:tweet.text].height;
    CGFloat padding = self.cellPrototype.body.frame.origin.y;
    
    CGFloat combinedHeight = padding + bodyLabelHeight + padding + padding + padding/2;
    CGFloat minHeight = padding + bodyLabelHeight + padding + padding/2;
    
    return MAX(combinedHeight, minHeight);
}

- (void)addTweetToTop:(Tweet *)tweet {
    NSLog(@"Added %@", tweet);
    if (self.tweets == nil) {
        self.tweets = [[NSMutableArray alloc] initWithCapacity:21];
    }
    [self.tweets insertObject:tweet atIndex:0];
    [self.tableView reloadData];
}

- (void)addItemViewController:(id)controller didFinishSendingTweet:(Tweet *)tweet {
    [self addTweetToTop:tweet];
}

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
 {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 }
 else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

/*
 #pragma mark - Navigation
 
 // In a story board-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 
 */

#pragma mark - Private methods

- (void)onSignOutButton {
    [User setCurrentUser:nil];
}

- (void)onComposeButton {
    ComposeViewController *composeView = [[ComposeViewController alloc] initWithNibName:nil bundle:nil];
    composeView.delegate = self;
    [self presentViewController:composeView animated:YES completion:nil];
}

- (void)reload {
    [[TwitterClient instance] homeTimelineWithCount:20 sinceId:0 maxId:0 success:^(AFHTTPRequestOperation *operation, id response) {
        NSLog(@"%@", response);
        self.tweets = [Tweet tweetsWithArray:response];
        [self.tableView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", error.description);
    }];
}

@end
