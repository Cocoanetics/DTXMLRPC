//
//  DTXMLRPCObject.h
//  WordpressDemo
//
//  Created by Oliver Drobnik on 22.03.13.
//  Copyright (c) 2013 Drobnik KG. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 Common ancestor of all XML-RPC messages.
 */

@interface DTXMLRPCMessage : NSObject

/**
 Creates an XML-RPC object with parameters
 @param parameters The parameters
 */
- (id)initWithParameters:(NSArray *)parameters;

/**
 The name of the root node when receiver is being encoded/decoded
 */
- (NSString *)rootNodeName;

/**
 The deserialized parameters of the receiver
 */
@property (nonatomic, strong, readonly) NSArray *parameters;

@end
