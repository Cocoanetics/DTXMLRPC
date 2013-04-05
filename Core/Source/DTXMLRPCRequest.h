//
//  DTXMLRPCFunction.h
//  WordpressDemo
//
//  Created by Oliver Drobnik on 22.03.13.
//  Copyright (c) 2013 Drobnik KG. All rights reserved.
//

#import "DTXMLRPCMessage.h"

/**
 An XML-RPC request
 */

@interface DTXMLRPCRequest : DTXMLRPCMessage

/**
 @name Creating Requests
 */

/**
 Creates a new XML-RPC request with a function name.
 @param methodName The function name of the XML-RPC function to call.
 @param parameters A dictionary of parameters for the function
 */
- (id)initWithMethodName:(NSString *)methodName parameters:(NSArray *)parameters;

/**
 @name Getting Information
 */

/**
 Retrieves the method name of the request
 */
@property (nonatomic, strong) NSString *methodName;

@end
