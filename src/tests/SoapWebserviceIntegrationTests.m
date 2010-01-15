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
#import "XmlDocument.h"
#import "IntegrationTestDefaults.h"

@interface SoapWebserviceIntegrationTests:GHTestCase
{
}
- (XmlNode *) createBalancePayload;
- (void) assertBalanceResponse: (WebServiceResponse *) response;
@end

@implementation SoapWebserviceIntegrationTests

- (void) testMsgUsingXmlString {
	NSString *xml = @"<dhc:balance xmlns:dhc=\"" MODEL_SCHEMA "\">"
						 @"<forAccountNumber>1234</forAccountNumber>"
						 @"</dhc:balance>";

	SoapWebServiceConnection *service = [SoapWebServiceConnection createWithUrl: BANKING soapAction: BALANCE_ACTION];

	NSError *error = nil;
	WebServiceResponse *response = [service postXmlStringPayload: xml errorVar:&error];
	GHAssertNil(error, @"An error should not have been returned");
	[self assertBalanceResponse: response];
}

- (void) testMsgUsingXmlNodes {
	XmlNode *accountBalance = [self createBalancePayload];

	SoapWebServiceConnection *service = [SoapWebServiceConnection createWithUrl: BANKING soapAction: BALANCE_ACTION];
	NSError *error = nil;
	WebServiceResponse *response = [service postXmlNodePayload: accountBalance errorVar:&error];
	GHAssertNil(error, @"An error should not have been returned");
	[self assertBalanceResponse: response];
}

- (void) testSecureMsgUsingXmlNodes {
	XmlNode *accountBalance = [self createBalancePayload];

	SoapWebServiceConnection *service = [SoapWebServiceConnection createWithUrl: BANKING soapAction: BALANCE_ACTION];
	NSError *error = nil;
	WebServiceResponse *response = [service postXmlNodePayload: accountBalance errorVar:&error];
	GHAssertNil(error, @"An error should not have been returned");
	[self assertBalanceResponse: response];
}

- (void) testSoapFaultGeneral {
	//THis is an old format payload which no longer works. Now generates a soap fault.
	NSString *xml = @"<dhc:AccountBalance xmlns:dhc=\"" BASE_SCHEMA "\" />";

	SoapWebServiceConnection *service = [SoapWebServiceConnection createWithUrl: BANKING soapAction: BALANCE_ACTION];
	NSError *error = nil;
	WebServiceResponse *response = [service postXmlStringPayload: xml errorVar:&error];

	GHAssertNotNil(error, @"Nil error returned");
	GHAssertNil(response, @"Response returned when it should not be.");
	GHAssertEquals(error.code, SoapWebServiceConnectionSoapFault, @"Incorrect error code");
	GHAssertEqualStrings(error.domain, SOAP_WEB_SERVICE_CONNECTION_DOMAIN, @"Incorrect domain returned");
	NSDictionary *userInfo = error.userInfo;
	GHAssertEqualStrings([userInfo valueForKey:@"faultCode"], @"ns2:Client", @"Incorrect fault code returned");
	GHAssertEqualStrings([userInfo valueForKey:@"faultMessage"], @"Cannot find dispatch method for {http://www.dhcbank.com/banking/schema}AccountBalance", @"Incorrect fault message returned");
}

- (void) testSoapWithFaultCustomException {
	NSString *xml = @"<dhc:balance xmlns:dhc=\"" MODEL_SCHEMA "\" />";

	SoapWebServiceConnection *service = [SoapWebServiceConnection createWithUrl: BANKING soapAction: BALANCE_ACTION];
	NSError *error = nil;
	WebServiceResponse *response = [service postXmlStringPayload: xml errorVar:&error];

	GHAssertNotNil(error, @"Nil error returned");
	GHAssertNil(response, @"Response returned when it should not be.");
	GHAssertEquals(error.code, SoapWebServiceConnectionSoapFault, @"Incorrect error code");
	GHAssertEqualStrings(error.domain, SOAP_WEB_SERVICE_CONNECTION_DOMAIN, @"Incorrect domain returned");
	NSDictionary *userInfo = error.userInfo;
	GHAssertEqualStrings([userInfo valueForKey:@"faultCode"], @"ns2:Server", @"Incorrect fault code returned");
	GHAssertEqualStrings([userInfo valueForKey:@"faultMessage"], @"No account number passed to service.", @"Incorrect fault message returned");
}

- (void) assertBalanceResponse: (WebServiceResponse *) response {
	GHAssertEqualStrings([response bodyContent].name, @"balanceResponse", @"Body content incorrect");
	GHAssertNotNil([[response bodyContent] xmlNodeWithName: @"balance"], @"Response not correct.");
	GHAssertNotNil([[response bodyContent] xmlNodeWithName: @"balance"].value, @"No balance amount");
}

- (XmlNode *) createBalancePayload {
	XmlNode *accountBalance = [[[XmlNode alloc] initWithName: @"balance" prefix: @"dhc"] autorelease];
	[accountBalance addNamespace: MODEL_SCHEMA prefix: @"dhc"];
	[accountBalance addXmlNodeWithName: @"forAccountNumber" prefix: nil value: @"1234"];
	return accountBalance;
}

@end