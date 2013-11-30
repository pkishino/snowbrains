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

static NSString *CellIdentifier = @"CustomCellReuseID";

@interface MyCell : UITableViewCell
@property (strong,nonatomic) id delegate;
@property (weak, nonatomic) IBOutlet UIImageView *posterThumb;
@property (weak, nonatomic) IBOutlet DTAttributedLabel *posterTitle;
@property (weak, nonatomic) IBOutlet UILabel *posterDate;
@property (weak, nonatomic) IBOutlet UILabel *posterAuthor;
@property (weak, nonatomic) IBOutlet UIButton *posterComments;
@property (weak, nonatomic) IBOutlet UIToolbar *posterToolbar;
@property (weak, nonatomic) IBOutlet DTAttributedTextView *posterExcerpt;
@property (weak, nonatomic) IBOutlet UIView *posterDim;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *readPostButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *likePostButton;

- (IBAction)readPostClicked:(id)sender;

- (IBAction)likeClicked:(id)sender;

-(void)toggleExcerpt;
-(void)toggleLiked:(BOOL)status;
-(id)loadWithPost:(Post*)post;

+(int)getHeight;

@end
@protocol MyCellDelegate

-(void)readPost:(NSInteger)tag;
-(void)likePost:(NSInteger)tag withCompletion:(void (^)(BOOL success))completion;
-(void)unlikePost:(NSInteger)tag withCompletion:(void (^)(BOOL success))completion;

@end
