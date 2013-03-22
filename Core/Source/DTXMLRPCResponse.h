//
//  DTXMLRPCResponse.h
//  WordpressDemo
//
//  Created by Oliver Drobnik on 22.03.13.
//  Copyright (c) 2013 Drobnik KG. All rights reserved.
//

#import "DTXMLRPCMessage.h"

@interface DTXMLRPCResponse : DTXMLRPCMessage

/**
 Creates an XML-RPC response from an XML-RPC value sequence
 **/
- (id)initWithXMLRPCSequence:(NSArray *)sequence;

/**
 If an error was encoded in the response it ends up in this parameter
 */
@property (nonatomic, readonly) NSError *error;

@end
