//
//  XmlAttributeTests.m
//  dXml
//
//  Created by Derek Clarkson on 30/10/09.
//  Copyright 2009 Derek Clarkson. All rights reserved.
//

#import "GHUnit.h"
#import "DCXmlAttribute.h"
#import "dXml.h"

@interface DCXmlAttributeTests : GHTestCase {
	@private
	NSMutableString * xml;
	DCXmlAttribute * attr;
}

@end

@implementation DCXmlAttributeTests

- (void) setUp {
	[super setUp];
	xml = [[NSMutableString alloc] init];
}

- (void) tearDown {
	DHC_DEALLOC(xml);
	DHC_DEALLOC(attr);
	[super tearDown];
}

- (void) testAppendedValue {
	attr = [[DCXmlAttribute alloc] initWithName: @"abc" value: @"def"];
	[attr appendToXmlString: xml];
	GHAssertEqualStrings(xml, @" abc=\"def\"", @"Attribute not formatted correctly.");
}

- (void) testChangedValueIsReturned {
	attr = [[DCXmlAttribute alloc] initWithName: @"abc" value: @"def"];
	[attr setValue: @"ghi"];
	[attr appendToXmlString: xml];
	GHAssertEqualStrings(xml, @" abc=\"ghi\"", @"Attribute not formatted correctly.");
}

@end