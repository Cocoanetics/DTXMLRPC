//
//  DTXMLRPCService.h
//  WordpressDemo
//
//  Created by Oliver Drobnik on 22.03.13.
//  Copyright (c) 2013 Drobnik KG. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DTXMLRPCRequest;
@class DTXMLRPCResponse;

typedef void (^DTXMLRPCRequestCompletionHandler)(DTXMLRPCResponse *response);

/**
 An XML-RPC service. The service is created with an end-point to which DTXMLRPCRequest objects are sent. 
 */
@interface DTXMLRPCService : NSObject

/**
 @name Creating Requests
 */

/**
 Creates an XML-RPC service with a given endpoint.
 @param endpointURL The endpoint URL to send all function calls to
 */
- (id)initWithEndpointURL:(NSURL *)endpointURL;


/**
 @name Sending the Request
 */

/**
 Sends an XML-RPC request asynchronously and executes the completion handler upon completion
 
 In case of an error in the underlying NSURLConnection the error is contained in the error parameter of the DTXMLRPCResponse passed to the completion block.
 @param request The XML-RPC request to send
 @param completion The completion handler. 
 */
- (void)sendRequest:(DTXMLRPCRequest *)request completion:(DTXMLRPCRequestCompletionHandler)completion;
                                                           
@end
