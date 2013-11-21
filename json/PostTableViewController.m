//
//  ViewController.m
//  json
//
//  Created by Patrick Ziegler on 3/8/13.
//  Copyright (c) 2013 Patrick Ziegler. All rights reserved.
//

#import "PostTableViewController.h"
#import "PostObject.h"
#import "PostCollection.h"
#import "PostViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <FacebookSDK.h>


#define sBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)

@interface PostTableViewController ()

@end

@implementation PostTableViewController{
    dispatch_queue_t queue;
}
- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.tableView setDelegate:self];
    static NSString *CellIdentifier = @"CustomCellReuseID";
    [self.tableView registerNib:[UINib nibWithNibName:@"MyCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:CellIdentifier];
    MyCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[MyCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    [self.tableView setRowHeight:cell.frame.size.height];
    self.allPosts=[PostCollection new];
    
    queue=dispatch_queue_create("com.jasontest.queue",nil);
    
    [self retrieveData];
}

-(void)retrieveData{
    dispatch_async(sBgQueue, ^{
        self.allPosts.postCollection=[self.allPosts retrieveLatestPosts];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
            if(self.refreshControl.isRefreshing){
                [self.refreshControl endRefreshing];
            }
        });
    });
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.allPosts.postCollection count];
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *CellIdentifier = @"CustomCellReuseID";
    
    MyCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[MyCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.delegate=self;
    Post *postData=(self.allPosts.postCollection)[indexPath.row];
    PostObject *post=[[PostObject alloc]initWithPost:postData];
    [cell.posterTitle setAttributedString:[[NSAttributedString alloc] initWithHTMLData:[post.title dataUsingEncoding:NSUTF8StringEncoding] documentAttributes:NULL]];
    [cell.posterDate setText:[NSString stringWithFormat:@"%@",post.date]];
    [cell.posterAuthor setText:post.author];
    [cell.posterExcerpt setAttributedString:[[NSAttributedString alloc] initWithHTMLData:[post.excerpt dataUsingEncoding:NSUTF8StringEncoding] documentAttributes:NULL]];
    [cell.posterComments setBackgroundImage:[[UIImage imageNamed:@"Comments"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
    [cell.posterComments setTitle:[post.commentCount stringValue] forState:UIControlStateNormal];
    [cell.posterComments.titleLabel setTextAlignment:NSTextAlignmentCenter];
    [cell.posterToolbar setBarTintColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"snowbrains_buttonBackground"]]];
    [cell.readPostButton setTag:post.ID.integerValue];
    [cell.likePostButton setTag:post.ID.integerValue];
    if(post.likeID){
        [cell toggleLiked:YES];
    }else{
        [cell toggleLiked:NO];
    }
    [cell.posterThumb setImageWithURL:post.thumbnail placeholderImage:[UIImage imageNamed:@"mediumMobile"]];

    return cell;
    
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
- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}
- (NSIndexPath *)tableView:(UITableView *)tableView willDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    return indexPath;
}

- (IBAction)pulledToRefresh:(id)sender {
    [self retrieveData];
}

#pragma MyCelldelegate
-(void)readPost:(id)sender{
    NSInteger tag=((UIBarButtonItem *)sender).tag;
    Post *post=[self.allPosts retrievePost:[NSString stringWithFormat:@"%ld",(long)tag]];
    PostViewController *postView=[[PostViewController alloc]init];
    [postView setContent:post.content];
    [self.navigationController pushViewController:postView animated:YES];
//    [self.navigationController prepareForSegue:[UIStoryboardSegue segueWithIdentifier:@"showPost" source:self destination:postView performHandler:^{}] sender:nil];
}
-(void)likePost:(id)sender{
    if ([FBSession.activeSession.permissions
         indexOfObject:@"publish_actions"] == NSNotFound) {
        [FBSession.activeSession
         requestNewPublishPermissions:[NSArray arrayWithObject:@"publish_actions"]
         defaultAudience:FBSessionDefaultAudienceFriends
         completionHandler:^(FBSession *session, NSError *error) {
             if (!error) {
                 // re-call assuming we now have the permission
                 [self likePost:sender];
             }
         }];
    }else{
        NSInteger tag=((UIBarButtonItem *)sender).tag;
        Post *post=[self.allPosts retrievePost:[NSString stringWithFormat:@"%ld",(long)tag]];
        NSMutableDictionary<FBGraphObject> *action = [FBGraphObject graphObject];
        action[@"object"] = [NSString stringWithFormat:@"%@",post.postUrl];
        
        [FBRequestConnection startForPostWithGraphPath:@"me/og.likes"
                                           graphObject:action
                                     completionHandler:^(FBRequestConnection *connection,
                                                         id result,
                                                         NSError *error) {
                                         NSLog(@"%@",error);
                                         if(!error){
                                             NSString *resultId=[(NSDictionary*)result valueForKey:@"id"];
                                             [post setLikeID:resultId];
                                         }
                                     }];
    }
}
-(void)unlikePost:(id)sender{
    NSInteger tag=((UIBarButtonItem *)sender).tag;
    Post *post=[self.allPosts retrievePost:[NSString stringWithFormat:@"%ld",(long)tag]];
    [FBRequestConnection startWithGraphPath:post.likeID
                                 parameters:nil
                                 HTTPMethod:@"DELETE"
                          completionHandler:^(FBRequestConnection *connection,
                                              id result,
                                              NSError *error) {
                              if(!error){
                                  [post setLikeID:nil];
                              }
                          }];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
