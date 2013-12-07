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
    [self.posterDate setText:[NSDateFormatter localizedStringFromDate:post.date
                                                            dateStyle:NSDateFormatterShortStyle
                                                            timeStyle:NSDateFormatterFullStyle]];
    [self.posterAuthor setText:post.author.name];
    [self.posterExcerpt setAttributedString:[[NSAttributedString alloc] initWithHTMLData:[post.excerpt dataUsingEncoding:NSUTF8StringEncoding] documentAttributes:NULL]];
    [self.posterComments setBackgroundImage:[[UIImage imageNamed:@"Comments"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
    [self.posterComments setTitle:post.comment_count.stringValue forState:UIControlStateNormal];
    [self.posterComments.titleLabel setTextAlignment:NSTextAlignmentCenter];
    [self.posterToolbar setBarTintColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"snowbrains_buttonBackground"]]];
    [self setTag: post.oID.integerValue];
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
    Post* post=[PostCollection retrievePost:@(self.tag)];
    [self.delegate performSegueWithIdentifier:@"PostViewSegue" sender:post.content];
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
//            if(!error){
                [self toggleLiked:NO];
                [self setLikeId:nil];
//            }
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
        [self.posterExcerpt setHidden:![self isSelected]];
        [self.posterComments setHidden:![self isSelected]];
        [self.posterTitle setHidden:![self isSelected]];
        [self.posterAuthor setHidden:![self isSelected]];
}

@end
