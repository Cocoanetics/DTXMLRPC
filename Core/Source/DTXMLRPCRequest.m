//
//  DTXMLRPCFunction.m
//  WordpressDemo
//
//  Created by Oliver Drobnik on 22.03.13.
//  Copyright (c) 2013 Drobnik KG. All rights reserved.
//

#import "DTXMLRPC.h"

@implementation DTXMLRPCRequest
{
    NSString *_methodName;
}

- (id)initWithMethodName:(NSString *)methodName parameters:(NSArray *)parameters
{
    self = [super initWithParameters:parameters];
    
    if (self)
    {
        _methodName = [methodName copy];
    }
    
    return self;
}

- (NSString *)rootNodeName
{
    return @"methodCall";
}

#pragma mark - Properties

@synthesize methodName = _methodName;

@end
