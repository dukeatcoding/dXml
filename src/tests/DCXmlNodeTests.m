//
//  DCXmlNodeTests.m
//  dXml
//
//  Created by Derek Clarkson on 25/10/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "GHUnit.h"
#import "DCXmlNode.h"
#import "DCXmlAttribute.h"
#import "DCXmlNamespace.h"
#import "DCXmlDocument.h"
#import "dXml.h"

const NSString * WEB_SERVICE_XML = @"<?xml version=\"1.0\" encoding=\"UTF-8\"?>"
											  @"<soap:envelope xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\""
											  @" soap:encodingStyle=\"http://schemas.xmlsoap.org/soap/encoding/\">"
											  @"<soap:body>"
											  @"<m:GetLastTradePrice xmlns:m=\"http://trading-site.com.au\">"
											  @"<symbol>MOT</symbol>"
											  @"</m:GetLastTradePrice>"
											  @"</soap:body>"
											  @"</soap:envelope>";
const NSString *PRETTY_WEB_SERVICE_XML = @"<?xml version=\"1.0\" encoding=\"UTF-8\"?>"
													  @"\n<soap:envelope xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\" soap:encodingStyle=\"http://schemas.xmlsoap.org/soap/encoding/\">"
													  @"\n\t<soap:body>"
													  @"\n\t\t<m:GetLastTradePrice xmlns:m=\"http://trading-site.com.au\">"
													  @"\n\t\t\t<symbol>MOT</symbol>"
													  @"\n\t\t</m:GetLastTradePrice>"
													  @"\n\t</soap:body>"
													  @"\n</soap:envelope>";

@interface DCXmlNodeTests : GHTestCase {
	@private
}
@end

@implementation DCXmlNodeTests

- (void) testInitWithName {
	DCXmlNode * testElement = [[[DCXmlNode alloc] initWithName: @"abc"] autorelease];
	GHAssertNotNil(testElement, @"Nil value returned when xml expected.");
	GHAssertEqualStrings(testElement.name, @"abc", @"Name not stored.");
}

- (void) testInitWithNameAndNamespacePrefix {
	DCXmlNode * testElement = [[[DCXmlNode alloc] initWithName: @"abc" prefix: @"x"] autorelease];
	GHAssertNotNil(testElement, @"Nil value returned when xml expected.");
	GHAssertEqualStrings(testElement.name, @"abc", @"name not stored.");
	GHAssertEqualStrings(testElement.prefix, @"x", @"prefix not stored.");
}

- (void) testCreateWithName {
	DCXmlNode * testElement = [DCXmlNode createWithName: @"abc"];
	GHAssertNotNil(testElement, @"Nil value returned when xml expected.");
	GHAssertEqualStrings(testElement.name, @"abc", @"Name not stored.");
}

- (void) testCreateWithNameAndPrefix {
	DCXmlNode * testElement = [DCXmlNode createWithName: @"abc" prefix:@"def"];
	GHAssertNotNil(testElement, @"Nil value returned when xml expected.");
	GHAssertEqualStrings(testElement.name, @"abc", @"Name not stored.");
	GHAssertEqualStrings(testElement.prefix, @"def", @"PRefix not set");
}

- (void) testCreateWithNameAndValue {
	DCXmlNode * testElement = [DCXmlNode createWithName: @"abc" value:@"ghi"];
	GHAssertNotNil(testElement, @"Nil value returned when xml expected.");
	GHAssertEqualStrings(testElement.name, @"abc", @"Name not stored.");
	GHAssertEqualStrings(testElement.value, @"ghi", @"Value not set");
}

- (void) testCreateWithNamePrefixAndValue {
	DCXmlNode * testElement = [DCXmlNode createWithName: @"abc" prefix:@"def" value:@"ghi"];
	GHAssertNotNil(testElement, @"Nil value returned when xml expected.");
	GHAssertEqualStrings(testElement.name, @"abc", @"Name not stored.");
	GHAssertEqualStrings(testElement.prefix, @"def", @"PRefix not set");
	GHAssertEqualStrings(testElement.value, @"ghi", @"Value not set");
}

- (void) testIsEqualToName {
	DCXmlNode * testElement = [[[DCXmlNode alloc] initWithName: @"abc"] autorelease];
	GHAssertTrue([testElement isEqualToName: @"abc"], @"Should have matched name.");
	GHAssertFalse([testElement isEqualToName: @"ABC"], @"Should not have matched name.");
}

- (void) testSubNodesAppendedAndRetrievedByKey {
	DCXmlNode * testElement = [[[DCXmlNode alloc] initWithName: @"abc"] autorelease];
	DCXmlNode *subElement1 = [[[DCXmlNode alloc] initWithName: @"def"] autorelease];
	DCXmlNode *subElement2 = [[[DCXmlNode alloc] initWithName: @"ghi"] autorelease];
	[testElement addNode: subElement1];
	[testElement addNode: subElement2];

	GHAssertEqualObjects([testElement xmlNodeWithName: @"def"], subElement1, @"SubElement1 not retrieved.");
	GHAssertEqualObjects([testElement xmlNodeWithName: @"ghi"], subElement2, @"SubElement2 not retrieved.");
}

- (void) testSubNodesRetrievedByIndex {
	DCXmlNode * testElement = [[[DCXmlNode alloc] initWithName: @"abc"] autorelease];
	DCXmlNode *subElement1 = [[[DCXmlNode alloc] initWithName: @"def"] autorelease];
	DCXmlNode *subElement2 = [[[DCXmlNode alloc] initWithName: @"ghi"] autorelease];
	[testElement addNode: subElement1];
	[testElement addNode: subElement2];

	GHAssertEqualObjects([testElement nodeAtIndex: 0], subElement1, @"SubElement1 not retrieved.");
	GHAssertEqualObjects([testElement nodeAtIndex: 1], subElement2, @"SubElement2 not retrieved.");
}

-(void) testSettingValueRemovesOldNodes {
	DCXmlNode * testElement = [[[DCXmlNode alloc] initWithName: @"abc"] autorelease];
	[testElement addXmlNodeWithName:@"abc"];
	[testElement setValue: @"Value"];
	GHAssertEqualStrings(testElement.value, @"Value", @"Returned xml not what was expected.");
	GHAssertFalse([testElement hasXmlNodeWithName:@"abc"], @"Nodes not cleared out.");

}

- (void) testValueAdded {
	DCXmlNode * testElement = [[DCXmlNode alloc] initWithName: @"abc"];
	[testElement setValue: @"Value"];
	GHAssertEqualStrings(testElement.value, @"Value", @"Returned xml not what was expected.");
}

- (void) testAttributeAddedToElement {
	DCXmlNode * testElement = [[[DCXmlNode alloc] initWithName: @"abc"] autorelease];
	[testElement setAttribute: @"def" value: @"ghi"];
	GHAssertEqualStrings([testElement attributeValue: @"def"], @"ghi", @"Attribute not added.");
}

- (void) testMultipleAttributesAddedToElement {
	DCXmlNode * testElement = [[DCXmlNode alloc] initWithName: @"abc"];
	[testElement setAttribute: @"def" value: @"ghi"];
	[testElement setAttribute: @"ijk" value: @"lmn"];
	GHAssertEqualStrings([testElement attributeValue: @"def"], @"ghi", @"Attribute def not added.");
	GHAssertEqualStrings([testElement attributeValue: @"ijk"], @"lmn", @"Attribute ijk not added.");
}

- (void) testAttributeEnumeration {
	DCXmlNode * testElement = [[[DCXmlNode alloc] initWithName: @"abc"] autorelease];
	[testElement setAttribute: @"def" value: @"ghi"];
	[testElement setAttribute: @"ijk" value: @"lmn"];
	int count = 0;
	for (DCXmlAttribute *attribute in[testElement attributes]) {
		DHC_LOG(@"Found attribute %@, value %@", attribute.name, attribute.value);
		if ( ([@"def" isEqualToString: attribute.name] &&[@"ghi" isEqualToString: attribute.value])
			  || ([@"ijk" isEqualToString: attribute.name] &&[@"lmn" isEqualToString: attribute.value])
			  ) {
			count++;
		}
	}
	GHAssertEquals(count, 2, @"2 Attributes not found.");
}

- (void) testAddNode {
	DCXmlNode * testElement = [[[DCXmlNode alloc] initWithName: @"abc"] autorelease];
	DCXmlNode *subElement = [[[DCXmlNode alloc] initWithName:  @"def"] autorelease];
	[testElement addNode: subElement];

	//Test and validate.
	DCXmlNode *returnedElement = [testElement xmlNodeWithName: @"def"];
	GHAssertNotNil(returnedElement, @"Expected an element to be returned.");
	GHAssertEqualObjects(returnedElement, subElement, @"Expected the sub element instance back");
}

- (void) testAddNodeByNameAndValue {
	DCXmlNode * testElement = [[[DCXmlNode alloc] initWithName:  @"abc"] autorelease];
	DCXmlNode *subElement = [testElement addXmlNodeWithName: @"def" value: @"ghi"];
	GHAssertNotNil(subElement, @"New sub element not returned.");
	GHAssertEqualStrings([subElement name], @"def", @"Sub element name incorrect.");
	GHAssertEqualStrings([subElement value], @"ghi", @"Sub element value incorrect.");
}

- (void) testAddingNamespace {
	DCXmlNode * testElement = [[[DCXmlNode alloc] initWithName: @"abc"] autorelease];
	[testElement addNamespace: @"namespace" prefix: @"prefix"];
	for (DCXmlNamespace *namespace in[testElement namespaces]) {
		if ([@"prefix" isEqualToString: namespace.prefix] &&[@"namespace" isEqualToString: namespace.url]) {
			//Found namespace;
			return;
		}
	}
	GHFail(@"Namespace not found.");
}

- (void) testHasSubElementSuccess {
	DCXmlNode * testElement = [[[DCXmlNode alloc] initWithName: @"abc"] autorelease];
	[testElement addXmlNodeWithName: @"def"];
	GHAssertTrue([testElement hasXmlNodeWithName: @"def"], @"hasSubElement failed to find element.");
}

- (void) testHasSubElementFail {
	DCXmlNode * testElement = [[[DCXmlNode alloc] initWithName: @"abc"] autorelease];
	[testElement addXmlNodeWithName: @"def"];
	GHAssertFalse([testElement hasXmlNodeWithName: @"ghi"], @"hasSubElement failed to find element.");
}

- (void) testSubElements {
	DCXmlNode * testElement = [[[DCXmlNode alloc] initWithName: @"abc"] autorelease];
	[testElement addXmlNodeWithName: @"def" value: @"012"];
	[testElement addXmlNodeWithName: @"def" value: @"345"];
	[testElement addXmlNodeWithName: @"def" value: @"678"];

	BOOL found[3] = {
		false, false, false
	};

	int counter = 0;
	for (DCXmlNode *element in[testElement nodes]) {
		counter++;
		DHC_LOG(@"Checking result element %@", element.name);
		if ([element.value isEqualToString:  @"012"]) found[0] = true;
		if ([element.value isEqualToString: @"345"]) found[1] = true;
		if ([element.value isEqualToString:  @"678"]) found[2] = true;
	}

	GHAssertEquals(counter, 3, @"Not 3 elements in list");
	for (int i = 0; i < 3; i++) {
		if (!found[i]) {
			GHFail(@"Sub element not found %i", i);
		}
	}
}

- (void) testSubElementsWithName {
	DCXmlNode * testElement = [[[DCXmlNode alloc] initWithName: @"abc"] autorelease];
	[testElement addXmlNodeWithName: @"ghi" value: @"0"];
	[testElement addXmlNodeWithName: @"def" value: @"1"];
	[testElement addXmlNodeWithName: @"def" value: @"2"];
	[testElement addXmlNodeWithName: @"gHi" value: @"3"];
	[testElement addXmlNodeWithName: @"def" value: @"4"];
	[testElement addXmlNodeWithName: @"DEF" value: @"5"];

	BOOL found[3] = {
		false, false, false
	};
	int counter = 0;

	for (DCXmlNode *element in[testElement xmlNodesWithName : @"def"]) {
		counter++;
		DHC_LOG(@"Checking result element %@ value %@", element.name, element.value);
		if ([element.value isEqualToString: @"1"]) found[0] = true;
		if ([element.value isEqualToString:  @"2"]) found[1] = true;
		if ([element.value isEqualToString:  @"4"]) found[2] = true;
	}

	GHAssertEquals(counter, 3, @"Not 3 elements in list");
	for (int i = 0; i < 3; i++) {
		if (!found[i]) {
			GHFail(@"Sub element not found %i", i);
		}
	}
}

// Printing tests.

- (void) testAsXmlString {
	DCXmlNode *element = [[[DCXmlNode alloc] initWithName: @"abc"] autorelease];
	GHAssertEqualStrings([element asXmlString], @"<abc />", @"Formatting failed.");
}

- (void) testAsXmlStringWithAttributes {
	DCXmlNode *element = [[[DCXmlNode alloc] initWithName: @"abc"] autorelease];
	[element setAttribute: @"nillable" value: @"true"];
	GHAssertEqualStrings([element asXmlString], @"<abc nillable=\"true\" />", @"Formatting failed.");
}

- (void) testAsXmlStringWithPrefix {
	DCXmlNode *element = [[[DCXmlNode alloc] initWithName: @"abc" prefix: @"x"] autorelease];
	GHAssertNotNil([element asXmlString], @"Nil value returned when xml expected.");
	GHAssertEqualStrings([element asXmlString], @"<x:abc />", @"Formatting Failed.");
}

- (void) testAsXmlStringWithValue {
	DCXmlNode *element = [[[DCXmlNode alloc] initWithName: @"abc"] autorelease];
	element.value = @"def";
	GHAssertEqualStrings([element asXmlString], @"<abc>def</abc>", @"Formatting failed.");
}

- (void) testAsXmlStringWithSubElements {
	DCXmlNode *element = [[[DCXmlNode alloc] initWithName: @"abc"] autorelease];
	[element addXmlNodeWithName: @"def" value: @"ghi"];
	[element addXmlNodeWithName: @"ijk" value: @"mno"];
	GHAssertEqualStrings([element asXmlString], @"<abc><def>ghi</def><ijk>mno</ijk></abc>", @"Formatting failed.");
}

- (void) testAsXmlStringDocumentWithNodesAndRootSchema {
	DCXmlNode *element = [[[DCXmlNode alloc] initWithName: @"abc"] autorelease];
	element.defaultSchema = @"rootschema";
	GHAssertEqualStrings([element asXmlString], @"<abc xmlns=\"rootschema\" />", @"Formatting failed.");
}

- (void) testAsXmlStringWithNamespace {
	DCXmlNode *element = [[[DCXmlNode alloc] initWithName: @"abc" prefix: @"x"] autorelease];
	[element addNamespace: @"url" prefix: @"x"];
	GHAssertEqualStrings([element asXmlString], @"<x:abc xmlns:x=\"url\" />", @"Formatting failed.");
}

- (void) testAsXmlStringSoapWebServiceCall {
	DCXmlDocument *document = [[[DCXmlDocument alloc] initWithName: @"envelope" prefix: @"soap"] autorelease];
	[document addNamespace: @"http://schemas.xmlsoap.org/soap/envelope/" prefix: @"soap"];
	[document setAttribute: @"soap:encodingStyle" value: @"http://schemas.xmlsoap.org/soap/encoding/"];
	DCXmlNode *bodyElement = [document addXmlNodeWithName: @"body" prefix: @"soap"];
	DCXmlNode *getLastTradePriceElement = [bodyElement addXmlNodeWithName: @"GetLastTradePrice" prefix: @"m"];
	[getLastTradePriceElement addNamespace: @"http://trading-site.com.au" prefix: @"m"];
	[getLastTradePriceElement addXmlNodeWithName: @"symbol" value: @"MOT"];

	NSString *resultXml = [document asXmlString];
	DHC_LOG(@"Expected: %@", WEB_SERVICE_XML);
	DHC_LOG(@"Got     : %@", resultXml);
	GHAssertEqualStrings(resultXml, WEB_SERVICE_XML, @"Formatting failed.");
}

- (void) testAsXmlStringMixedNodes {
	DCXmlNode *root = [[[DCXmlNode alloc] initWithName: @"root"] autorelease];
	[root addTextNodeWithValue: @"abc"];
	[root addXmlNodeWithName: @"element1" value:@"def"];
	[root addXmlNodeWithName: @"element2" value:@"ghi"];
	[root addTextNodeWithValue: @"lmn"];
	GHAssertEqualStrings([root asXmlString], @"<root>abc<element1>def</element1><element2>ghi</element2>lmn</root>", @"Xml not returned correctly.");
}


// Pretty printing tests.

- (void) testAsPrettyXmlString {
	DCXmlNode *element = [[[DCXmlNode alloc] initWithName: @"abc"] autorelease];
	GHAssertEqualStrings([element asPrettyXmlString], @"<abc />", @"Formatting failed.");
}

- (void) testAsPrettyXmlStringWithAttributes {
	DCXmlNode *element = [[[DCXmlNode alloc] initWithName: @"abc"] autorelease];
	[element setAttribute: @"nillable" value: @"true"];
	GHAssertEqualStrings([element asPrettyXmlString], @"<abc nillable=\"true\" />", @"Formatting failed.");
}

- (void) testAsPrettyXmlStringWithPrefix {
	DCXmlNode *element = [[[DCXmlNode alloc] initWithName: @"abc" prefix: @"x"] autorelease];
	GHAssertNotNil([element asXmlString], @"Nil value returned when xml expected.");
	GHAssertEqualStrings([element asPrettyXmlString], @"<x:abc />", @"Formatting Failed.");
}

- (void) testAsPrettyXmlStringWithValue {
	DCXmlNode *element = [[[DCXmlNode alloc] initWithName: @"abc"] autorelease];
	element.value = @"def";
	GHAssertEqualStrings([element asPrettyXmlString], @"<abc>def</abc>", @"Formatting failed.");
}

- (void) testAsPrettyXmlStringWithSubElements {
	DCXmlNode *element = [[[DCXmlNode alloc] initWithName: @"abc"] autorelease];
	[element addXmlNodeWithName: @"def" value: @"ghi"];
	[element addXmlNodeWithName: @"ijk" value: @"mno"];
	GHAssertEqualStrings([element asPrettyXmlString], @"<abc>\n\t<def>ghi</def>\n\t<ijk>mno</ijk>\n</abc>", @"Formatting failed.");
}

- (void) testAsPrettyXmlStringWithNamespace {
	DCXmlNode *element = [[[DCXmlNode alloc] initWithName: @"abc" prefix: @"x"] autorelease];
	[element addNamespace: @"url" prefix: @"x"];
	GHAssertEqualStrings([element asPrettyXmlString], @"<x:abc xmlns:x=\"url\" />", @"Formatting failed.");
}

- (void) testAsPrettyXmlStringSoapWebServiceCall {
	DCXmlDocument *document = [[[DCXmlDocument alloc] initWithName: @"envelope" prefix: @"soap"] autorelease];
	[document addNamespace: @"http://schemas.xmlsoap.org/soap/envelope/" prefix: @"soap"];
	[document setAttribute: @"soap:encodingStyle" value: @"http://schemas.xmlsoap.org/soap/encoding/"];
	DCXmlNode *bodyElement = [document addXmlNodeWithName: @"body" prefix: @"soap"];
	DCXmlNode *getLastTradePriceElement = [bodyElement addXmlNodeWithName: @"GetLastTradePrice" prefix: @"m"];
	[getLastTradePriceElement addNamespace: @"http://trading-site.com.au" prefix: @"m"];
	[getLastTradePriceElement addXmlNodeWithName: @"symbol" value: @"MOT"];

	NSString *resultXml = [document asPrettyXmlString];
	DHC_LOG(@"Expected: %@", PRETTY_WEB_SERVICE_XML);
	DHC_LOG(@"Got     : %@", resultXml);
	GHAssertEqualStrings(resultXml, PRETTY_WEB_SERVICE_XML, @"Formatting failed.");
}


@end