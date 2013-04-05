//
//  NSArray+DTXMLRPC.h
//  WordpressDemo
//
//  Created by Oliver Drobnik on 22.03.13.
//  Copyright (c) 2013 Drobnik KG. All rights reserved.
//

/**
 Category on `NSArray` used for naming it and setting a reference to its parent
 */

@interface NSArray (DTXMLRPC)

/**
 The XML-RPC sequence name of the receiver
 */
@property (nonatomic, strong) NSString *DTXMLRPCName;

/**
 The parent of the receiver
 */
@property (nonatomic, unsafe_unretained) NSArray *DTXMLRPCParent;

@end
