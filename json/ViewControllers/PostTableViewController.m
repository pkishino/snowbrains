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
#import "Author.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <FacebookSDK.h>


#define sBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)

@interface PostTableViewController ()

@end

@implementation PostTableViewController{
    NSArray* posts;
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
    
    dispatch_async(sBgQueue,^{
        posts=[PostCollection retrieveAllPosts];
        dispatch_async(dispatch_get_main_queue(),^{
            [self.tableView reloadData];});
    });
}

-(void)retrieveData{
    dispatch_async(sBgQueue, ^{
        [PostCollection retrieveLatestPostsWithCompletion:^(BOOL success, NSError *error, NSArray *array) {
            if(!error){
                posts=array;
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.tableView reloadData];
                    if(self.refreshControl.isRefreshing){
                        [self.refreshControl endRefreshing];}});
            }else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    [[[UIAlertView alloc]initWithTitle:@"error" message:[NSString stringWithFormat:@"An error occurred:%@",error] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] show];});}}];});
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
    
    static NSString *CellIdentifier = @"CustomCellReuseID";
    
    MyCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[MyCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.delegate=self;
    Post *post=(posts)[indexPath.row];
    [cell.posterTitle setAttributedString:[[NSAttributedString alloc] initWithHTMLData:[post.title dataUsingEncoding:NSUTF8StringEncoding] documentAttributes:NULL]];
    [cell.posterDate setText:[NSDateFormatter localizedStringFromDate:post.date
                                                            dateStyle:NSDateFormatterShortStyle
                                                            timeStyle:NSDateFormatterFullStyle]];
    [cell.posterAuthor setText:post.author.name];
    [cell.posterExcerpt setAttributedString:[[NSAttributedString alloc] initWithHTMLData:[post.excerpt dataUsingEncoding:NSUTF8StringEncoding] documentAttributes:NULL]];
    [cell.posterComments setBackgroundImage:[[UIImage imageNamed:@"Comments"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
    [cell.posterComments setTitle:post.comment_count.stringValue forState:UIControlStateNormal];
    [cell.posterComments.titleLabel setTextAlignment:NSTextAlignmentCenter];
    [cell.posterToolbar setBarTintColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"snowbrains_buttonBackground"]]];
    [cell.readPostButton setTag:post.oID.integerValue];
    [cell.likePostButton setTag:post.oID.integerValue];
    if(post.likeID.intValue!=0){
        [cell toggleLiked:YES];
    }else{
        [cell toggleLiked:NO];
    }
    [cell.posterThumb setImageWithURL:[NSURL URLWithString:post.thumbnail] placeholderImage:[UIImage imageNamed:@"mediumMobile"]];

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
    Post *post=[PostCollection retrievePost:[NSNumber numberWithInteger:tag]];
    PostViewController *postView=[[PostViewController alloc]init];
    [postView setContent:post.content];
    [self.navigationController pushViewController:postView animated:YES];
}

-(void)likePost:(id)sender{
    [self runFaceBookBlock:^{
        NSInteger tag=((UIBarButtonItem *)sender).tag;
        Post *post=[PostCollection retrievePost:[NSNumber numberWithInteger:tag]];
        NSMutableDictionary<FBGraphObject> *action = [FBGraphObject graphObject];
        action[@"object"] = [NSString stringWithFormat:@"%@",post.url];
        
        [FBRequestConnection startForPostWithGraphPath:@"me/og.likes"
                                           graphObject:action
                                     completionHandler:^(FBRequestConnection *connection,
                                                         id result,
                                                         NSError *error) {
                                         NSLog(@"%@",error);
                                         if(!error){
                                             NSString *resultId=[(NSDictionary*)result valueForKey:@"id"];
                                             [post setLikeID:[NSNumber numberWithInteger:resultId.integerValue]];
                                             [self.tableView reloadData];
                                         }
                                     }];
    }];
}
-(void)unlikePost:(id)sender{
    [self runFaceBookBlock:^{
        NSInteger tag=((UIBarButtonItem *)sender).tag;
        Post *post=[PostCollection retrievePost:[NSNumber numberWithInteger:tag]];
        [FBRequestConnection startWithGraphPath:post.likeID.stringValue
                                     parameters:nil
                                     HTTPMethod:@"DELETE"
                              completionHandler:^(FBRequestConnection *connection,
                                                  id result,
                                                  NSError *error) {
                                  if(!error){
                                      [post setLikeID:nil];
                                      [self.tableView reloadData];
                                  }
                              }];
    }];
    
}
-(void)runFaceBookBlock:(void(^)(void))completion{
    if([[FBSession activeSession]isOpen]){
        if ([FBSession.activeSession.permissions
         indexOfObject:@"publish_actions"] == NSNotFound) {
        [FBSession.activeSession
         requestNewPublishPermissions:[NSArray arrayWithObject:@"publish_actions"]
         defaultAudience:FBSessionDefaultAudienceFriends
         completionHandler:^(FBSession *session, NSError *error) {
             if(!error&&completion){
                 completion();
             }
         }];
        }
    }else{
        [FBSession openActiveSessionWithPublishPermissions:[NSArray arrayWithObject:@"publish_actions"] defaultAudience:FBSessionDefaultAudienceFriends allowLoginUI:YES completionHandler:^(FBSession *session, FBSessionState status, NSError *error) {
            if(!error&&completion&&status==FBSessionStateOpen){
                completion();
            }
        }];
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
