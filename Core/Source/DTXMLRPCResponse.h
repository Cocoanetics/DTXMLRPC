//
//  DTXMLRPCResponse.h
//  WordpressDemo
//
//  Created by Oliver Drobnik on 22.03.13.
//  Copyright (c) 2013 Drobnik KG. All rights reserved.
//

#import "DTXMLRPCMessage.h"

/**
 An XML-RPC response, as an answer to a DTXMLRPCRequest. 

@interface DTXMLRPCResponse : DTXMLRPCMessage

/**
 @name Creating a Response
 */
 
/**
 Creates an XML-RPC response from an XML-RPC value sequence
 
 The XML-RPC sequence might contain an array of parameters or an error.
 @param sequence The XML-RPC element sequence to construct the response from
 **/
- (id)initWithXMLRPCSequence:(NSArray *)sequence;

/**
 If an error was encoded in the response it ends up in this parameter
 */
@property (nonatomic, readonly) NSError *error;

@end
