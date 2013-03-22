//
//  DTXMLRPCResponse.m
//  WordpressDemo
//
//  Created by Oliver Drobnik on 22.03.13.
//  Copyright (c) 2013 Drobnik KG. All rights reserved.
//

#import "DTXMLRPC.h"

@implementation DTXMLRPCResponse
{
    NSError *_error;
}

- (id)initWithXMLRPCSequence:(NSArray *)sequence
{
    NSArray *params = nil;
    NSError *error = nil;
    
    // pick apart the sequence stuff
    for (NSArray *oneElement in sequence)
    {
        if ([oneElement isKindOfClass:[NSArray class]])
        {
            NSString *sequenceName = [oneElement DTXMLRPCName];
            
            if ([sequenceName isEqualToString:@"params"])
            {
                params = [oneElement copy];
            }
        }
        else if ([oneElement isKindOfClass:[NSError class]])
        {
            error = (NSError *)oneElement;
        }
        else
        {
            NSLog(@"Unexpected element of class %@ at root of %@", NSStringFromClass([oneElement class]), NSStringFromClass([self class]));
            return nil;
        }
    }
    
    self = [super initWithParameters:params];
    
    if (self)
    {
        _error = error;
    }
    
    return self;
}

- (NSString *)rootNodeName
{
    return @"methodResponse";
}

@end
