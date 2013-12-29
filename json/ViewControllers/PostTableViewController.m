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
#import "PostCommentViewController.h"
#import "CommentViewController.h"
#import <LMModalSegue.h>

@interface PostTableViewController ()

@end

@implementation PostTableViewController{
    NSMutableOrderedSet* posts;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.tableView setDelegate:self];
    
    [self.view setTintColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"snowbrainsTextColour"]]];
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"snowbrains_buttonBackground"]]];
    self.navigationItem.titleView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"snowbrains_logo"]];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(retrieveData) name:@"PostsDownloaded" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(retrieveData) name:@"NewPostsAvailable" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(receivedOldDataNotification:) name:@"OldPostsDownloaded" object:nil];
    
}
-(void)viewWillAppear:(BOOL)animated{
    [self retrieveData];
}
-(void)mainThreadReload{
    [MBProgressHUD hideAllHUDsForView:self.navigationController.view animated:YES];
    [self.tableView reloadData];
    if(self.refreshControl.isRefreshing){
        [self.refreshControl endRefreshing];
    }
}
-(void)retrieveData{
    [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    posts=[NSMutableOrderedSet orderedSetWithArray:[PostCollection retrieveAllPosts]];
    if(posts.count>0){
        [self mainThreadReload];
    }
}
-(void)retrieveOlder:(NSDate*)date{
    [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    if(date){
        posts=[NSMutableOrderedSet orderedSetWithArray:[PostCollection retrievePostsBefore:date]];
    }
    if(posts.count>0){
        [self mainThreadReload];
    }
}
-(void)receivedOldDataNotification:(NSNotification*)data{
    [self retrieveOlder:[[data userInfo] valueForKey:@"date"]];
}
- (IBAction)pulledToRefresh:(id)sender {
    [self retrieveData];
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
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row==posts.count-1){
        NSDate* last=((Post*)posts.lastObject).date;
        if(last){
            [self retrieveOlder:last];
        }
    }
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
        return;
    }
    if([segue.identifier isEqualToString:@"PostCommentSegue"]){
        PostCommentViewController* commentView=((UINavigationController*)segue.destinationViewController).viewControllers[0];
        commentView.post_id=(NSNumber*)sender;
        return;
    }
    if([segue.identifier isEqualToString:@"ViewCommentsSegue"]){
        CommentViewController* commentView=segue.destinationViewController;
        commentView.commentSet=(NSSet*)sender;
        return;
    }
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
