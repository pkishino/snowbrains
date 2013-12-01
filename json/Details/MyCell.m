//
//  Myself.m
//  json
//
//  Created by Patrick Ziegler on 5/8/13.
//  Copyright (c) 2013 Patrick Ziegler. All rights reserved.
//

#import "MyCell.h"
bool liked;
@implementation MyCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
    }
    return self;
}

-(id)loadWithPost:(Post *)post{
    [self.posterTitle setAttributedString:[[NSAttributedString alloc] initWithHTMLData:[post.title dataUsingEncoding:NSUTF8StringEncoding] documentAttributes:NULL]];
    [self.posterDate setText:[NSDateFormatter localizedStringFromDate:post.date
                                                            dateStyle:NSDateFormatterShortStyle
                                                            timeStyle:NSDateFormatterFullStyle]];
    [self.posterAuthor setText:post.author.name];
    [self.posterExcerpt setAttributedString:[[NSAttributedString alloc] initWithHTMLData:[post.excerpt dataUsingEncoding:NSUTF8StringEncoding] documentAttributes:NULL]];
    [self.posterComments setBackgroundImage:[[UIImage imageNamed:@"Comments"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
    [self.posterComments setTitle:post.comment_count.stringValue forState:UIControlStateNormal];
    [self.posterComments.titleLabel setTextAlignment:NSTextAlignmentCenter];
    [self.posterToolbar setBarTintColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"snowbrains_buttonBackground"]]];
    [self.readPostButton setTag:post.oID.integerValue];
    [self.likePostButton setTag:post.oID.integerValue];
    if(post.likeID.intValue!=0){
        [self toggleLiked:YES];
    }else{
        [self toggleLiked:NO];
    }
    [self.posterThumb setImageWithURL:[NSURL URLWithString:post.thumbnail] placeholderImage:[UIImage imageNamed:@"mediumMobile"]];
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    [self toggleExcerpt];
}
- (IBAction)readPostClicked:(id)sender {
    NSInteger tag=((UIBarButtonItem*)sender).tag;
    [self.delegate readPost:[PostCollection retrievePost:@(tag)]];
}

- (IBAction)likeClicked:(id)sender {
    NSInteger tag=((UIBarButtonItem*)sender).tag;
    Post* post=[PostCollection retrievePost:@(tag)];
    if(!liked){
        [FBActionBlock performFBLike:YES onItem:post withCompletion:^(NSError *error, id result) {
            if(!error){
                NSString *resultId=[(NSDictionary*)result valueForKey:@"id"];
                [post setLikeID:@(resultId.integerValue)];
                [self toggleLiked:YES];
            }}];
    }else{
        [FBActionBlock performFBLike:NO onItem:post withCompletion:^(NSError *error, id result) {
            if(!error){
                [post setLikeID:nil];
                [self toggleLiked:NO];
            }}];
    }
}
-(void)toggleLiked:(BOOL)status{
    if(status){
        [self.likePostButton setImage:[UIImage imageNamed:@"Liked"]];
        liked=YES;
    }else{
        [self.likePostButton setImage:[UIImage imageNamed:@"Unliked"]];
        liked=NO;
    }
}
-(void)toggleExcerpt{
        [self.posterDim setHidden:![self isSelected]];
        [self.posterExcerpt setHidden:![self isSelected]];
        [self.posterComments setHidden:![self isSelected]];
        [self.posterTitle setHidden:![self isSelected]];
        [self.posterAuthor setHidden:![self isSelected]];
}

@end
