//
//  MyCell.m
//  json
//
//  Created by Patrick Ziegler on 5/8/13.
//  Copyright (c) 2013 Patrick Ziegler. All rights reserved.
//

#import "MyCell.h"
#import <FacebookSDK.h>
bool liked;
@implementation MyCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    [self toggleExcerpt];
}
- (IBAction)readPostClicked:(id)sender {
    [self.delegate readPost:sender];
}

- (IBAction)likeClicked:(id)sender {
    if(!liked){
        [self toggleLiked:YES];
        [self.delegate likePost:sender];
    }else{
        [self toggleLiked:NO];
        [self.delegate unlikePost:sender];
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
