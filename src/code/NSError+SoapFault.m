//
//  NSError+SoapFault.m
//  dXml
//
//  Created by Derek Clarkson on 18/01/10.
//  Copyright 2010 Derek Clarkson. All rights reserved.
//

#import "NSError+SoapFault.h"


@implementation NSError (SoapFault)

- (BOOL) isSoapFault {
	return self.code == NSErrorSoapFault && [self.domain isEqualToString:NSERROR_SOAP_FAULT_DOMAIN];
}

- (NSString *) soapFaultMessage {
	return [self.userInfo valueForKey:SOAP_FAULT_MESSAGE_KEY];
}

- (NSString *) soapFaultCode {
	return [self.userInfo valueForKey:SOAP_FAULT_CODE_KEY];
}

+ (NSError *) errorWithSoapResponse:(DCWebServiceResponse *)response {
	return [self errorWithSoapFault:[response bodyContent]];
}

+ (NSError *) errorWithSoapFault:(DCXmlNode *)fault {

	// Extract the message parts we want.
	NSString * message = [fault xmlNodeWithName:@"faultstring"].value;
	NSString * code = [fault xmlNodeWithName:@"faultcode"].value;

	// Create the userinfo.
	NSMutableDictionary * dic = [NSMutableDictionary dictionary];

	[dic setValue:code forKey:SOAP_FAULT_CODE_KEY];
	[dic setValue:message forKey:SOAP_FAULT_MESSAGE_KEY];

	// Return an error.
	return [NSError errorWithDomain:NSERROR_SOAP_FAULT_DOMAIN code:NSErrorSoapFault userInfo:dic];
}


@end
