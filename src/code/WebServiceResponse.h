//
//  WebServiceResponse.h
//  dXml
//
//  Created by Derek Clarkson on 26/11/09.
//  Copyright 2009 Derek Clarkson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XmlNode.h"
#import "XmlDocument.h"

/**
 * An instance of this class will be returned from a sucessful call to a soap web service. 
 * It contains a complete copy o the soap response and also provide conveniance methods to access various predefined parts of the response.
 * \see SoapWebServiceConnection
 */
@interface WebServiceResponse : NSObject {
	@private
	XmlDocument *document;
}

/** \name Properties */

/**
 * The raw xml document as returned by the service.
 */
@property (nonatomic, readonly) XmlDocument *document;

/** \name Constructors */

/**
 * Constructor used by the connection to create this instance.
 */
- (WebServiceResponse *) initWithDocument: (XmlDocument *) aDocument;

/** \name Soap message elements */

/**
 * Gives direct access to the Body node. ie. \\Envelope\\Body.
 */
- (XmlNode *) bodyElement;

/**
 * Gives direct access to the first node within the Body node. Useful when you know there will be only one node within
 * the Body node. 
 */
- (XmlNode *) bodyContent;

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

@end