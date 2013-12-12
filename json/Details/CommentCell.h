//
//  CommentCell.h
//  json
//
//  Created by Patrick Ziegler on 12/12/13.
//  Copyright (c) 2013 Patrick Ziegler. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Comment.h"

static NSString *CellIdentifier = @"CommentCellID";

@interface CommentCell : UITableViewCell
@property (strong, nonatomic) IBOutlet DTAttributedTextView *commentView;
@property (strong, nonatomic) IBOutlet UILabel *Author;
@property (strong, nonatomic) IBOutlet UILabel *Date;

-(id)initWithComment:(Comment*)comment;
@end
