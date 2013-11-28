//
//  PostModel.m
//  json
//
//  Created by Patrick Ziegler on 23/11/13.
//  Copyright (c) 2013 Patrick Ziegler. All rights reserved.
//

#import "PostModel.h"
#import "Post.h"
#import "Author.h"
#import "Tag.h"
#import "Comment.h"
#import "Attachment.h"
#import "Image.h"
#import "Category.h"

@implementation PostModel
-(id)saveToCore{
    Post *post=[Post findFirstByAttribute:@"oID" withValue:self.oID];
    if(!post){
        post=[Post createEntity];
        post.oID=self.oID;
    }
    if(!post.author){
        post.author=[self.author saveToCore];
        [post.author importValuesForKeysWithObject:self.author];
    }
    if (!post.tags) {
        for (TagModel * tagModel in self.tags) {
            Tag *tag=[tagModel saveToCore];
            [tag importValuesForKeysWithObject:tagModel];
            [post addTagsObject:tag];
        }
    }
    if (!post.categories) {
        for (CategoryModel *categoryModel in self.categories) {
            Category *category=[categoryModel saveToCore];
            [category importValuesForKeysWithObject:categoryModel];
            [post addCategoriesObject:category];
        }
    }
    if(!post.comments){
        for (CommentModel *commentModel in self.comments) {
            Comment *comment=[commentModel saveToCore];
            [comment importValuesForKeysWithObject:commentModel];
            [post addCommentsObject:comment];
        }
    }
    if (!post.attachments) {
        for (AttachmentModel *attachmentModel in self.attachments) {
            Attachment *attachment=[attachmentModel saveToCore];
            [attachment importValuesForKeysWithObject:attachmentModel];
            [post addAttachmentsObject:attachment];
        }
    }
    if(!post.thumbnail_images){
        post.thumbnail_images=[self.thumbnail_images saveToCore];
    }
    return post;
    
}
@end
