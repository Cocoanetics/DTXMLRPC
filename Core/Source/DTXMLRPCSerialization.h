//
//  DTXMLRPCSerialization.h
//  WordpressDemo
//
//  Created by Oliver Drobnik on 22.03.13.
//  Copyright (c) 2013 Drobnik KG. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DTXMLRPCMessage;

/**
 Methods to serialize and deserialize XML-RPC messages, e.g. method calls and responses.
 
 Supported are XML-RPC data types described [here](http://en.wikipedia.org/wiki/XML-RPC#Data_types)
 */

@interface DTXMLRPCSerialization : NSObject

/**
 Serializes an XML-RPC message into an `NSData` instance
 @param message The message to serialize
 @returns The serialized data
 */
+ (NSData *)dataWithXMLRPCMessage:(DTXMLRPCMessage *)message;

/**
 Deserializes an XML-RPC messages from data
 @param data The XML-RPC `NSData` to deserialize
 @returns The deserialized message
 */
+ (DTXMLRPCMessage *)XMLRPCMethodWithData:(NSData *)data;

@end
