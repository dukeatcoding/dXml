//
//  XmlDocumentParserDelegate.m
//  dXml
//
//  Created by Derek Clarkson on 25/11/09.
//  Copyright 2009 Derek Clarkson. All rights reserved.
//

#import "DCXmlDocumentParserDelegate.h"
#import "dXml.h"

@implementation DCXmlDocumentParserDelegate

- (void) createNodeWithName: (NSString *) elementName {

	//If this is the first time in, then we want to create a XmlDocument as a top level element
	//instead of a DCXmlNode.
	if (self.document == nil) {
		DHC_LOG(@"self.document == nil, so creating a XmlDocument as the current document.");
		currentNode = (DCXmlDocument *)[[DCXmlDocument alloc] initWithName: elementName];
		return;
	}
	
	//Otherwise call the super to create the element.
	[super createNodeWithName:elementName];
}

-(DCXmlDocument *) document {
	return (DCXmlDocument *) rootNode;
}

@end