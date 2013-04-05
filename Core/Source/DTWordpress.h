//
//  DTWordpress.h
//  WordpressDemo
//
//  Created by Oliver Drobnik on 22.03.13.
//  Copyright (c) 2013 Drobnik KG. All rights reserved.
//

#import "DTXMLRPCService.h"

/**
 Wrapper around methods for communicating with a Wordpress XML-RPC service.
 
 After creating the wordpress service with an endpoint, set the userName and password. Completion handlers have an error parameter. If this is non-nil then you can use this to display an error message.
 */
@interface DTWordpress : DTXMLRPCService

/**
 @name Setting the Credentials
 */

/**
 The user name for authentication
 */
@property (nonatomic, copy) NSString *userName;

/**
 The password for authentication
 */
@property (nonatomic, copy) NSString *password;

/**
 @name API Operations
 */

/**
 Returns information about all the blogs a given user is a member of.
 @param completion The completion handler when the request is finished
 */
- (void)getUsersBlogsWithCompletion:(void(^)(NSArray *blogs, NSError *error))completion;

/**
 Retrieve list of categories.
 @param completion The completion handler when the request is finished
 */
- (void)getCategoriesWithCompletion:(void(^)(NSArray *categories, NSError *error))completion;

/**
 Returns one blog post
 @param identifier The post number of the post to be retrieved
 @param completion The completion handler when the request is finished
 */
- (void)getPostWithIdentifier:(NSUInteger)identifier completion:(void(^)(NSDictionary *content, NSError *error))completion;

/**
 Creates a new blog post
 @param content The content dictionary for the new post
 @param shouldPublish Set to `YES` if the blog post should be published, `NO` to set it as draft.
 @param completion The completion handler when the request is finished
 */
- (void)newPostWithContent:(NSDictionary *)content shouldPublish:(BOOL)shouldPublish completion:(void(^)(NSInteger postID, NSError *error))completion;

/**
 Creates a new media item
 @param fileName The file name of the media item
 @param contentType The MIME content type of the data
 @param data The data of the media item
 @param shouldOverwrite Set to `YES` to overwrite an item of the same name if it already exists
 @param completion The completion handler when the request is finished
 */
- (void)newMediaObjectWithFileName:(NSString *)fileName contentType:(NSString *)contentType data:(NSData *)data shouldOverwrite:(BOOL)shouldOverwrite completion:(void(^)(NSInteger mediaID, NSURL *mediaURL, NSError *error))completion;
@end
