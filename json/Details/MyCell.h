//
//  MyCell.h
//  json
//
//  Created by Patrick Ziegler on 5/8/13.
//  Copyright (c) 2013 Patrick Ziegler. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Post.h"
#import "Author.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "PostCollection.h"

static NSString *CellIdentifier = @"MyCellID";

@interface MyCell : UITableViewCell
@property (strong,nonatomic) id delegate;
@property (weak, nonatomic) IBOutlet UIImageView *posterThumb;
@property (weak, nonatomic) IBOutlet DTAttributedLabel *posterTitle;
@property (weak, nonatomic) IBOutlet UILabel *posterDate;
@property (weak, nonatomic) IBOutlet UILabel *posterAuthor;
@property (weak, nonatomic) IBOutlet UIButton *posterComments;
@property (weak, nonatomic) IBOutlet DTAttributedLabel *posterExcerpt;
@property (weak, nonatomic) IBOutlet UIView *posterDim;


@property (strong, nonatomic) IBOutlet UIView *posterCommentView;
@property (strong, nonatomic) IBOutlet UITextView *posterCommentText;
@property (strong, nonatomic) IBOutlet UIButton *posterCommentPost;
@property (strong, nonatomic) IBOutlet UIButton *posterCommentCancel;


@property (weak, nonatomic) IBOutlet UIToolbar *posterToolbar;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *likePostButton;

- (IBAction)readPostClicked:(id)sender;

-(void)toggleExcerpt;
-(void)toggleLiked:(BOOL)status;
-(id)loadWithPost:(Post*)post;

@end
@protocol MyCellDelegate

-(void)pushViewController:(UIViewController*)vc;
-(void)presentViewController:(UIViewController*)vc;

@end