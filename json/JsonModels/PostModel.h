//
//  PostModel.h
//  json
//
//  Created by Patrick Ziegler on 23/11/13.
//  Copyright (c) 2013 Patrick Ziegler. All rights reserved.
//

#import "CommonModelInterface.h"
#import "ImageModel.h"
#import "AttachmentModel.h"
#import "AuthorModel.h"
#import "TagModel.h"
#import "CommentModel.h"
#import "CategoryModel.h"

@protocol TagModel @end
@protocol CommentModel @end
@protocol CategoryModel @end
@protocol AttachmentModel @end

@interface PostModel :CommonModelInterface

@property (assign, nonatomic) int comment_count;

@property (strong, nonatomic) NSString* status;
@property (strong, nonatomic) NSString* excerpt;
@property (strong, nonatomic) NSString* comment_status;
@property (strong, nonatomic) NSString* type;
@property (strong, nonatomic) NSString* date;
@property (strong, nonatomic) NSString* modified;
@property (strong, nonatomic) NSString* url;
@property (strong, nonatomic) NSString* content;
@property (strong, nonatomic) NSString* title;
@property (strong, nonatomic) NSString* thumbnail;
@property (strong, nonatomic) NSString* thumbnail_size;
@property (strong, nonatomic) NSString* slug;
@property (strong, nonatomic) NSString* title_plain;

@property (strong, nonatomic) AuthorModel* author;
@property (strong, nonatomic) ImageModel* thumbnail_images;

@property (strong, nonatomic)NSArray<TagModel>* tags;
@property (strong, nonatomic)NSArray<CategoryModel>* categories;
@property (strong, nonatomic)NSArray<AttachmentModel,Optional>* attachments;
@property (strong, nonatomic)NSArray<CommentModel,Optional>* comments;

@end
