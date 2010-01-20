//
//  NSError+SoapFault.m
//  dXml
//
//  Created by Derek Clarkson on 19/01/10.
//  Copyright 2010 Derek Clarkson. All rights reserved.
//
#import "NSError+SoapFault.h"
#import "DCXmlNode.h"
#import "DCXmlDocument.h"
#import "GHUnit.h"

@interface NSError_SoapFaultTests : GHTestCase {
	@private
}

@end

@implementation NSError_SoapFaultTests

- (void) testFactoryUsingXmlNode {
	DCXmlNode * faultNode = [DCXmlNode createWithName:@"Fault"];

	[faultNode addXmlNodeWithName:@"faultcode" value:@"abc"];
	[faultNode addXmlNodeWithName:@"faultstring" value:@"def"];
	NSError * error = [NSError errorWithSoapFault:faultNode];

	GHAssertEqualStrings(error.domain, NSERROR_SOAP_FAULT_DOMAIN, @"Domain incorrect");
	GHAssertEquals(error.code, NSErrorSoapFault, @"code incorrect");

	NSDictionary * dic = error.userInfo;
	GHAssertEqualStrings([dic valueForKey:SOAP_FAULT_CODE_KEY], @"abc", @"Code not returned");
	GHAssertEqualStrings([dic valueForKey:SOAP_FAULT_MESSAGE_KEY], @"def", @"Message not returned");

}

- (void) testCodeAccessor {
	DCXmlNode * faultNode = [DCXmlNode createWithName:@"Fault"];

	[faultNode addXmlNodeWithName:@"faultcode" value:@"abc"];
	[faultNode addXmlNodeWithName:@"faultstring" value:@"def"];
	NSError * error = [NSError errorWithSoapFault:faultNode];

	GHAssertEqualStrings(error.soapFaultCode, @"abc", @"Code accessor not working");
}

- (void) testMessageAccessor {
	DCXmlNode * faultNode = [DCXmlNode createWithName:@"Fault"];

	[faultNode addXmlNodeWithName:@"faultcode" value:@"abc"];
	[faultNode addXmlNodeWithName:@"faultstring" value:@"def"];
	NSError * error = [NSError errorWithSoapFault:faultNode];

	GHAssertEqualStrings(error.soapFaultMessage, @"def", @"Message accessor not working");
}

- (void) testIsSoapFaultFalse {
	NSError * error = [NSError errorWithDomain:@"abc" code:0 userInfo:nil];

	GHAssertFalse([error isSoapFault], @"Expected to be false");
}

- (void) testIsSoapFaultTrue {
	DCXmlNode * faultNode = [DCXmlNode createWithName:@"Fault"];
	NSError * error = [NSError errorWithSoapFault:faultNode];

	GHAssertTrue([error isSoapFault], @"Expected to be false");
}

@end
