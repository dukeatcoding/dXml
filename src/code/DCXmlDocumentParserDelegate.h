//
//  XmlDocumentParserDelegate.h
//  dXml
//
//  Created by Derek Clarkson on 25/11/09.
//  Copyright 2009 Derek Clarkson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DCXmlSubtreeParserDelegate.h"
#import "DCXmlDocument.h"

/**
 * Simple extension of the DCXmlSubtreeParserDelegate that returns a DCXmlDocument. Other than that there is no additional functionality.
 */
@interface DCXmlDocumentParserDelegate : DCXmlSubtreeParserDelegate {
}

/** \name Accessors */
/**
 * Get the document parsed as a DCXmlDocument.
 */
-(DCXmlDocument *) document;

@end