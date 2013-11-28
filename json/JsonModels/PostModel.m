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
    if(!post.thumbnail_images){
        if (!self.thumbnail_images.oID) {
            self.thumbnail_images.oID=self.oID;
        }
        post.thumbnail_images=[self.thumbnail_images saveToCore];
    }
    if (post.tags.count!=self.tags.count) {
        for (TagModel * tagModel in self.tags) {
            Tag *tag=[tagModel saveToCore];
            [tag importValuesForKeysWithObject:tagModel];
            [post addTagsObject:tag];
        }
    }
    if (post.categories.count!=self.categories.count) {
        for (CategoryModel *categoryModel in self.categories) {
            Category *category=[categoryModel saveToCore];
            [category importValuesForKeysWithObject:categoryModel];
            [post addCategoriesObject:category];
        }
    }
    if(post.comments.count!=self.comments.count){
        for (CommentModel *commentModel in self.comments) {
            Comment *comment=[commentModel saveToCore];
            [comment importValuesForKeysWithObject:commentModel];
            [post addCommentsObject:comment];
        }
    }
    if (post.attachments.count!=self.attachments.count) {
        for (AttachmentModel *attachmentModel in self.attachments) {
            Attachment *attachment=[attachmentModel saveToCore];
            [attachment importValuesForKeysWithObject:attachmentModel];
            [post addAttachmentsObject:attachment];
        }
    }
    return post;
    
}
@end
