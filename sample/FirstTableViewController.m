//
//  FirstTableViewController.m
//  sample
//
//  Created by salexkidd on 2013/06/16.
//  Copyright (c) 2013年 salexkidd. All rights reserved.
//

#import "FirstTableViewController.h"

@interface FirstTableViewController ()

@end

@implementation FirstTableViewController

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    NSString *path = [[NSBundle mainBundle] pathForResource:@"first_table_view" ofType:@"json"];
    NSData *json = [NSData dataWithContentsOfFile:path];
    self.tableWithGroupData = [NSJSONSerialization JSONObjectWithData:json options:0 error:NULL];
    return self;
}

- (void)showAlert:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Ahhhhg!!!"
                                                    message:@"You pushed me!"
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
}

- (void)changeText:(UITextField *)textField {
    NSLog(@"You change text!!!");
    NSLog(@"%@", textField.text);
}

- (void)doneText:(UITextField *)textField {
    NSLog(@"Done!");
    [textField resignFirstResponder];
}


@end
