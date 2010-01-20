//
//  NSObject+SoapTemplates.m
//  dXml
//
//  Created by Derek Clarkson on 4/12/09.
//  Copyright 2009 Derek Clarkson. All rights reserved.
//

#import "NSObject+SoapTemplates.h"

@implementation NSObject (SoapTemplates)

- (DCXmlDocument *) createBasicSoapDM {
	DCXmlDocument *doc = [[[DCXmlDocument alloc] initWithName: @"Envelope" prefix: @"soapenv"] autorelease];
	[doc addNamespace: @"http://www.w3.org/2001/XMLSchema" prefix: @"xsd"];
	[doc addNamespace: @"http://www.w3.org/2001/XMLSchema-instance" prefix: @"xsi"];
	[doc addNamespace: @"http://schemas.xmlsoap.org/soap/envelope/" prefix: @"soapenv"];
	[doc addXmlNodeWithName: @"Header" prefix: @"soapenv"];
	[doc addXmlNodeWithName: @"Body" prefix: @"soapenv"];
	return doc;
}

- (DCXmlDocument *) createSoapFaultDM {
	DCXmlDocument *doc = [self createBasicSoapDM];
	DCXmlNode *body = [doc xmlNodeWithName:@"Body"];
	DCXmlNode *fault = [body addXmlNodeWithName:@"Fault"];
	[fault addXmlNodeWithName:@"faultcode"];
	[fault addXmlNodeWithName:@"faultstring"];
	return doc;
}

@end