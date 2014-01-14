//
//  ViewController.m
//  TemperatureConverter
//
//  Created by Ben Chen on 1/14/14.
//  Copyright (c) 2014 Ben Chen. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITextField *cTextField;
@property (weak, nonatomic) IBOutlet UITextField *fTextField;

@end

@implementation ViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Temperature Converter";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)onCChanged:(id)sender {
    NSString *value = [NSString stringWithFormat:@"%g", [self convertCToF:[self.cTextField.text floatValue]]];
    self.fTextField.text = value;
}
- (IBAction)onFChanged:(id)sender {
    NSString *value = [NSString stringWithFormat:@"%g", [self convertFToC:[self.fTextField.text floatValue]]];
    self.cTextField.text = value;
}

- (float)convertCToF:(float) c {
    return c * 9.0f/5.0f + 32.0f;
}

- (float)convertFToC:(float) f {
    return (f - 32.0f) / (9.0f/5.0f);
}

@end
