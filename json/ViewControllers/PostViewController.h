//
//  PostViewController.h
//  json
//
//  Created by Patrick Ziegler on 13/11/13.
//  Copyright (c) 2013 Patrick Ziegler. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import <DTAttributedTextView.h>
#import <MediaPlayer/MPMoviePlayerController.h>
#import "Post.h"

@interface PostViewController : UIViewController<DTLazyImageViewDelegate,DTAttributedTextContentViewDelegate,UIActionSheetDelegate,DTWebVideoViewDelegate>
@property (strong,nonatomic)NSString* content;
@property (strong,nonatomic)NSURL *lastActionLink;
@property (strong, nonatomic) IBOutlet DTAttributedTextView *contentView;

@end
