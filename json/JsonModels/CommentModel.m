//
//  CommentModel.m
//  json
//
//  Created by Patrick Ziegler on 23/11/13.
//  Copyright (c) 2013 Patrick Ziegler. All rights reserved.
//

#import "CommentModel.h"
#import "Comment.h"
#import "Author.h"

@implementation CommentModel
-(id)saveToCore{
    Comment *comment=[Comment findFirstByAttribute:@"oID" withValue:self.oID];
    if(!comment){
        comment=[Comment createEntity];
        comment.oID=self.oID;
    }
    if(self.author&&!comment.author){
        comment.author=[self.author saveToCore];
        [comment.author importValuesForKeysWithObject:self.author];
    }
    return comment;
}

@end
