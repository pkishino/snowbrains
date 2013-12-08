//
//  ViewController.m
//  json
//
//  Created by Patrick Ziegler on 3/8/13.
//  Copyright (c) 2013 Patrick Ziegler. All rights reserved.
//

#import "PostTableViewController.h"
#import "PostCollection.h"
#import "PostViewController.h"

@interface PostTableViewController ()

@end

@implementation PostTableViewController{
    NSMutableOrderedSet* posts;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.tableView setDelegate:self];
    [self retrieveData];
}

-(void)mainThreadReload{
    dispatch_async(dispatch_get_main_queue(), ^{
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self.tableView reloadData];
        if(self.refreshControl.isRefreshing){
            [self.refreshControl endRefreshing];}});
}
-(void)retrieveLatestData{
        [PostCollection retrieveLatestPostsWithCompletion:^(BOOL success, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            posts=[NSMutableOrderedSet orderedSetWithArray:[PostCollection retrieveAllPosts]];
            if(posts.count>0){
                [self mainThreadReload];
            }else{
                [ErrorAlert postError:error];
            }
        });}];
}
-(void)retrieveData{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        posts=[NSMutableOrderedSet orderedSetWithArray:[PostCollection retrieveAllPosts]];
        if(posts.count>0){
            [self mainThreadReload];
        }else{
            [self retrieveLatestData];
        }
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [posts count];
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    MyCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[MyCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.delegate=self;
    return [cell loadWithPost:(posts)[indexPath.row]];
}

-(NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    MyCell *cell =(MyCell*)[self.tableView cellForRowAtIndexPath:indexPath];
    if([cell isSelected]){
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        return nil;
    }
    return indexPath;
}

- (IBAction)pulledToRefresh:(id)sender {
    [self retrieveLatestData];
}

#pragma MyCelldelegate
-(void)pushViewController:(UIViewController *)vc{
    [self.navigationController pushViewController:vc animated:YES];
}
-(void)presentViewController:(UIViewController*)vc{
    [self presentViewController:vc animated:YES completion:nil];
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:@"PostViewSegue"]){
        PostViewController* postView=segue.destinationViewController;
        postView.content=(NSString*)sender;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
