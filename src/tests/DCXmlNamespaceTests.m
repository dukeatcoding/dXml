//
//  XmlNamespaceTests.m
//  dXml
//
//  Created by Derek Clarkson on 14/12/09.
//  Copyright 2009 Derek Clarkson. All rights reserved.
//

#import "GHUnit.h"
#import "DCXmlNamespace.h"

@interface DCXmlNamespaceTests : GHTestCase
{
}

@end


@implementation DCXmlNamespaceTests

-(void) testConstructor {
	DCXmlNamespace * namespace = [[[DCXmlNamespace alloc] initWithUrl:@"url" prefix:@"prefix"] autorelease];
	GHAssertEqualStrings(namespace.url, @"url", @"Url not returned");
	GHAssertEqualStrings(namespace.prefix, @"prefix", @"prefix not returned");
}

-(void) testAppendToString {
	DCXmlNamespace * namespace = [[[DCXmlNamespace alloc] initWithUrl:@"url" prefix:@"prefix"] autorelease];
	NSMutableString * xml = [[[NSMutableString alloc] init] autorelease];
	[namespace appendToXmlString:xml];
	GHAssertEqualStrings(xml, @" xmlns:prefix=\"url\"", @"Namespace not appended corectly");
}

@end
