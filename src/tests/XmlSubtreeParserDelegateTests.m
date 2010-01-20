//
//  XmlParserDelegateTests.m
//  dXml
//
//  Created by Derek Clarkson on 22/11/09.
//  Copyright 2009 Derek Clarkson. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "DCXmlSubtreeParserDelegate.h"
#import "DCXmlNamespace.h"
#import "GHUnit.h"
#import "dXml.h"
#import "DCTextNode.h"

@interface XmlSubtreeParserDelegateTests : GHTestCase {
	@private
	DCXmlSubtreeParserDelegate *delegate;
}

@end

@implementation XmlSubtreeParserDelegateTests

- (void) setUp {
	delegate = [[DCXmlSubtreeParserDelegate alloc] init];
}

- (void) tearDown {
	if (delegate != nil) {
		[delegate release];
		delegate = nil;
	}
}

- (void) testDidStartElementCreatesElement {
	[delegate parser: nil didStartElement: @"elementname" namespaceURI: @"namespace" qualifiedName: @"qualifiedname" attributes: nil];
	[delegate parser: nil didEndElement: @"elementname" namespaceURI: @"namespace" qualifiedName: @"qualifiedname"];

	DCXmlNode *element= [delegate rootNode];

	GHAssertNotNil(element, @"element not returned.");
	GHAssertEqualStrings([element name], @"elementname", @"Document name not what was expected.");
}

- (void) testDidStartElementCreatesSubElement {
	[delegate parser: nil didStartElement: @"elementname" namespaceURI: @"namespace" qualifiedName: @"qualifiedname" attributes: nil];
	[delegate parser: nil didStartElement: @"subelementname" namespaceURI: nil qualifiedName: nil attributes: nil];
	[delegate parser: nil didEndElement: @"subelementname" namespaceURI: nil qualifiedName: nil];
	[delegate parser: nil didEndElement: @"elementname" namespaceURI: @"namespace" qualifiedName: @"qualifiedname"];

	DCXmlNode *element  = [delegate rootNode];

	GHAssertNotNil(element, @"element not returned.");
	GHAssertEqualStrings([element name], @"elementname", @"Document name not what was expected.");
	DCXmlNode *subelement = [element xmlNodeWithName: @"subelementname"];
	GHAssertNotNil(subelement, @"Subelement not returned.");
	GHAssertEqualStrings([subelement name], @"subelementname", @"Sub element name not what was expected.");
}

- (void) testDidStartMappingPrefixAddsNamespace {
	[delegate parser: nil didStartMappingPrefix: @"prefix" toURI: @"uri"];
	[delegate parser: nil didStartElement: @"elementname" namespaceURI: @"uri" qualifiedName: @"prefix:elementname" attributes: nil];
	[delegate parser: nil didEndElement: @"elementname" namespaceURI: @"uri" qualifiedName: @"prefix:elementname"];

	DCXmlNode *element = [delegate rootNode];
	for (DCXmlNamespace *namespace in[element namespaces]) {
		if ([@"prefix" isEqualToString:namespace.prefix] &&[@"uri" isEqualToString:namespace.url]) {
			//success.
			return;
		}
	}
	GHFail(@"Namespace not found.");
}

- (void) testDidStartMappingPrefixAddsDefaultNamespace {
	[delegate parser: nil didStartMappingPrefix: @"" toURI: @"uri"];
	[delegate parser: nil didStartElement: @"elementname" namespaceURI: @"uri" qualifiedName: @"elementname" attributes: nil];
	[delegate parser: nil didEndElement: @"elementname" namespaceURI: @"uri" qualifiedName: @"elementname"];

	GHAssertEqualStrings([delegate rootNode].defaultSchema, @"uri", @"Root schema not set");
	int namespaces = [[delegate rootNode].namespaces count];
	GHAssertEquals(namespaces, 0, @"Expected no namespaces.");
}

- (void) testDidStartMappingPrefixWhenChangingToDefaultNamespace {
	[delegate parser: nil didStartMappingPrefix: @"" toURI: @""];
	[delegate parser: nil didStartElement: @"elementname" namespaceURI: @"" qualifiedName: @"elementname" attributes: nil];
	[delegate parser: nil didEndElement: @"elementname" namespaceURI: @"" qualifiedName: @"elementname"];

	GHAssertNil([delegate rootNode].defaultSchema, @"Root schema should not be set");
	int namespaces = [[delegate rootNode].namespaces count];
	GHAssertEquals(namespaces, 0, @"Expected no namespaces.");
}

- (void) testFoundCharactersSetsValue {
	[delegate parser: nil didStartElement: @"elementname" namespaceURI: nil qualifiedName: nil attributes: nil];
	[delegate parser: nil foundCharacters: @"abc"];
	[delegate parser: nil didEndElement: @"elementname" namespaceURI: nil qualifiedName: nil];

	DCXmlNode *element = [delegate rootNode];

	GHAssertNotNil(element, @"element not returned.");
	GHAssertEqualStrings(element.value, @"abc", @"Value not returned correctly.");
}

- (void) testFoundCharactersConcatinatesIntoValue {
	[delegate parser: nil didStartElement: @"elementname" namespaceURI: nil qualifiedName: nil attributes: nil];
	[delegate parser: nil foundCharacters: @"abc"];
	[delegate parser: nil foundCharacters: @"def"];
	[delegate parser: nil foundCharacters: @"ghi"];
	[delegate parser: nil didEndElement: @"elementname" namespaceURI: nil qualifiedName: nil];

	DCXmlNode *element = [delegate rootNode];

	GHAssertNotNil(element, @"element not returned.");
	GHAssertEqualStrings(element.value, @"abc def ghi", @"Value not returned correctly.");
}

- (void) testMixedStringsAndElements {
	[delegate parser: nil didStartElement: @"root" namespaceURI: nil qualifiedName: nil attributes: nil];
	[delegate parser: nil foundCharacters: @"abc"];
	[delegate parser: nil didStartElement: @"element1" namespaceURI: nil qualifiedName: nil attributes: nil];
	[delegate parser: nil foundCharacters: @"def"];
	[delegate parser: nil didEndElement: @"element1" namespaceURI: nil qualifiedName: nil];
	[delegate parser: nil didStartElement: @"element2" namespaceURI: nil qualifiedName: nil attributes: nil];
	[delegate parser: nil foundCharacters: @"ghi"];
	[delegate parser: nil didEndElement: @"element2" namespaceURI: nil qualifiedName: nil];
	[delegate parser: nil foundCharacters: @"lmn"];
	[delegate parser: nil didEndElement: @"root" namespaceURI: nil qualifiedName: nil];

	DCXmlNode *element = [delegate rootNode];

	GHAssertNotNil(element, @"element not returned.");
	GHAssertEquals([element countNodes], 4, @"Incorrect number of nodes.");

	GHAssertTrue([[element nodeAtIndex:0] isKindOfClass:[DCTextNode class]], @"Incorrect class of node.");
	GHAssertEqualStrings(((DCTextNode *) [element nodeAtIndex:0]).value, @"abc", @"Value not correct");

	GHAssertTrue([[element nodeAtIndex:1] isKindOfClass:[DCXmlNode class]], @"Incorrect class of node.");
	GHAssertEqualStrings(((DCXmlNode *) [element nodeAtIndex:1]).name, @"element1", @"Value not correct");

	GHAssertTrue([[((DCXmlNode *)[element nodeAtIndex:1])nodeAtIndex:0] isKindOfClass:[DCTextNode class]], @"Incorrect class of node.");
	GHAssertEqualStrings(((DCXmlNode *) [((DCXmlNode *)[element nodeAtIndex:1])nodeAtIndex:0]).value, @"def", @"Value not correct");

	GHAssertTrue([[element nodeAtIndex:2] isKindOfClass:[DCXmlNode class]], @"Incorrect class of node.");
	GHAssertEqualStrings(((DCXmlNode *) [element nodeAtIndex:2]).name, @"element2", @"Value not correct");

	GHAssertTrue([[((DCXmlNode *)[element nodeAtIndex:2])nodeAtIndex:0] isKindOfClass:[DCTextNode class]], @"Incorrect class of node.");
	GHAssertEqualStrings(((DCXmlNode *) [((DCXmlNode *)[element nodeAtIndex:2])nodeAtIndex:0]).value, @"ghi", @"Value not correct");

	GHAssertTrue([[element nodeAtIndex:3] isKindOfClass:[DCTextNode class]], @"Incorrect class of node.");
	GHAssertEqualStrings(((DCTextNode *) [element nodeAtIndex:3]).value, @"lmn", @"Value not correct");

}

-(void) testParseErrorStored {
	NSError * error = [NSError errorWithDomain:@"abc" code:1 userInfo:nil];
	[delegate parser:nil parseErrorOccurred: error];
	GHAssertEqualObjects(delegate.error, error, @"Error not returned");
}

-(void) testValidationErrorStored {
	NSError * error = [NSError errorWithDomain:@"abc" code:1 userInfo:nil];
	[delegate parser:nil validationErrorOccurred: error];
	GHAssertEqualObjects(delegate.error, error, @"Error not returned");
}

@end