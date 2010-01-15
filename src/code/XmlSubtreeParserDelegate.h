//
//  XmlParserDelegate.h
//  dXml
//
//  Created by Derek Clarkson on 16/11/09.
//  Copyright 2009 Derek Clarkson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XmlNode.h"

/**
 * Main class for parsing xml streams. This class is capable of receiving and processing the incoming xml events and assembling
 * from them a complete DM data graph. Internally it makes use of an instance of NSXMLParser to do the grunt work.
 * Here is an example of using this class to process a string containing xml into the document model:
 * \code
 * NSString *xml = @"&lt;xml ...&gt;";
 * XmlParser *parser = [XmlParser parserWithXml: xml];
 * XmlDocument *xmlDoc = [parser parse];
 * \endcode
 */
@interface XmlSubtreeParserDelegate : NSObject {
	@protected
	XmlNode * currentNode;
	XmlNode * rootNode;
	@private
	NSMutableDictionary * namespaceCache;
	/**
	 * Used to cache text until an ending element or a new subelement is encounterded.
	 */
	NSMutableString * valueCache;

	/**
	 * If an error is encountered processing the xml, it is stored in this variable until the parser can retreive it.
	 */
	NSError * error;
}

/** \name Properties */

/**
 * Returns the root node of the result document mode.
 */
@property (readonly, nonatomic) XmlNode * rootNode;

/**
 * If an error is encountered, it will be stored in this variable and the xml processing will be stopped.
 */
@property (retain, nonatomic) NSError * error;

/** \name Subnodes */
/**
 * Called during the construction of the DM each time a new node is needed. The XmlDocumentParserDelegate class overrides
 * this method to create a XmlDocument for the root node.
 * \see XmlDocumentParserDelegate
 */
- (void) createNodeWithName:(NSString *)aName;

/** \name NSXMLParser delegate methods */
/** &nbsp; */
- (void) parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI
  qualifiedName:(NSString *)qualifiedName attributes:(NSDictionary *)attributeDict;

/** &nbsp; */
- (void) parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI
  qualifiedName:(NSString *)qName;

/** &nbsp; */
- (void) parser:(NSXMLParser *)parser didStartMappingPrefix:(NSString *)prefix toURI:(NSString *)namespaceURI;

/** &nbsp; */
- (void) parser:(NSXMLParser *)parser foundCharacters:(NSString *)string;

/** &nbsp; */
- (void) parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError;

/** &nbsp; */
- (void) parser:(NSXMLParser *)parser validationErrorOccurred:(NSError *)validationError;


@end