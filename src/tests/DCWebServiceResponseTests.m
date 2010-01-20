//
//  WebServiceResponseTests.m
//  dXml
//
//  Created by Derek Clarkson on 26/11/09.
//  Copyright 2009 Derek Clarkson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DCWebServiceResponse.h"
#import "DCXmlDocument.h"
#import "GHUnit.h"
#import "NSObject+SoapTemplates.h"
#import "dXml.h"

@interface DCWebServiceResponseTests : GHTestCase {
}
- (DCXmlDocument *) soapResponseGraph;

@end

@implementation DCWebServiceResponseTests

- (void) testResponseIsStoredAndReturned {
	DCXmlDocument * doc = [[[DCXmlDocument alloc] initWithName:@"Envelope"] autorelease];
	DCWebServiceResponse * response = [[[DCWebServiceResponse alloc] initWithDocument:doc] autorelease];

	GHAssertEqualObjects(response.document, doc, @"Expected object not returned.");
}

- (void) testBodyElement {
	DCXmlDocument * doc = [self soapResponseGraph];
	DCXmlNode * body = [doc xmlNodeWithName:@"Body"];
	DCWebServiceResponse * response = [[[DCWebServiceResponse alloc] initWithDocument:doc] autorelease];

	GHAssertEqualObjects([response bodyElement], body, @"Expected body object not returned.");
}

- (void) testBodyContent {
	DCXmlDocument * doc = [self soapResponseGraph];
	DCXmlNode * tradePriceResponse = [[doc xmlNodeWithName:@"Body"] xmlNodeWithName:@"GetLastTradePriceResponse"];
	DCWebServiceResponse * response = [[[DCWebServiceResponse alloc] initWithDocument:doc] autorelease];

	GHAssertEqualObjects([response bodyContent], tradePriceResponse, @"Expected body object not returned.");
}

- (void) testBodyContents {
	DCXmlDocument * doc = [self soapResponseGraph];
	DCXmlNode * tradePriceResponse = [[doc xmlNodeWithName:@"Body"] xmlNodeWithName:@"GetLastTradePriceResponse"];
	DCWebServiceResponse * response = [[[DCWebServiceResponse alloc] initWithDocument:doc] autorelease];
	NSEnumerator * enumerator = [response bodyContents];

	GHAssertEqualObjects([enumerator nextObject], tradePriceResponse, @"Expected body object not returned.");
	GHAssertNil([enumerator nextObject], @"Expected just the one object.");
}

- (DCXmlDocument *) soapResponseGraph {

	DCXmlDocument * document = [[[DCXmlNode alloc] initWithName:@"Envelope" prefix:@"soap"] autorelease];

	[document addNamespace:@"http://schemas.xmlsoap.org/soap/envelope/" prefix:@"soap"];
	[document setAttribute:@"soap:encodingStyle" value:@"http://schemas.xmlsoap.org/soap/encoding/"];
	DCXmlNode * bodyElement = [document addXmlNodeWithName:@"Body" prefix:@"soap"];
	DCXmlNode * getLastTradePriceElement = [bodyElement addXmlNodeWithName:@"GetLastTradePriceResponse" prefix:@"m"];
	[getLastTradePriceElement addNamespace:@"http://trading-site.com.au" prefix:@"m"];
	[getLastTradePriceElement addXmlNodeWithName:@"Price" value:@"14.5"];

	return document;
}

- (void) testIsSoapFaultTrue {

	DCXmlDocument * document = [[[DCXmlNode alloc] initWithName:@"Envelope" prefix:@"soap"] autorelease];

	[document addNamespace:@"http://schemas.xmlsoap.org/soap/envelope/" prefix:@"soap"];
	[document setAttribute:@"soap:encodingStyle" value:@"http://schemas.xmlsoap.org/soap/encoding/"];
	DCXmlNode * bodyElement = [document addXmlNodeWithName:@"Body" prefix:@"soap"];
	[bodyElement addXmlNodeWithName:@"Fault"];

	DHC_LOG(@"Soap fault xml\n%@", [document asPrettyXmlString]);

	DCWebServiceResponse * response = [[[DCWebServiceResponse alloc] initWithDocument:document] autorelease];

	BOOL isFault = [response isSoapFault];
	DHC_LOG(@"Fault = %@", DHC_PRETTY_BOOL(isFault));
	GHAssertTrue(isFault, @"Expected isSoapFault to be YES");

}

- (void) testIsSoapFaultFalse {
	DCWebServiceResponse * response = [[[DCWebServiceResponse alloc] initWithDocument:[self soapResponseGraph]] autorelease];

	GHAssertFalse([response isSoapFault], @"Expected isSoapFault to be NO");
}

@end