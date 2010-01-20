//
//  XmlNamespace.h
//  dXml
//
//  Created by Derek Clarkson on 24/11/09.
//  Copyright 2009 Derek Clarkson. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * Represents the prefix and url of a namespace associated with an DCXmlNode.
 * For example in
 * \code
 * &lt;abc xmlns:<b>def</b>="<b>http://ghi</b>" /&gt;
 * \endcode
 * "def" is the prefix, and "http://ghi" is the url of the namespace. Generally speak urls for namespaces always take the form
 * of a http:// url.
 */
@interface DCXmlNamespace : NSObject {
	NSString * prefix;
	NSString * url;
}

/** \name Properties */

/**
 * The prefix of the namespace.
 */
@property (retain, nonatomic, readonly) NSString * prefix;

/**
 * The url of the namespace.
 */
@property (retain, nonatomic, readonly) NSString * url;

/** \name Constructors */

/**
 * Default constructor.
 */
- (DCXmlNamespace *) initWithUrl:(NSString *)aUrl prefix:(NSString *)aPrefix;

/** \name Serialisation */

/**
 * Used during serialisation to a string. This will append the string with the namespace as expected for a
 * xml node. For example
 * \code
 * &lt;xyz:abc <b>xmlns:xyz="http://url.com/xyz"</b> /&gt;
 * \endcode
 */
- (void) appendToXmlString:(NSMutableString *)xml;

@end

