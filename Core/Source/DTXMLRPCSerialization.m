//
//  DTXMLRPCSerialization.m
//  WordpressDemo
//
//  Created by Oliver Drobnik on 22.03.13.
//  Copyright (c) 2013 Drobnik KG. All rights reserved.
//

#import "DTXMLRPC.h"
#import "NSArray+DTXMLRPC.h"
#import "DTBase64Coding.h"


static NSDictionary *entityReverseLookup = nil;

@interface DTXMLRPCSerializationDecoder : NSObject <NSXMLParserDelegate>

- (id)initWithData:(NSData *)data;
- (id)decodedObject;

@end

@implementation DTXMLRPCSerialization

+ (NSString *)_stringByAddingHTMLEntitiesToString:(NSString *)string
{
    static dispatch_once_t predicate;
    
    dispatch_once(&predicate, ^{
        entityReverseLookup = [[NSDictionary alloc] initWithObjectsAndKeys:@"&quot;", [NSNumber numberWithInteger:0x22],
                               @"&amp;", [NSNumber numberWithInteger:0x26],
                               @"&apos;", [NSNumber numberWithInteger:0x27],
                               @"&lt;", [NSNumber numberWithInteger:0x3c],
                               @"&gt;", [NSNumber numberWithInteger:0x3e],
                               @"&nbsp;", [NSNumber numberWithInteger:0x00a0],
                               @"&iexcl;", [NSNumber numberWithInteger:0x00a1],
                               @"&cent;", [NSNumber numberWithInteger:0x00a2],
                               @"&pound;", [NSNumber numberWithInteger:0x00a3],
                               @"&curren;", [NSNumber numberWithInteger:0x00a4],
                               @"&yen;", [NSNumber numberWithInteger:0x00a5],
                               @"&brvbar;", [NSNumber numberWithInteger:0x00a6],
                               @"&sect;", [NSNumber numberWithInteger:0x00a7],
                               @"&uml;", [NSNumber numberWithInteger:0x00a8],
                               @"&copy;", [NSNumber numberWithInteger:0x00a9],
                               @"&ordf;", [NSNumber numberWithInteger:0x00aa],
                               @"&laquo;", [NSNumber numberWithInteger:0x00ab],
                               @"&not;", [NSNumber numberWithInteger:0x00ac],
                               @"&reg;", [NSNumber numberWithInteger:0x00ae],
                               @"&macr;", [NSNumber numberWithInteger:0x00af],
                               @"&deg;", [NSNumber numberWithInteger:0x00b0],
                               @"&plusmn;", [NSNumber numberWithInteger:0x00b1],
                               @"&sup2;", [NSNumber numberWithInteger:0x00b2],
                               @"&sup3;", [NSNumber numberWithInteger:0x00b3],
                               @"&acute;", [NSNumber numberWithInteger:0x00b4],
                               @"&micro;", [NSNumber numberWithInteger:0x00b5],
                               @"&para;", [NSNumber numberWithInteger:0x00b6],
                               @"&middot;", [NSNumber numberWithInteger:0x00b7],
                               @"&cedil;", [NSNumber numberWithInteger:0x00b8],
                               @"&sup1;", [NSNumber numberWithInteger:0x00b9],
                               @"&ordm;", [NSNumber numberWithInteger:0x00ba],
                               @"&raquo;", [NSNumber numberWithInteger:0x00bb],
                               @"&frac14;", [NSNumber numberWithInteger:0x00bc],
                               @"&frac12;", [NSNumber numberWithInteger:0x00bd],
                               @"&frac34;", [NSNumber numberWithInteger:0x00be],
                               @"&iquest;", [NSNumber numberWithInteger:0x00bf],
                               @"&Agrave;", [NSNumber numberWithInteger:0x00c0],
                               @"&Aacute;", [NSNumber numberWithInteger:0x00c1],
                               @"&Acirc;", [NSNumber numberWithInteger:0x00c2],
                               @"&Atilde;", [NSNumber numberWithInteger:0x00c3],
                               @"&Auml;", [NSNumber numberWithInteger:0x00c4],
                               @"&Aring;", [NSNumber numberWithInteger:0x00c5],
                               @"&AElig;", [NSNumber numberWithInteger:0x00c6],
                               @"&Ccedil;", [NSNumber numberWithInteger:0x00c7],
                               @"&Egrave;", [NSNumber numberWithInteger:0x00c8],
                               @"&Eacute;", [NSNumber numberWithInteger:0x00c9],
                               @"&Ecirc;", [NSNumber numberWithInteger:0x00ca],
                               @"&Euml;", [NSNumber numberWithInteger:0x00cb],
                               @"&Igrave;", [NSNumber numberWithInteger:0x00cc],
                               @"&Iacute;", [NSNumber numberWithInteger:0x00cd],
                               @"&Icirc;", [NSNumber numberWithInteger:0x00ce],
                               @"&Iuml;", [NSNumber numberWithInteger:0x00cf],
                               @"&ETH;", [NSNumber numberWithInteger:0x00d0],
                               @"&Ntilde;", [NSNumber numberWithInteger:0x00d1],
                               @"&Ograve;", [NSNumber numberWithInteger:0x00d2],
                               @"&Oacute;", [NSNumber numberWithInteger:0x00d3],
                               @"&Ocirc;", [NSNumber numberWithInteger:0x00d4],
                               @"&Otilde;", [NSNumber numberWithInteger:0x00d5],
                               @"&Ouml;", [NSNumber numberWithInteger:0x00d6],
                               @"&times;", [NSNumber numberWithInteger:0x00d7],
                               @"&Oslash;", [NSNumber numberWithInteger:0x00d8],
                               @"&Ugrave;", [NSNumber numberWithInteger:0x00d9],
                               @"&Uacute;", [NSNumber numberWithInteger:0x00da],
                               @"&Ucirc;", [NSNumber numberWithInteger:0x00db],
                               @"&Uuml;", [NSNumber numberWithInteger:0x00dc],
                               @"&Yacute;", [NSNumber numberWithInteger:0x00dd],
                               @"&THORN;", [NSNumber numberWithInteger:0x00de],
                               @"&szlig;", [NSNumber numberWithInteger:0x00df],
                               @"&agrave;", [NSNumber numberWithInteger:0x00e0],
                               @"&aacute;", [NSNumber numberWithInteger:0x00e1],
                               @"&acirc;", [NSNumber numberWithInteger:0x00e2],
                               @"&atilde;", [NSNumber numberWithInteger:0x00e3],
                               @"&auml;", [NSNumber numberWithInteger:0x00e4],
                               @"&aring;", [NSNumber numberWithInteger:0x00e5],
                               @"&aelig;", [NSNumber numberWithInteger:0x00e6],
                               @"&ccedil;", [NSNumber numberWithInteger:0x00e7],
                               @"&egrave;", [NSNumber numberWithInteger:0x00e8],
                               @"&eacute;", [NSNumber numberWithInteger:0x00e9],
                               @"&ecirc;", [NSNumber numberWithInteger:0x00ea],
                               @"&euml;", [NSNumber numberWithInteger:0x00eb],
                               @"&igrave;", [NSNumber numberWithInteger:0x00ec],
                               @"&iacute;", [NSNumber numberWithInteger:0x00ed],
                               @"&icirc;", [NSNumber numberWithInteger:0x00ee],
                               @"&iuml;", [NSNumber numberWithInteger:0x00ef],
                               @"&eth;", [NSNumber numberWithInteger:0x00f0],
                               @"&ntilde;", [NSNumber numberWithInteger:0x00f1],
                               @"&ograve;", [NSNumber numberWithInteger:0x00f2],
                               @"&oacute;", [NSNumber numberWithInteger:0x00f3],
                               @"&ocirc;", [NSNumber numberWithInteger:0x00f4],
                               @"&otilde;", [NSNumber numberWithInteger:0x00f5],
                               @"&ouml;", [NSNumber numberWithInteger:0x00f6],
                               @"&divide;", [NSNumber numberWithInteger:0x00f7],
                               @"&oslash;", [NSNumber numberWithInteger:0x00f8],
                               @"&ugrave;", [NSNumber numberWithInteger:0x00f9],
                               @"&uacute;", [NSNumber numberWithInteger:0x00fa],
                               @"&ucirc;", [NSNumber numberWithInteger:0x00fb],
                               @"&uuml;", [NSNumber numberWithInteger:0x00fc],
                               @"&yacute;", [NSNumber numberWithInteger:0x00fd],
                               @"&thorn;", [NSNumber numberWithInteger:0x00fe],
                               @"&yuml;", [NSNumber numberWithInteger:0x00ff],
                               @"&OElig;", [NSNumber numberWithInteger:0x0152],
                               @"&oelig;", [NSNumber numberWithInteger:0x0153],
                               @"&Scaron;", [NSNumber numberWithInteger:0x0160],
                               @"&scaron;", [NSNumber numberWithInteger:0x0161],
                               @"&Yuml;", [NSNumber numberWithInteger:0x0178],
                               @"&fnof;", [NSNumber numberWithInteger:0x0192],
                               @"&circ;", [NSNumber numberWithInteger:0x02c6],
                               @"&tilde;", [NSNumber numberWithInteger:0x02dc],
                               @"&Gamma;", [NSNumber numberWithInteger:0x0393],
                               @"&Delta;", [NSNumber numberWithInteger:0x0394],
                               @"&Theta;", [NSNumber numberWithInteger:0x0398],
                               @"&Lambda;", [NSNumber numberWithInteger:0x039b],
                               @"&Xi;", [NSNumber numberWithInteger:0x039e],
                               @"&Sigma;", [NSNumber numberWithInteger:0x03a3],
                               @"&Upsilon;", [NSNumber numberWithInteger:0x03a5],
                               @"&Phi;", [NSNumber numberWithInteger:0x03a6],
                               @"&Psi;", [NSNumber numberWithInteger:0x03a8],
                               @"&Omega;", [NSNumber numberWithInteger:0x03a9],
                               @"&alpha;", [NSNumber numberWithInteger:0x03b1],
                               @"&Alpha;", [NSNumber numberWithInteger:0x0391],
                               @"&beta;", [NSNumber numberWithInteger:0x03b2],
                               @"&Beta;", [NSNumber numberWithInteger:0x0392],
                               @"&gamma;", [NSNumber numberWithInteger:0x03b3],
                               @"&delta;", [NSNumber numberWithInteger:0x03b4],
                               @"&epsilon;", [NSNumber numberWithInteger:0x03b5],
                               @"&Epsilon;", [NSNumber numberWithInteger:0x0395],
                               @"&zeta;", [NSNumber numberWithInteger:0x03b6],
                               @"&Zeta;", [NSNumber numberWithInteger:0x0396],
                               @"&eta;", [NSNumber numberWithInteger:0x03b7],
                               @"&Eta;", [NSNumber numberWithInteger:0x0397],
                               @"&theta;", [NSNumber numberWithInteger:0x03b8],
                               @"&iota;", [NSNumber numberWithInteger:0x03b9],
                               @"&Iota;", [NSNumber numberWithInteger:0x0399],
                               @"&kappa;", [NSNumber numberWithInteger:0x03ba],
                               @"&Kappa;", [NSNumber numberWithInteger:0x039a],
                               @"&lambda;", [NSNumber numberWithInteger:0x03bb],
                               @"&mu;", [NSNumber numberWithInteger:0x03bc],
                               @"&Mu;", [NSNumber numberWithInteger:0x039c],
                               @"&nu;", [NSNumber numberWithInteger:0x03bd],
                               @"&Nu;", [NSNumber numberWithInteger:0x039d],
                               @"&xi;", [NSNumber numberWithInteger:0x03be],
                               @"&omicron;", [NSNumber numberWithInteger:0x03bf],
                               @"&Omicron;", [NSNumber numberWithInteger:0x039f],
                               @"&pi;", [NSNumber numberWithInteger:0x03c0],
                               @"&Pi;", [NSNumber numberWithInteger:0x03a0],
                               @"&rho;", [NSNumber numberWithInteger:0x03c1],
                               @"&Rho;", [NSNumber numberWithInteger:0x03a1],
                               @"&sigmaf;", [NSNumber numberWithInteger:0x03c2],
                               @"&sigma;", [NSNumber numberWithInteger:0x03c3],
                               @"&tau;", [NSNumber numberWithInteger:0x03c4],
                               @"&Tau;", [NSNumber numberWithInteger:0x03a4],
                               @"&upsilon;", [NSNumber numberWithInteger:0x03c5],
                               @"&phi;", [NSNumber numberWithInteger:0x03c6],
                               @"&chi;", [NSNumber numberWithInteger:0x03c7],
                               @"&Chi;", [NSNumber numberWithInteger:0x03a7],
                               @"&psi;", [NSNumber numberWithInteger:0x03c8],
                               @"&omega;", [NSNumber numberWithInteger:0x03c9],
                               @"&thetasym;", [NSNumber numberWithInteger:0x03d1],
                               @"&upsih;", [NSNumber numberWithInteger:0x03d2],
                               @"&piv;", [NSNumber numberWithInteger:0x03d6],
                               @"&ensp;", [NSNumber numberWithInteger:0x2002],
                               @"&emsp;", [NSNumber numberWithInteger:0x2003],
                               @"&thinsp;", [NSNumber numberWithInteger:0x2009],
                               @"&ndash;", [NSNumber numberWithInteger:0x2013],
                               @"&mdash;", [NSNumber numberWithInteger:0x2014],
                               @"&lsquo;", [NSNumber numberWithInteger:0x2018],
                               @"&rsquo;", [NSNumber numberWithInteger:0x2019],
                               @"&sbquo;", [NSNumber numberWithInteger:0x201a],
                               @"&ldquo;", [NSNumber numberWithInteger:0x201c],
                               @"&rdquo;", [NSNumber numberWithInteger:0x201d],
                               @"&bdquo;", [NSNumber numberWithInteger:0x201e],
                               @"&dagger;", [NSNumber numberWithInteger:0x2020],
                               @"&Dagger;", [NSNumber numberWithInteger:0x2021],
                               @"&bull;", [NSNumber numberWithInteger:0x2022],
                               @"&hellip;", [NSNumber numberWithInteger:0x2026],
                               @"&permil;", [NSNumber numberWithInteger:0x2030],
                               @"&prime;", [NSNumber numberWithInteger:0x2032],
                               @"&Prime;", [NSNumber numberWithInteger:0x2033],
                               @"&lsaquo;", [NSNumber numberWithInteger:0x2039],
                               @"&rsaquo;", [NSNumber numberWithInteger:0x203a],
                               @"&oline;", [NSNumber numberWithInteger:0x203e],
                               @"&frasl;", [NSNumber numberWithInteger:0x2044],
                               @"&euro;", [NSNumber numberWithInteger:0x20ac],
                               @"&image;", [NSNumber numberWithInteger:0x2111],
                               @"&weierp;", [NSNumber numberWithInteger:0x2118],
                               @"&real;", [NSNumber numberWithInteger:0x211c],
                               @"&trade;", [NSNumber numberWithInteger:0x2122],
                               @"&alefsym;", [NSNumber numberWithInteger:0x2135],
                               @"&larr;", [NSNumber numberWithInteger:0x2190],
                               @"&uarr;", [NSNumber numberWithInteger:0x2191],
                               @"&rarr;", [NSNumber numberWithInteger:0x2192],
                               @"&darr;", [NSNumber numberWithInteger:0x2193],
                               @"&harr;", [NSNumber numberWithInteger:0x2194],
                               @"&crarr;", [NSNumber numberWithInteger:0x21b5],
                               @"&lArr;", [NSNumber numberWithInteger:0x21d0],
                               @"&uArr;", [NSNumber numberWithInteger:0x21d1],
                               @"&rArr;", [NSNumber numberWithInteger:0x21d2],
                               @"&dArr;", [NSNumber numberWithInteger:0x21d3],
                               @"&hArr;", [NSNumber numberWithInteger:0x21d4],
                               @"&forall;", [NSNumber numberWithInteger:0x2200],
                               @"&part;", [NSNumber numberWithInteger:0x2202],
                               @"&exist;", [NSNumber numberWithInteger:0x2203],
                               @"&empty;", [NSNumber numberWithInteger:0x2205],
                               @"&nabla;", [NSNumber numberWithInteger:0x2207],
                               @"&isin;", [NSNumber numberWithInteger:0x2208],
                               @"&notin;", [NSNumber numberWithInteger:0x2209],
                               @"&ni;", [NSNumber numberWithInteger:0x220b],
                               @"&prod;", [NSNumber numberWithInteger:0x220f],
                               @"&sum;", [NSNumber numberWithInteger:0x2211],
                               @"&minus;", [NSNumber numberWithInteger:0x2212],
                               @"&lowast;", [NSNumber numberWithInteger:0x2217],
                               @"&radic;", [NSNumber numberWithInteger:0x221a],
                               @"&prop;", [NSNumber numberWithInteger:0x221d],
                               @"&infin;", [NSNumber numberWithInteger:0x221e],
                               @"&ang;", [NSNumber numberWithInteger:0x2220],
                               @"&and;", [NSNumber numberWithInteger:0x2227],
                               @"&or;", [NSNumber numberWithInteger:0x2228],
                               @"&cap;", [NSNumber numberWithInteger:0x2229],
                               @"&cup;", [NSNumber numberWithInteger:0x222a],
                               @"&int;", [NSNumber numberWithInteger:0x222b],
                               @"&there4;", [NSNumber numberWithInteger:0x2234],
                               @"&sim;", [NSNumber numberWithInteger:0x223c],
                               @"&cong;", [NSNumber numberWithInteger:0x2245],
                               @"&asymp;", [NSNumber numberWithInteger:0x2248],
                               @"&ne;", [NSNumber numberWithInteger:0x2260],
                               @"&equiv;", [NSNumber numberWithInteger:0x2261],
                               @"&le;", [NSNumber numberWithInteger:0x2264],
                               @"&ge;", [NSNumber numberWithInteger:0x2265],
                               @"&sub;", [NSNumber numberWithInteger:0x2282],
                               @"&sup;", [NSNumber numberWithInteger:0x2283],
                               @"&nsub;", [NSNumber numberWithInteger:0x2284],
                               @"&sube;", [NSNumber numberWithInteger:0x2286],
                               @"&supe;", [NSNumber numberWithInteger:0x2287],
                               @"&oplus;", [NSNumber numberWithInteger:0x2295],
                               @"&otimes;", [NSNumber numberWithInteger:0x2297],
                               @"&perp;", [NSNumber numberWithInteger:0x22a5],
                               @"&sdot;", [NSNumber numberWithInteger:0x22c5],
                               @"&lceil;", [NSNumber numberWithInteger:0x2308],
                               @"&rceil;", [NSNumber numberWithInteger:0x2309],
                               @"&lfloor;", [NSNumber numberWithInteger:0x230a],
                               @"&rfloor;", [NSNumber numberWithInteger:0x230b],
                               @"&lang;", [NSNumber numberWithInteger:0x27e8],
                               @"&rang;", [NSNumber numberWithInteger:0x27e9],
                               @"&loz;", [NSNumber numberWithInteger:0x25ca],
                               @"&spades;", [NSNumber numberWithInteger:0x2660],
                               @"&clubs;", [NSNumber numberWithInteger:0x2663],
                               @"&hearts;", [NSNumber numberWithInteger:0x2665],
                               @"&diams;", [NSNumber numberWithInteger:0x2666],
                               @"<br />", [NSNumber numberWithInteger:0x2028],
                               nil];
        
    });
    
    NSMutableString *tmpString = [NSMutableString string];
    
    for (NSUInteger i = 0; i<[string length]; i++)
    {
        unichar oneChar = [string characterAtIndex:i];
        
        NSNumber *subKey = [NSNumber numberWithInteger:oneChar];
        NSString *entity = [entityReverseLookup objectForKey:subKey];
        
        if (entity)
        {
            [tmpString appendString:entity];
        }
        else
        {
            if (oneChar<=255)
            {
                [tmpString appendFormat:@"%C", oneChar];
            }
            else if (CFStringIsSurrogateHighCharacter(oneChar) &&
                     i < [string length]-1)
            {
                i++;
                unichar surrogateLowChar = [string characterAtIndex:i];
                UTF32Char u32code = CFStringGetLongCharacterForSurrogatePair(oneChar, surrogateLowChar);
                [tmpString appendFormat:@"&#%lu;", (unsigned long)u32code];
            }
            else
            {
                
                [tmpString appendFormat:@"&#%d;", oneChar];
            }
        }
    }
    
    return tmpString;
}


+ (NSString *)_stringByEncodingValueOfObject:(id)object
{
    if ([object isKindOfClass:[NSString class]])
    {
        NSString *s = [self _stringByAddingHTMLEntitiesToString:object];
        
        return [NSString stringWithFormat:@"<string>%@</string>", s];
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
    else if ([object isKindOfClass:[NSData class]])
    {
        NSString *base64String = [DTBase64Coding stringByEncodingData:object];
        return [NSString stringWithFormat:@"<base64>%@</base64>", base64String];
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

- (NSNumber *)_numberFromDoubleSequence:(NSArray *)sequence
{
    if ([sequence count]!=1)
    {
        // illegal number of members
        return nil;
    }
    
    NSString *contents = [sequence objectAtIndex:0];
    
    double d = [contents doubleValue];
    
    return [NSNumber numberWithInteger:d];
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

- (NSData *)_dataFromBase64Sequence:(NSArray *)sequence
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

    return [DTBase64Coding dataByDecodingString:contents];
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
    
    // data types according to http://en.wikipedia.org/wiki/XML-RPC#Data_types
    
    if ([stuffName isEqualToString:@"array"])
    {
        return [self _arrayFromSequence:stuff];
    }
    else if ([stuffName isEqualToString:@"base64"])
    {
        return [self _dataFromBase64Sequence:stuff];
    }
    else if ([stuffName isEqualToString:@"boolean"])
    {
        return [self _numberFromBooleanSequence:stuff];
    }
    else if ([stuffName isEqualToString:@"dateTime.iso8601"])
    {
        return [self _dateFromDateTimeSequence:stuff];
    }
    else if ([stuffName isEqualToString:@"double"])
    {
        return [self _numberFromDoubleSequence:stuff];
    }
    else if ([stuffName isEqualToString:@"int"] || [stuffName isEqualToString:@"i4"])
    {
        return [self _numberFromIntegerSequence:stuff];
    }
    else if ([stuffName isEqualToString:@"string"])
    {
        return [self _stringFromStringSequence:stuff];
    }
    else if ([stuffName isEqualToString:@"struct"])
    {
        return [self _dictionaryFromSequence:stuff];
    }
    else if ([stuffName isEqualToString:@"nil"])
    {
        return [NSNull null];
    }
    else
    {
        NSLog(@"Unable to decode object of type '%@'", stuffName);
    }
    
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


