//
//  NSError+SoapFault.h
//  dXml
//
//  Created by Derek Clarkson on 18/01/10.
//  Copyright 2010 Derek Clarkson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DCXmlDocument.h"
#import "DCWebServiceResponse.h"

/**
 * Enum which specifies error codes.
 */
typedef enum {
	NSErrorSoapFault=1
}
   NSErrorSoapFaultErrorCode;

#define NSERROR_SOAP_FAULT_DOMAIN @"dXml:NSError(SoapFault)"
#define SOAP_FAULT_CODE_KEY		 @"faultCode"
#define SOAP_FAULT_MESSAGE_KEY	 @"faultMessage"

/**
 * This category adds functionality to the NSError class for dealing with soap faults that have been returned as NSError instances.
 */

@interface NSError (SoapFault)

/** \name Soap message handling */

/**
 * Returns YES if the NSError contains soap fault information.
 */
- (BOOL) isSoapFault;

/**
 * returns the contents of the faultMessage userinfo value.
 */
- (NSString *) soapFaultMessage;

/**
 * returns the contents of the faultCode userinfo value.
 */
- (NSString *) soapFaultCode;

/** \name Soap fault factory methods */
/**
 * Factory method which creates a NSError containing a soap fault.
 * \param response The full response document from a web service.
 */
+ (NSError *) errorWithSoapResponse:(DCWebServiceResponse *)response;

/**
 * Factory method which creates a NSError containing a soap fault.
 * \param fault The bod content from a we service call. This is expected to be the "Fault" node of the response.
 */
+ (NSError *) errorWithSoapFault:(DCXmlNode *)fault;

@end
