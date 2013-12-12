//
//  CommentViewController.m
//  json
//
//  Created by Patrick Ziegler on 12/12/13.
//  Copyright (c) 2013 Patrick Ziegler. All rights reserved.
//

#import "CommentViewController.h"
#import "Post.h"
#import "CommentCell.h"

@class Comment;
@interface CommentViewController (){
    NSArray *comments;
}

@end

@implementation CommentViewController
-(void)viewDidLoad{
    if (self.commentSet.count>0) {
        NSSortDescriptor *dates = [NSSortDescriptor sortDescriptorWithKey:@"date" ascending:YES];
        comments = [self.commentSet sortedArrayUsingDescriptors:[NSArray arrayWithObject:dates]];
    }else{
        comments=[NSArray new];
    }
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return comments.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CommentCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    return [cell initWithComment:comments[indexPath.row]];
}


@end
