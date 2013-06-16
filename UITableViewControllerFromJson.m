//  Created by salexkidd on 2013/06/15.
//  Copyright (c) 2013 salexkidd. All rights reserved.
//

#import "UITableViewControllerFromJson.h"

@interface UITableViewControllerFromJson ()

@end

@implementation UITableViewControllerFromJson

@synthesize tableWithGroupData = _tableWithGroupData;



- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    return self;
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.tableWithGroupData count];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSDictionary *target_dict = self.tableWithGroupData[section];
    return [[target_dict objectForKey:@"row_data"] count];
    
}

- (NSString *)tableView: (UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSDictionary *target_dict = self.tableWithGroupData[section];
    return [target_dict objectForKey:@"category_label"];
}

#pragma mark - Table view delegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";

    NSArray *rows = [self.tableWithGroupData[indexPath.section] objectForKey:@"row_data"];
    NSDictionary *row = [rows objectAtIndex:indexPath.row];
    NSString *cell_type = [row objectForKey:@"cell_type"];
    UITableViewCell *cell =  [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }

    if ([cell_type isEqualToString:@"text_edit"]) {
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

        UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 290, cell.frame.size.height)];
        textField.textColor = [UIColor colorWithRed:59.0/255.0 green:85.0/255.0 blue:133.0/255.0 alpha:1.0];
        textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        textField.textAlignment = NSTextAlignmentLeft;
        textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        textField.returnKeyType = UIReturnKeyDone;
        cell.accessoryView = textField;

        NSString *edit_change_action = [row objectForKey:@"edit_change_action"];
        if (edit_change_action) {
            if ([self respondsToSelector:NSSelectorFromString(edit_change_action)]) {
                [textField addTarget:self action:NSSelectorFromString(edit_change_action) forControlEvents:UIControlEventEditingChanged];
            } else {
                NSLog(@"Can't set perform %@", edit_change_action);
            }
        }

        NSString *edit_done_action = [row objectForKey:@"edit_done_action"];
        if (edit_done_action) {
            if ([self respondsToSelector:NSSelectorFromString(edit_done_action)]) {
                [textField addTarget:self action:NSSelectorFromString(edit_done_action) forControlEvents:UIControlEventEditingDidEndOnExit];
            } else {
                NSLog(@"Can't set perform %@", edit_done_action);
            }
        }
    }
    
    NSString *label = [row objectForKey:@"label"];
    if (label) {
        cell.textLabel.text = label;
    } else {
        cell.textLabel.text = @"";
    }
    
    
    NSString *accessory_type = [row objectForKey:@"accessory_type"];
    if([accessory_type isEqualToString:@"DisclosureIndicator"]){
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    } else if ([accessory_type isEqualToString:@"DisclosureButton"]){
        cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
    }

    NSString *did_make_cell_action = [row objectForKey:@"did_make_cell_action"];
    if(did_make_cell_action != nil) {
        if ([self respondsToSelector:NSSelectorFromString(did_make_cell_action)]) {
            [self performSelector:NSSelectorFromString(did_make_cell_action) withObject:cell];
        }
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    /*
     jsonで指定された next_view があれば 指定された storyboard_name から 指定された storyboard_id のViewControllerを
     探し出し、self.navigationControllerにpushします
     */
    NSArray *rows = [self.tableWithGroupData[indexPath.section] objectForKey:@"row_data"];
    NSDictionary *row = [rows objectAtIndex:indexPath.row];
    NSString *cell_type = [row objectForKey:@"cell_type"];
    
    if([cell_type isEqualToString:@"next_view"]) {
        [self makeNextViewCell: row];
        
    } else if ([cell_type isEqualToString:@"push_action"]) {
        [self makePushActionCell:row indexPath:indexPath];
        
    } else if ([cell_type isEqualToString:@"texteidt"]) {
        
    }
}

#pragma mark - From Json Function

- (BOOL)makeNextViewCell:(NSDictionary *) row {
    NSDictionary *next_view = [row objectForKey:@"next_view"];
    NSString *storyboard_name = [next_view objectForKey:@"storyboard_name"];
    NSString *storyboard_id = [next_view objectForKey:@"storyboard_id"];
    UIStoryboard *mainStoryBoard = nil;
    id view_controller = nil;

    NSLog(@"storyboard_name:%@", storyboard_name);
    NSLog(@"storyboard_id:%@", storyboard_id);
    
    if (storyboard_id != nil || storyboard_name != nil) {
        @try {
            mainStoryBoard = [UIStoryboard storyboardWithName:storyboard_name bundle:nil];
            view_controller = [mainStoryBoard instantiateViewControllerWithIdentifier: storyboard_id];
            NSLog(@"%@", view_controller);
            [self.navigationController pushViewController:view_controller animated:YES];
            
        } @catch (NSException *exception) {
            NSLog(@"%@", exception);
        }
    }
    return YES;
}

- (BOOL)makePushActionCell:(NSDictionary *) row indexPath:(NSIndexPath *) indexPath {
    NSString *push_action = [row objectForKey:@"push_action"];
    if (push_action != nil) {
        if ([self respondsToSelector:NSSelectorFromString(push_action)]) {
            [self performSelector:NSSelectorFromString(push_action) withObject:indexPath];
        }
    }
    return YES;
}

@end
