//
//  DTXMLRPCObject.m
//  WordpressDemo
//
//  Created by Oliver Drobnik on 22.03.13.
//  Copyright (c) 2013 Drobnik KG. All rights reserved.
//

#import "DTXMLRPCMessage.h"

@interface DTXMLRPCMessage () // private

@property (nonatomic, strong, readwrite) NSArray *parameters;

@end


@implementation DTXMLRPCMessage
{
    NSArray *_parameters;
}


- (id)initWithParameters:(NSArray *)parameters
{
    self = [super init];
    
    if (self)
    {
        _parameters = [parameters copy];
    }
    
    return self;
}

- (NSString *)rootNodeName
{
    return nil;
}

#pragma mark - Properties

@synthesize parameters = _parameters;

@end



