//
//  MainListController.m
//  ToDo
//
//  Created by Ben Chen on 1/20/14.
//  Copyright (c) 2014 Ben Chen. All rights reserved.
//

#import "ToDoListController.h"
#import "AddItemController.h"
#import "ToDoCell.h"
//#import "ToDoItem.h"

@interface ToDoListController ()
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *todoItems;
@property (weak, nonatomic) IBOutlet UITextField *itemTextField;

- (IBAction) EditTable:(id)sender;

@end

@implementation ToDoListController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        [self loadInitialItems];
        [self.tableView sizeToFit];
    }
    return self;
}

- (void) loadInitialItems {
    // Load tasks from UserDefaults
    self.todoItems = [[[NSUserDefaults standardUserDefaults] arrayForKey:@"todoItems"] mutableCopy];
    [self.tableView reloadData];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self loadInitialItems];
    
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithTitle:@" Manage" style:UIBarButtonItemStyleBordered target:self action:@selector(EditTable:)];
    addButton.tintColor = [UIColor whiteColor];
    [self.navigationItem setLeftBarButtonItem:addButton];
    
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
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    int count = [self.todoItems count];
    if(self.editing) count++;
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    ToDoCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    int count = 0;
    if(self.editing && indexPath.row != 0)
        count = 1;

    // "Add Task" row
    if(indexPath.row == ([self.todoItems count]) && self.editing){
        cell.itemTextField.text = @"";
        cell.itemTextField.tintColor = [UIColor whiteColor];
        [cell.itemTextField becomeFirstResponder];
        return cell;
    }
    
    // Bind item data (name and completion status)
    cell.itemTextField.text = [self.todoItems objectAtIndex:indexPath.row];
    cell.itemTextField.tintColor = [UIColor whiteColor];
    if (self.editing) {
        cell.itemTextField.enabled = YES;
    } else {
        cell.itemTextField.enabled = NO;
    }
    return cell;
}

// Toggle edit mode
- (IBAction) EditTable:(id)sender{
    if(self.editing)
    {
        [super setEditing:NO animated:YES];
        [self.tableView setEditing:NO animated:NO];
        [self.tableView reloadData];
        [self.navigationItem.leftBarButtonItem setTitle:@" Manage"];
        [self.navigationItem.leftBarButtonItem setStyle:UIBarButtonItemStylePlain];
    }
    else
    {
        [super setEditing:YES animated:YES];
        [self.tableView setEditing:YES animated:YES];
        [self.tableView reloadData];
        [self.navigationItem.leftBarButtonItem setTitle:@" Done"];
        [self.navigationItem.leftBarButtonItem setStyle:UIBarButtonItemStyleDone];
    }
    
    [self storeTasks];
}

// Configure table to show add (plus) icon for adding new content and delete (minus) icon for content that already exists.
- (UITableViewCellEditingStyle)tableView:(UITableView *)aTableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    // Check if editing or no items
    if (self.editing == NO || !indexPath) return UITableViewCellEditingStyleNone;
    
    // Plus/Minus icon logic
    if (self.editing && indexPath.row == ([self.todoItems count])) {
        return UITableViewCellEditingStyleInsert;
    } else {
        return UITableViewCellEditingStyleDelete;
    }
    return UITableViewCellEditingStyleNone;
}

// Add or remove tasks
- (void)tableView:(UITableView *)aTableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.todoItems removeObjectAtIndex:indexPath.row];
        [self.tableView reloadData];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        ToDoCell *cell = (ToDoCell *)[self.tableView cellForRowAtIndexPath:indexPath];
        [self.todoItems insertObject:cell.itemTextField.text atIndex:[self.todoItems count]];
        [self.tableView reloadData];
    }
    [self storeTasks];
}

// Determine whether a given row is eligible for reordering or not.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Don't let the "Add Task" row be moved
    if (indexPath.row < self.todoItems.count){
        return YES;
    }
    else {
        return NO;
    }
}
// Process the row move. This means updating the data model to correct the item indices.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath
      toIndexPath:(NSIndexPath *)toIndexPath {
    // Prevent moving to/from the "Add Task" cell
    if (toIndexPath.row == self.todoItems.count || fromIndexPath.row == self.todoItems.count) {
        [self.tableView reloadData];
        return;
    }
    NSString *item = [self.todoItems objectAtIndex:fromIndexPath.row];
    [self.todoItems removeObject:item];
    [self.todoItems insertObject:item atIndex:toIndexPath.row];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (IBAction)unwindToList:(UIStoryboardSegue *)segue
{
    AddItemController *source = [segue sourceViewController];
    NSString *item = source.todoItem;
    if (item != nil) {
        [self.todoItems addObject:item];
        [self.tableView reloadData];
    }
    [self storeTasks];
}

- (void)storeTasks{
    // Save Tasks to UserDefaults
    [[NSUserDefaults standardUserDefaults] setObject:self.todoItems forKey:@"todoItems"];
    [[NSUserDefaults standardUserDefaults] synchronize];
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
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */

@end
