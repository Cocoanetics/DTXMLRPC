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
 Methods to serialize and deserialize XML-RPC objects, e.g. method calls and responses.
 */

@interface DTXMLRPCSerialization : NSObject

+ (NSData *)dataWithXMLRPCMethod:(id)object;

/**
 Deserializes an XML-RPC object from data
 @param data The XML-RPC `NSData` to deserialize
 @returns The deserialized object
 */
+ (DTXMLRPCMessage *)XMLRPCMethodWithData:(NSData *)data;

@end
