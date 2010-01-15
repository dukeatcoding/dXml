//
//  SoapWebserviceTests.m
//  dXml
//
//  Created by Derek Clarkson on 26/11/09.
//  Copyright 2009 Derek Clarkson. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "dXml.h"
#import "GHUnit.h"
#import "SoapWebServiceConnection.h"

@interface SoapWebserviceConnectionTests : GHTestCase
{
}
@end

@implementation SoapWebserviceConnectionTests

- (void) testStaticCreationWithUrl {
	SoapWebServiceConnection *service = [SoapWebServiceConnection createWithUrl: @"url"];
	GHAssertEqualStrings(service.serverUrl, @"url", @"Url not set.");
}

- (void) testStaticCreationWithUrlAndActon {
	SoapWebServiceConnection *service = [SoapWebServiceConnection createWithUrl: @"url" soapAction: @"action"];
	GHAssertEqualStrings(service.serverUrl, @"url", @"Url not set.");
	GHAssertEqualStrings(service.soapAction, @"action", @"Operation not set.");
}

- (void) testParsingErrorHandling {
	
	// This will trigger a parse exception.
	NSString *xml = @"";
	
	SoapWebServiceConnection *service = [SoapWebServiceConnection createWithUrl: nil soapAction: nil];
	NSError	* error;
	WebServiceResponse *response = [service postXmlStringPayload: xml errorVar:&error];
	
	GHAssertNotNil(error, @"Expected error to be present");
	GHAssertNil(response, @"Expected response to be nil");
	GHAssertEquals(error.code, 5, @"Error code does not match");
	GHAssertEqualStrings(error.domain, @"NSXMLParserErrorDomain", @"Error domain does not match");
	
}

- (void) testParsingErrorHandlingIgnored {
	
	// This will trigger a parse exception.
	NSString *xml = @"";
	
	SoapWebServiceConnection *service = [SoapWebServiceConnection createWithUrl: nil soapAction: nil];
	NSError * error = NULL;
	WebServiceResponse *response = [service postXmlStringPayload: xml errorVar:&error];
	
	GHAssertNil(response, @"Expected response to be nil");
}


@end