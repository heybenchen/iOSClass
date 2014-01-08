//
//  SettingsViewController.m
//  TipCalculator
//
//  Created by Ben Chen on 12/29/13.
//  Copyright (c) 2013 Ben Chen. All rights reserved.
//

#import "SettingsViewController.h"

@interface SettingsViewController ()
@property (weak, nonatomic) IBOutlet UITextField *defaultTipPercentage;
- (IBAction)onFinishEdit:(id)sender;

@end

@implementation SettingsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Settings";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Nav Bar
    UINavigationBar *navBar = self.navigationController.navigationBar;
    navBar.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor]};
    navBar.barTintColor = [UIColor colorWithRed:81/255.0f green:51/255.0f blue:136/255.0f alpha:1.0f];
    navBar.translucent = NO;
    
    // Tip Percentage Text Field
    UIView *padding = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 17, 20)];
    self.defaultTipPercentage.leftView = padding;
    self.defaultTipPercentage.leftViewMode = UITextFieldViewModeAlways;
    
    // Load default value
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *tip =[defaults objectForKey:@"defaultTip"];
    self.defaultTipPercentage.text = tip;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onFinishEdit:(id)sender {
    
    // Save default value
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:self.defaultTipPercentage.text forKey:@"defaultTip"];
    [defaults synchronize];
}
@end
