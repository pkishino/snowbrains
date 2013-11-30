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
#import "Post.h"
#import <FacebookSDK.h>


#define sBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)

@interface PostTableViewController ()

@end

@implementation PostTableViewController{
    NSMutableOrderedSet* posts;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.tableView setDelegate:self];
    [self.tableView registerNib:[UINib nibWithNibName:@"MyCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:CellIdentifier];
    [self.tableView setRowHeight:[MyCell getHeight]];
}

-(void)retrieveLatestData{
    dispatch_async(sBgQueue, ^{
        [PostCollection retrieveLatestPostsWithCompletion:^(BOOL success, NSError *error, NSArray *array) {
            if(!error){
                [posts addObjectsFromArray:array];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.tableView reloadData];
                    if(self.refreshControl.isRefreshing){
                        [self.refreshControl endRefreshing];}});
            }else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    [[[UIAlertView alloc]initWithTitle:@"error" message:[NSString stringWithFormat:@"An error occurred:%@",error] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] show];});}}];});
}
-(void)retrieveData{
    dispatch_async(sBgQueue,^{
        posts=[NSMutableOrderedSet orderedSetWithArray:[PostCollection retrieveAllPosts]];
        if(posts.count>0){
            dispatch_async(dispatch_get_main_queue(),^{
                [self.tableView reloadData];});
        }else{
            [self retrieveLatestData];
        }
    });
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
        [tableView.delegate tableView:tableView willDeselectRowAtIndexPath:indexPath];
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        [tableView.delegate tableView:tableView didDeselectRowAtIndexPath:indexPath];
        return nil;

    }
    return indexPath;
}

- (IBAction)pulledToRefresh:(id)sender {
    [self retrieveLatestData];
}

#pragma MyCelldelegate
-(void)readPost:(id)sender{
    NSInteger tag=((UIBarButtonItem *)sender).tag;
    Post *post=[PostCollection retrievePost:[NSNumber numberWithInteger:tag]];
    PostViewController *postView=[[PostViewController alloc]init];
    [postView setContent:post.content];
    [self.navigationController pushViewController:postView animated:YES];
}

-(void)likePost:(id)sender withCompletion:(void (^)(BOOL))completion{
    NSInteger tag=((UIBarButtonItem *)sender).tag;
    Post *post=[PostCollection retrievePost:[NSNumber numberWithInteger:tag]];
    [FBActionBlock performFBLike:YES onItem:post withCompletion:^(NSError *error, id result) {
        NSLog(@"%@",error);
        if(!error){
            NSString *resultId=[(NSDictionary*)result valueForKey:@"id"];
            [post setLikeID:[NSNumber numberWithInteger:resultId.integerValue]];
            completion(YES);
            [self.tableView reloadData];
        }else{
            completion(NO);
        }
    }];
}
-(void)unlikePost:(id)sender withCompletion:(void (^)(BOOL))completion{
    NSInteger tag=((UIBarButtonItem *)sender).tag;
    Post *post=[PostCollection retrievePost:[NSNumber numberWithInteger:tag]];
    [FBActionBlock performFBLike:NO onItem:post withCompletion:^(NSError *error, id result) {
        if(!error){
            [post setLikeID:nil];
            completion(NO);
            [self.tableView reloadData];
        }else{
            completion(YES);
        }
    }];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
