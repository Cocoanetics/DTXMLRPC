//
//  NSArray+DTXMLRPC.m
//  WordpressDemo
//
//  Created by Oliver Drobnik on 22.03.13.
//  Copyright (c) 2013 Drobnik KG. All rights reserved.
//

#import "NSArray+DTXMLRPC.h"
#import <objc/runtime.h>

const char DTXMLRPCNameKey;
const char DTXMLRPCParentKey;

@implementation NSArray (DTXMLRPC)

- (void)setDTXMLRPCName:(NSString *)DTXMLRPCName
{
    objc_setAssociatedObject(self, &DTXMLRPCNameKey, DTXMLRPCName, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSString *)DTXMLRPCName
{
    return objc_getAssociatedObject(self, &DTXMLRPCNameKey);
}

- (void)setDTXMLRPCParent:(NSArray *)DTXMLRPCParent
{
    objc_setAssociatedObject(self, &DTXMLRPCParentKey, DTXMLRPCParent, OBJC_ASSOCIATION_ASSIGN);
}

- (NSArray *)DTXMLRPCParent
{
    return objc_getAssociatedObject(self, &DTXMLRPCParentKey);
}

@end
