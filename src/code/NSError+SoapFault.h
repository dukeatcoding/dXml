//
//  NSError+SoapFault.h
//  dXml
//
//  Created by Derek Clarkson on 18/01/10.
//  Copyright 2010 Derek Clarkson. All rights reserved.
//

#import <Foundation/Foundation.h>

#define SOAP_FAULT_CODE_KEY = @"faultCode";
#define SOAP_FAULT_MESSAGE_KEY = @"faultMessage";

/**
 * This category adds functionality to the NSError class for dealing with soap faults that have been returned as NSError instances.
 */

@interface NSError (SoapFault)

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

/**
 Extracts the soap fault details and stores them in the userinfo data area of the NSError.
 */
- storeSoapFault:(XmlNode *) aSoapFault;

@end
