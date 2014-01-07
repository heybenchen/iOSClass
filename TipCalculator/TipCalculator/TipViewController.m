//
//  TipViewController.m
//  TipCalculator
//
//  Created by Ben Chen on 12/28/13.
//  Copyright (c) 2013 Ben Chen. All rights reserved.
//

#import "TipViewController.h"
#import "SettingsViewController.h"

@interface TipViewController ()
@property (weak, nonatomic) IBOutlet UITextField *billAmount;
@property (weak, nonatomic) IBOutlet UILabel *tipAmount;
@property (weak, nonatomic) IBOutlet UILabel *tipPercentage;
@property (weak, nonatomic) IBOutlet UILabel *totalAmount;
@property (weak, nonatomic) IBOutlet UISegmentedControl *tipControl;

- (IBAction)onTap:(id)sender;
- (IBAction)onBillAmountChanged:(id)sender;

@end

@implementation TipViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Best Tip Calculator";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Refresh Values
    [self updateValues];
    
    // Nav Bar
    UINavigationBar *navBar = self.navigationController.navigationBar;
    navBar.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor]};
    navBar.barTintColor = [UIColor colorWithRed:81/255.0f green:51/255.0f blue:136/255.0f alpha:1.0f];
    navBar.translucent = NO;
    
    // Settings
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Settings" style:UIBarButtonItemStylePlain target:self action:@selector(onSettingsButton)];
    
    // Bill Amount
    UIView *padding = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 17, 20)];
    self.billAmount.leftView = padding;
    self.billAmount.leftViewMode = UITextFieldViewModeAlways;
    //self.billAmount.tintColor = [UIColor clearColor];
    self.billAmount.adjustsFontSizeToFitWidth = NO;
    [self.billAmount becomeFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onTap:(id)sender {
    [self updateValues];
}

- (IBAction)onBillAmountChanged:(id)sender {
    [self updateValues];
}

- (void)updateValues{
    float billAmount = [self.billAmount.text floatValue];
    
    // Load default tip value
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *defaultTipValue = [defaults objectForKey:@"defaultTip"];
    
    NSArray *tipArray = @[@(15), @(18), @(20), defaultTipValue];
    
    // If the "default" tip value matches one of the available
    // options (15, 18, or 20), then select the corresponding
    // value on the tip control. Otherwise, select "default".
    int index = 3;
    NSLog(@"%@", defaultTipValue);
    if ([defaultTipValue isEqualToString: @"15"] == TRUE) {
        index = 0;
    }
    else if ([defaultTipValue isEqualToString: @"18"] == TRUE) {
        index = 1;
    }
    else if ([defaultTipValue isEqualToString: @"20"] == TRUE) {
        index = 2;
    }
    [self.tipControl setSelectedSegmentIndex:index];
    
    // Bind labels
    float tipPercentage = [tipArray[self.tipControl.selectedSegmentIndex] floatValue];
    [self.tipPercentage setText: [NSString stringWithFormat:@"(%g%%)", tipPercentage]];
    float tipAmount = billAmount * (tipPercentage / 100);
    self.tipAmount.text = [NSString stringWithFormat:@"$%0.2f", tipAmount];
    self.totalAmount.text = [NSString stringWithFormat:@"$%0.2f", tipAmount + [self.billAmount.text floatValue]];
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

-(void)onSettingsButton{
    [self.navigationController pushViewController:[[SettingsViewController alloc] init] animated:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    NSLog(@"view will appear");
    [self updateValues];
}

- (void)viewDidAppear:(BOOL)animated {
    NSLog(@"view did appear");
}

- (void)viewWillDisappear:(BOOL)animated {
    NSLog(@"view will disappear");
}

- (void)viewDidDisappear:(BOOL)animated {
    NSLog(@"view did disappear");
}

@end
