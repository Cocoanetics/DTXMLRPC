//
//  DTXMLRPCService.m
//  WordpressDemo
//
//  Created by Oliver Drobnik on 22.03.13.
//  Copyright (c) 2013 Drobnik KG. All rights reserved.
//

#import "DTXMLRPC.h"

@implementation DTXMLRPCService
{
    NSURL *_endpointURL;
}


- (id)initWithEndpointURL:(NSURL *)endpointURL
{
    self = [super init];
    
    if (self)
    {
        _endpointURL = [endpointURL copy];
    }
    
    return self;
}



#pragma mark - Sending Requests

- (void)sendRequest:(DTXMLRPCRequest *)request completion:(DTXMLRPCRequestCompletionHandler)completion
{
    NSAssert(_endpointURL, @"Cannot send request without enpoint URL");
    
    NSMutableURLRequest *URLRequest = [NSMutableURLRequest requestWithURL:_endpointURL];
    URLRequest.HTTPMethod = @"POST";
    [URLRequest addValue:@"text/xml" forHTTPHeaderField:@"Content-Type"];
    
    NSData *bodyData = [DTXMLRPCSerialization dataWithXMLRPCMethod:request];
    [URLRequest setHTTPBody:bodyData];
    
    [NSURLConnection sendAsynchronousRequest:URLRequest queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *URLResponse, NSData *data, NSError *error) {
        
        if (completion)
        {
            if (error)
            {
                // package this error into an XMLRPC message
                id message = [[DTXMLRPCResponse alloc] initWithXMLRPCSequence:@[error]];
                
                completion(message);
            }
            else
            {
                id message = [DTXMLRPCSerialization XMLRPCMethodWithData:data];
                
                if (!message)
                {
                    NSLog(@"Unable to parse response from %@", [_endpointURL absoluteString]);
                }
                
                completion(message);
            }
        }
    }];
}


@end
