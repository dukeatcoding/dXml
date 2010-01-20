//
//  WebServiceResponse.h
//  dXml
//
//  Created by Derek Clarkson on 26/11/09.
//  Copyright 2009 Derek Clarkson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DCXmlNode.h"
#import "DCXmlDocument.h"

/**
 * An instance of this class will be returned from a sucessful call to a soap web service. 
 * It contains a complete copy o the soap response and also provide conveniance methods to access various predefined parts of the response.
 * \see DCSoapWebServiceConnection
 */
@interface DCWebServiceResponse : NSObject {
	@private
	DCXmlDocument *document;
}

/** \name Properties */

/**
 * The raw xml document as returned by the service.
 */
@property (nonatomic, readonly) DCXmlDocument *document;

/** \name Constructors */

/**
 * Constructor used by the connection to create this instance.
 */
- (DCWebServiceResponse *) initWithDocument: (DCXmlDocument *) aDocument;

/** \name Soap message elements */

/**
 * Gives direct access to the Body node. ie. \\Envelope\\Body.
 */
- (DCXmlNode *) bodyElement;

/**
 * Gives direct access to the first node within the Body node. Useful when you know there will be only one node within
 * the Body node. 
 */
- (DCXmlNode *) bodyContent;

/**
 * Returns a NSEnumerator of the nodes within the Body node. This is useful when for example you get this reply:
 * \code
 * ...
 * &lt;Body&gt;
 *    &lt;Data&gt; ... &lt;/Data&gt;
 *    &lt;Data&gt; ... &lt;/Data&gt;
 *    &lt;Data&gt; ... &lt;/Data&gt;
 * &lt;/Body&gt;
 * \endcode
 * This NSEnumator will loop through all the "Data" elements in turn.
 */
- (NSEnumerator *) bodyContents;

/**
 * Returns true if the response contains a soap fault. Generally speaking this is never used in client programs because soap faults are automatically converted into NSError instances. This method is used internally during response processing.
 */
- (BOOL) isSoapFault;

@end