//
//  Myself.m
//  json
//
//  Created by Patrick Ziegler on 5/8/13.
//  Copyright (c) 2013 Patrick Ziegler. All rights reserved.
//

#import "MyCell.h"
#import "ErrorAlert.h"
#import "PostViewController.h"
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
    [self.posterTitle setNumberOfLines:1];
    [self.posterTitle setLineBreakMode:NSLineBreakByTruncatingTail];
    [self.posterTitle sizeToFit];
    [self.posterTitle setCenter:CGPointMake(self.center.x, self.posterTitle.center.y)];
    [self.posterDate setText:[NSDateFormatter localizedStringFromDate:post.date dateStyle:NSDateFormatterShortStyle timeStyle:NSDateFormatterNoStyle]];
    [self.posterExcerpt setAttributedString:[[NSAttributedString alloc] initWithHTMLData:[post.excerpt dataUsingEncoding:NSUTF8StringEncoding] documentAttributes:NULL]];
    [self.posterExcerpt setNumberOfLines:5];
    [self.posterExcerpt setLineBreakMode:NSLineBreakByTruncatingTail];
    [self.posterExcerpt sizeToFit];
    [self.posterExcerpt setCenter:CGPointMake(self.center.x, self.posterExcerpt.center.y)];
    
    [self.posterAuthor setText:post.author.name];
    [self.posterComments setBackgroundImage:[[UIImage imageNamed:@"Comments"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
    [self.posterComments setTitle:post.comment_count.stringValue forState:UIControlStateNormal];
    [self.posterComments.titleLabel setTextAlignment:NSTextAlignmentCenter];
    if (post.comment_count.intValue>0) {
        [self.posterComments setEnabled:YES];
        [self.posterComments setTintColor:nil];
    }else{
        [self.posterComments setEnabled:NO];
        [self.posterComments setTintColor:[UIColor grayColor]];
    }
    [self.posterToolbar setBarTintColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"snowbrains_buttonBackground"]]];
    [self setTag: post.oID.integerValue];
    if(post.likeID.intValue!=0){
        [self toggleLiked:YES];
    }else{
        [self toggleLiked:NO];
    }
    [self.posterThumb setImageWithURL:[NSURL URLWithString:post.thumbnail] placeholderImage:[UIImage imageNamed:@"mediumMobile"]];
    
    [self.posterCommentView.layer setCornerRadius:10.0f];
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    [self toggleExcerpt];
}
- (IBAction)viewCommentsClicked:(id)sender {
    Post* post=[PostCollection retrievePost:@(self.tag)];
    [self.delegate performSegueWithIdentifier:@"ViewCommentsSegue" sender:post.comments];
}
- (IBAction)readPostClicked:(id)sender {
    Post* post=[PostCollection retrievePost:@(self.tag)];
    [self.delegate performSegueWithIdentifier:@"PostViewSegue" sender:post.content];
}
-(IBAction)writeCommentClicked:(id)sender{
    [self.delegate performSegueWithIdentifier:@"PostCommentSegue" sender:[NSNumber numberWithInteger:self.tag]];
}

- (IBAction)likeClicked:(id)sender {
    NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
    Post* post=[PostCollection retrievePost:@(self.tag)];
    if(post){
    if(!liked){
        [FBActionBlock performFBLikeonItem:post.url withCompletion:^(NSError *error, id result) {
            if(!error){
                [f setNumberStyle:NSNumberFormatterNoStyle];
                NSNumber* number=[f numberFromString:[(NSDictionary*)result valueForKey:@"id"]];
                [self toggleLiked:YES];
                [self setLikeId:number];
            }else{
                if(((NSNumber*)[error.userInfo valueForKey:@"com.facebook.sdk:HTTPStatusCode"]).intValue==400){
                    NSString *message=[[[[error.userInfo valueForKey:@"com.facebook.sdk:ParsedJSONResponseKey"]valueForKey:@"body"]valueForKey:@"error"]valueForKey:@"message"];
                    NSArray *words=[message componentsSeparatedByString:@" "];
                    [f setNumberStyle:NSNumberFormatterNoStyle];
                    NSNumber* number=[f numberFromString:words.lastObject];
                    [self toggleLiked:YES];
                    [self setLikeId:number];
                }else{
                [ErrorAlert postError:error];
                }
            }}];
    }else{
        [FBActionBlock performFBUnLikeonItem:post.likeID.stringValue withCompletion:^(NSError *error, id result) {
                [self toggleLiked:NO];
                [self setLikeId:nil];
         }];
    }
 }
}
-(void)setLikeId:(NSNumber*)number{
    dispatch_async(dispatch_get_main_queue(), ^{
        Post* post=[PostCollection retrievePost:@(self.tag)];
        [post setLikeID:number];
    });
    
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
- (IBAction)shareClicked:(id)sender{
    Post *post=[PostCollection retrievePost:@(self.tag)];
    NSArray *shareItems=@[@"SnowBrains is awesome!",[NSURL URLWithString:post.url]];
    UIActivityViewController *shareAction=[[UIActivityViewController alloc]initWithActivityItems:shareItems applicationActivities:nil];
    [self.delegate presentViewController:shareAction];
    
}
-(void)toggleExcerpt{
        [self.posterDim setHidden:![self isSelected]];
}

@end
