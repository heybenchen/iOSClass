//
//  ToDoCell.m
//  ToDo
//
//  Created by Ben Chen on 1/20/14.
//  Copyright (c) 2014 Ben Chen. All rights reserved.
//

#import "ToDoCell.h"

@implementation ToDoCell


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)onTouchTextField:(id)sender {
}

@end
