//
//  UserSelectionViewController.m
//  json
//
//  Created by Patrick Ziegler on 9/12/13.
//  Copyright (c) 2013 Patrick Ziegler. All rights reserved.
//

#import "UserSelectionViewController.h"
static NSString *CellIdentifier = @"userCell";

@interface UserSelectionViewController (){
    NSMutableArray *users;
    NSDictionary *defaultUser;
    BOOL once;
}

@end

@implementation UserSelectionViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    defaultUser=[[NSUserDefaults standardUserDefaults] valueForKey:@"defaultUser"];
    NSArray*userCounts=(NSArray*)[[NSUserDefaults standardUserDefaults] valueForKey:@"users"];
    if(!userCounts&&defaultUser){
        userCounts=[NSMutableArray arrayWithObject:defaultUser];
    }
    users=[NSMutableArray arrayWithArray:userCounts];
}

- (void)viewDidAppear:(BOOL)animated
{
    if(users.count==0&&!once){
        once=YES;
        [self performSegueWithIdentifier:@"newUser" sender:nil];
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return users.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
	cell.textLabel.text = users[indexPath.row][@"name"];
    cell.detailTextLabel.text=users[indexPath.row][@"email"];
    if([users[indexPath.row][@"name"]isEqualToString:defaultUser[@"name"]]){
        [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
    }else{
        cell.accessoryView = nil;
    }
    return cell;
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    NSIndexPath *indexPath=[self.tableView indexPathForSelectedRow];
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
    if(indexPath){
        [[NSUserDefaults standardUserDefaults] setValue:users[indexPath.row] forKey:@"defaultUser"];
    }
}
-(BOOL)canPerformUnwindSegueAction:(SEL)action fromViewController:(UIViewController *)fromViewController withSender:(id)sender{
    return NO;
}
-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if(editingStyle==UITableViewCellEditingStyleDelete){
        if([users[indexPath.row][@"name"]isEqualToString:defaultUser[@"name"]]){
            defaultUser=nil;
            [[NSUserDefaults standardUserDefaults]setValue:nil forKey:@"defaultUser"];
        }
        
        [users removeObjectAtIndex:indexPath.row];
        [self.tableView reloadData];
        [[NSUserDefaults standardUserDefaults]setValue:users forKey:@"users"];
    }
}
@end
