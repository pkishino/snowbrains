//
//  CommentModel.h
//  json
//
//  Created by Patrick Ziegler on 23/11/13.
//  Copyright (c) 2013 Patrick Ziegler. All rights reserved.
//

#import "CommonModelInterface.h"
#import "AuthorModel.h"

@interface CommentModel : CommonModelInterface

@property (assign, nonatomic) int parent;

@property (strong, nonatomic) NSString* content;
@property (strong, nonatomic) NSString* name;
@property (strong, nonatomic) NSString* date;
@property (strong, nonatomic) NSString<Optional>* url;

@property (strong, nonatomic) AuthorModel<Optional>* author;

@end
