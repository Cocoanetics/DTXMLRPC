//
//  DTXMLRPCSerialization.m
//  WordpressDemo
//
//  Created by Oliver Drobnik on 22.03.13.
//  Copyright (c) 2013 Drobnik KG. All rights reserved.
//

#import "DTXMLRPC.h"
#import "NSArray+DTXMLRPC.h"

@interface DTXMLRPCSerializationDecoder : NSObject <NSXMLParserDelegate>

- (id)initWithData:(NSData *)data;
- (id)decodedObject;

@end

@implementation DTXMLRPCSerialization

+ (NSString *)_stringByEncodingValueOfObject:(id)object
{
    if ([object isKindOfClass:[NSString class]])
    {
        return [NSString stringWithFormat:@"<string>%@</string>", object];
    }
    else if ([object isKindOfClass:[NSNumber class]])
    {
        return [NSString stringWithFormat:@"<int>%@</int>", [object description]];
    }
    else if ([object isKindOfClass:[NSDictionary class]])
    {
        NSMutableString *tmpString = [NSMutableString string];
        
        [tmpString appendString:@"<struct>"];
        
        for (NSString *oneKey in object)
        {
            id value = [object objectForKey:oneKey];
            
            [tmpString appendString:@"<member>"];
            [tmpString appendFormat:@"<name>%@</name><value>", oneKey];
            
            [tmpString appendString:[DTXMLRPCSerialization _stringByEncodingValueOfObject:value]];
            
            [tmpString appendString:@"</value></member>"];
            
        }
        
        [tmpString appendString:@"</struct>"];
        
        return [tmpString copy];
    }
    else
    {
        NSLog(@"Implement class %@", NSStringFromClass([object class]));
    }
    
    return nil;
}


+ (NSData *)dataWithXMLRPCMethod:(DTXMLRPCMessage *)object
{
    NSParameterAssert(object);
    
    NSString *rootNameName = [object rootNodeName];
    
    NSAssert(rootNameName, @"root node name needs to be set for dataRepresentation");
    
    NSMutableString *tmpString = [NSMutableString string];
    
    [tmpString appendFormat:@"<%@>\n", rootNameName];
    
    // add the method name if this object has one
    if ([object respondsToSelector:@selector(methodName)])
    {
        NSString *methodName = [object valueForKey:@"methodName"];
        
        if (methodName)
        {
            [tmpString appendFormat:@"   <methodName>%@</methodName>\n", methodName];
        }
    }
    
    if ([object.parameters count])
    {
        [tmpString appendString:@"   <params>\n"];
        
        for (id oneParam in object.parameters)
        {
            [tmpString appendString:@"      <param>\n"];
            [tmpString appendString:@"         <value>"];
            
            [tmpString appendString:[DTXMLRPCSerialization _stringByEncodingValueOfObject:oneParam]];

            [tmpString appendString:@"</value>\n"];
            [tmpString appendString:@"      </param>\n"];
        }
        
        [tmpString appendString:@"   </params>\n"];
    }
    
    [tmpString appendString:@"</methodCall>\n"];
    
    
    return [tmpString dataUsingEncoding:NSUTF8StringEncoding];
}

+ (id)XMLRPCMethodWithData:(NSData *)data
{
    NSParameterAssert(data);
    
    DTXMLRPCSerializationDecoder *decoder = [[DTXMLRPCSerializationDecoder alloc] initWithData:data];
    return [decoder decodedObject];
}

@end

@implementation DTXMLRPCSerializationDecoder
{
    NSData *_data;
    id _decodedObject;
    
    // parsing state
    id _currentObject;
    
    NSString *_currentElementName;
    NSString *_currentElementContents;
}

- (id)initWithData:(NSData *)data
{
    self = [super init];
    
    if (self)
    {
        NSXMLParser *parser = [[NSXMLParser alloc] initWithData:data];
        parser.delegate = self;
        
        if (![parser parse])
        {
            return nil;
        }
        
        // at this point the object is available
    }
    
    return self;
}

- (id)decodedObject
{
    NSArray *rootObject = _decodedObject;
    
    // get class from sequence name
    
    Class class = nil;
    
    if ([rootObject.DTXMLRPCName isEqualToString:@"methodResponse"])
    {
        class = [DTXMLRPCResponse class];
    }
    
    id decodedObject = [[class alloc] initWithXMLRPCSequence:rootObject];
    
    return decodedObject;
}

#pragma mark - NSXMLParser Delegate

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    // every tag is a new DTXMLRPC Sequence
    
    NSMutableArray *sequence = [NSMutableArray array];
    sequence.DTXMLRPCName = elementName;
    
    if (_currentObject)
    {
        sequence.DTXMLRPCParent = _currentObject;
        [_currentObject addObject:sequence];
    }
    else
    {
        _decodedObject = sequence;
    }
    
    _currentObject = sequence;
}


- (NSError *)_decodeErrorFromFaultSequence:(NSArray *)sequence
{
    if (![sequence isKindOfClass:[NSArray class]])
    {
        // not a sequence
        return nil;
    }
    
    if ([sequence count]!=1)
    {
        // illegal number of members
        return nil;
    }
    
    id valueSequence = [sequence objectAtIndex:0];
    
    if ([valueSequence count]!=1)
    {
        // illegal number of members
        return nil;
    }
    
    NSDictionary *dict = [self _objectFromValueSequence:valueSequence];
    
    if (!dict)
    {
        return nil;
    }
    
    NSInteger faultCode = [[dict objectForKey:@"faultCode"] integerValue];
    NSString *faultString = [dict objectForKey:@"faultString"];
    
    NSMutableDictionary *userInfo = nil;
    
    if (faultString)
    {
        userInfo = [NSDictionary dictionaryWithObject:faultString forKey:NSLocalizedDescriptionKey];
    }
    
    return [NSError errorWithDomain:NSStringFromClass([self class]) code:faultCode userInfo:userInfo];
}

- (NSDictionary *)_dictionaryFromSequence:(NSArray *)sequence
{
    if (![sequence isKindOfClass:[NSArray class]])
    {
        // not a sequence
        return nil;
    }
    
    NSMutableDictionary *tmpDictionary = [NSMutableDictionary dictionary];
    
    
    for (NSArray *memberSequence in sequence)
    {
        if (![[memberSequence DTXMLRPCName] isEqualToString:@"member"])
        {
            // illegal sequence name
            continue;
        }
        
        if ([memberSequence count]!=2)
        {
            // illegal number of members
            continue;
        }
        
        id nameSequence = [memberSequence objectAtIndex:0];
        
        if ([nameSequence count]!=1)
        {
            // illegal number of members
            continue;
        }
        
        if (![[nameSequence DTXMLRPCName] isEqualToString:@"name"])
        {
            // illegal sequence name
            continue;
        }
        
        NSString *name = [nameSequence objectAtIndex:0];
        
        if (![name isKindOfClass:[NSString class]])
        {
            // illegal name class
            continue;
        }
        
        if (![name length])
        {
            // key cannot be empty
            continue;
        }
        
        id valueSequence = [memberSequence objectAtIndex:1];
        
        id valueObject = [self _objectFromValueSequence:valueSequence];
        
        if (valueObject)
        {
            [tmpDictionary setObject:valueObject forKey:name];
        }
    }
    
    return [tmpDictionary copy];
}

- (NSArray *)_arrayFromSequence:(NSArray *)sequence
{
    if (![sequence isKindOfClass:[NSArray class]])
    {
        // not a sequence
        return nil;
    }
    
    if ([sequence count]!=1)
    {
        // illegal number of members
        return nil;
    }
    
    NSArray *dataSequence = [sequence objectAtIndex:0];
    
    NSMutableArray *tmpArray = [NSMutableArray array];
    
    for (id value in dataSequence)
    {
        id object = [self _objectFromValueSequence:value];
        
        if (object)
        {
            [tmpArray addObject:object];
        }
    }
    
    return [tmpArray copy];
}

- (NSNumber *)_numberFromBooleanSequence:(NSArray *)sequence
{
    if ([sequence count]!=1)
    {
        // illegal number of members
        return nil;
    }
    
    NSString *contents = [sequence objectAtIndex:0];
    
    BOOL b = [contents boolValue];
    
    return [NSNumber numberWithBool:b];
}

- (NSNumber *)_numberFromIntegerSequence:(NSArray *)sequence
{
    if ([sequence count]!=1)
    {
        // illegal number of members
        return nil;
    }
    
    NSString *contents = [sequence objectAtIndex:0];
    
    NSInteger i = [contents integerValue];
    
    return [NSNumber numberWithInteger:i];
}

- (NSString *)_stringFromStringSequence:(NSArray *)sequence
{
    if ([sequence count]!=1)
    {
        // illegal number of members
        return nil;
    }
    
    NSString *contents = [sequence objectAtIndex:0];
    
    if (![contents isKindOfClass:[NSString class]])
    {
        return nil;
    }
    
    return contents;
}

- (NSDate *)_dateFromDateTimeSequence:(NSArray *)sequence
{
    if ([sequence count]!=1)
    {
        // illegal number of members
        return nil;
    }
    
    NSString *contents = [sequence objectAtIndex:0];
    
    if (![contents isKindOfClass:[NSString class]])
    {
        return nil;
    }
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm"];
    return [dateFormatter dateFromString:contents];
}

// a sequence named value
- (id)_objectFromValueSequence:(NSArray *)sequence
{
    if (![[sequence DTXMLRPCName] isEqualToString:@"value"])
    {
        // illegal sequence name
        return nil;
    }
    
    if ([sequence count]!=1)
    {
        // illegal number of members
        return nil;
    }
    
    id stuff = sequence[0];
    
    NSString *stuffName = [stuff DTXMLRPCName];
    
    if ([stuffName isEqualToString:@"array"])
    {
        return [self _arrayFromSequence:stuff];
    }
    else if ([stuffName isEqualToString:@"struct"])
    {
        return [self _dictionaryFromSequence:stuff];
    }
    else if ([stuffName isEqualToString:@"boolean"])
    {
        return [self _numberFromBooleanSequence:stuff];
    }
    else if ([stuffName isEqualToString:@"string"])
    {
        return [self _stringFromStringSequence:stuff];
    }
    else if ([stuffName isEqualToString:@"int"] || [stuffName isEqualToString:@"i4"])
    {
        return [self _numberFromIntegerSequence:stuff];
    }
    else if ([stuffName isEqualToString:@"dateTime.iso8601"])
    {
        return [self _dateFromDateTimeSequence:stuff];
    }
    else NSLog(@"%@", stuffName);
    
    return nil;
}

- (NSArray *)_decodeParamSequence:(NSArray *)sequence
{
    if (![sequence isKindOfClass:[NSArray class]])
    {
        // not a sequence
        return nil;
    }
    
    if (![[sequence DTXMLRPCName] isEqualToString:@"params"])
    {
        // incorrect sequence name
        return nil;
    }
    
    NSMutableArray *tmpArray = [NSMutableArray array];
    
    for (NSArray *paramSequence in sequence)
    {
        if (![paramSequence isKindOfClass:[NSArray class]])
        {
            // not a sequence
            return nil;
        }
        
        if (![[paramSequence DTXMLRPCName] isEqualToString:@"param"])
        {
            // incorrect sequence name
            return nil;
        }
        
        if ([paramSequence count]!=1)
        {
            // illegal number of members
            return nil;
        }
        
        id valueSequence = [paramSequence objectAtIndex:0];
        
        id value = [self _objectFromValueSequence:valueSequence];
        
        if (value)
        {
            [tmpArray addObject:value];
        }
    }
    
    NSArray *retArray = [tmpArray copy];
    
    // tag it as params array
    [retArray setDTXMLRPCName:@"params"];
    
    return retArray;
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    id nextObject = [_currentObject DTXMLRPCParent];
    
    if ([elementName isEqualToString:@"params"])
    {
        NSArray *decodedParams = [self _decodeParamSequence:_currentObject];
        
        
        if (decodedParams)
        {
            // replace the current object with the decoded thing
            NSUInteger index = [nextObject indexOfObject:_currentObject];
            [nextObject replaceObjectAtIndex:index withObject:decodedParams];
        }
        else
        {
            NSLog(@"Unable to decode param sequence %@", _currentObject);
        }
    }
    else if ([elementName isEqualToString:@"fault"])
    {
        NSError *decodedError = [self _decodeErrorFromFaultSequence:_currentObject];
        
        if (decodedError)
        {
            // replace the current object with the decoded thing
            NSUInteger index = [nextObject indexOfObject:_currentObject];
            [nextObject replaceObjectAtIndex:index withObject:decodedError];
        }
        else
        {
            NSLog(@"Unable to decode error sequence %@", _currentObject);
        }
    }
    
    _currentObject = nextObject;
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    if (![[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length])
    {
        return;
    }
    
    [_currentObject addObject:string];
}


@end


