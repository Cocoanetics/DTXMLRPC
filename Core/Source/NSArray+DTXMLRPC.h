//
//  NSArray+DTXMLRPC.h
//  WordpressDemo
//
//  Created by Oliver Drobnik on 22.03.13.
//  Copyright (c) 2013 Drobnik KG. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (DTXMLRPC)

@property (nonatomic, strong) NSString *DTXMLRPCName;
@property (nonatomic, unsafe_unretained) NSArray *DTXMLRPCParent;

@end
