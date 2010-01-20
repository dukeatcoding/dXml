//
//  XmlDocument.m
//  dXml
//
//  Created by Derek Clarkson on 30/10/09.
//  Copyright 2009 Derek Clarkson. All rights reserved.
//

#import "DCXmlDocument.h"

@implementation DCXmlDocument

/**
 * Overridden to add the standard XML header before calling the standard DCXmlNode#appendToXmlString:prettyPrint:indentDepth:
 * method.
 */
- (void) appendToXmlString: (NSMutableString *) xml prettyPrint: (bool) prettyPrint indentDepth: (int) indentDepth {
	[xml appendString:XML_HEADER];
	[super appendToXmlString:xml prettyPrint:prettyPrint indentDepth:indentDepth];
}

@end
