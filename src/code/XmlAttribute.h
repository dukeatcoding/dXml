//
//  XmlAttribute.h
//  dXml
//
//  Created by Derek Clarkson on 30/10/09.
//  Copyright 2009 Derek Clarkson. All rights reserved.
//

#import <Foundation/Foundation.h>


/**
 * Represents the name and value of a xml elements attribute.
 * For example in
 * \code
 * &lt;abc <b>def</b>="<b>ghi</b>" /&gt;
 * \endcode
 * "def" is the name, and "ghi" is the value of the attribute.
 */
@interface XmlAttribute : NSObject {
	@private
	NSString *name;
	NSString *value;
}

/** \name Properties */
/**
 * The name of the attribute.
 */
@property (nonatomic, readonly) NSString *name;

/**
 * The value of the attribute.
 */

@property (nonatomic, retain) NSString *value;

/** \name Constructors */

/**
 * Default constructor. Based on the logic that all attributes must ave a name and value.
 */
-(XmlAttribute *) initWithName: (NSString *) aName value: (NSString *) aValue;

/** \name Serialisation */

/**
 * Used during serialisation to a xml string. Will produce 
 * \code
 * &lt;abc def="ghi" /&gt;
 * \endode
 */
- (void) appendToXmlString: (NSMutableString *) xml;

@end
