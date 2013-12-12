//
//  CommentCell.m
//  json
//
//  Created by Patrick Ziegler on 12/12/13.
//  Copyright (c) 2013 Patrick Ziegler. All rights reserved.
//

#import "CommentCell.h"

@implementation CommentCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}
-(id)initWithComment:(Comment *)comment{
    [self.commentView setAttributedString:[[NSAttributedString alloc] initWithHTMLData:[comment.content dataUsingEncoding:NSUTF8StringEncoding] documentAttributes:NULL]];
    [self.Author setText:comment.name];
    [self.Date setText:[NSDateFormatter localizedStringFromDate:comment.date dateStyle:NSDateFormatterShortStyle timeStyle:NSDateFormatterNoStyle]];
    return self;
}

@end
