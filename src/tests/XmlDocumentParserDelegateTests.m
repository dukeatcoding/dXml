//
//  XmlParserDelegateTests.m
//  dXml
//
//  Created by Derek Clarkson on 22/11/09.
//  Copyright 2009 Derek Clarkson. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "DCXmlDocumentParserDelegate.h"
#import "DCXmlNamespace.h"
#import "GHUnit.h"
#import "dXml.h"

@interface XmlDocumentParserDelegateTests : GHTestCase {
	@private
}

@end

@implementation XmlDocumentParserDelegateTests

- (void) testDidStartElementCreatesDocument {
	DCXmlDocumentParserDelegate *delegate = [[[DCXmlDocumentParserDelegate alloc]init]autorelease];
	[delegate parser: nil didStartElement: @"elementname" namespaceURI: @"namespace" qualifiedName: @"qualifiedname" attributes: nil];
	[delegate parser: nil didEndElement: @"elementname" namespaceURI: @"namespace" qualifiedName: @"qualifiedname"];

	DCXmlDocument *document = [delegate document];

	GHAssertNotNil(document, @"document not returned.");
	GHAssertTrue([document isKindOfClass:[DCXmlDocument class]], @"Not an XmlDocument returned" );
	GHAssertEqualStrings([document name], @"elementname", @"Document name not what was expected.");
}

@end