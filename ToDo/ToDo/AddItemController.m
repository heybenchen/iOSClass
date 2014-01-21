//
//  AddItemController.m
//  ToDo
//
//  Created by Ben Chen on 1/20/14.
//  Copyright (c) 2014 Ben Chen. All rights reserved.
//

#import "AddItemController.h"
#import "ToDoItem.h"

@interface AddItemController ()
@property (weak, nonatomic) IBOutlet UIBarButtonItem *cancelButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *doneButton;
@property (weak, nonatomic) IBOutlet UITextField *createTaskTextField;

@end

@implementation AddItemController

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
    [self.createTaskTextField becomeFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if (sender != self.doneButton) return;
    if (self.createTaskTextField.text.length > 0) {
        self.todoItem = self.createTaskTextField.text;
    }
}

@end
