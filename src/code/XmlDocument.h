//
//  XmlDocument.h
//  dXml
//
//  Created by Derek Clarkson on 30/10/09.
//  Copyright 2009 Derek Clarkson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XmlNode.h"

#define XML_HEADER @"<?xml version=\"1.0\" encoding=\"UTF-8\"?>"

/**
 * This class is purely used as the top level node representing a complete xml document. It contains no additional
 * functionality. When serialising the document out to a string, the presence of an instance of this class as the root
 * node will automatically insert the standard xml version header at the top of the document
 * produced.
 */
@interface XmlDocument : XmlNode {
	@private
}

@end
