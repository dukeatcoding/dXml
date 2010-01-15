//
//  XmlNode.h
//  dXml
//
//  Created by Derek Clarkson on 25/10/09.
//  Copyright 2009 Derek Clarkson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DMNode.h"
@class TextNode;

/**
 * XmlNode is the main class used to represent nodes in the Document Model (DM) tree.
 * The XmlParser and it's two delegates (XmlSubtreeParserDelegate and XmlDocumentParserDelegate)
 * will generate the whole DM using instances of this class and the TextNode class. The bulk of the functionality of the 
 * api with regards to the document model is embedded in this class.
 * <p>
 * XmlNodes contain all the data required to represent a xml element in the object graph:
 * \li name
 * \li prefix
 * \li attributes
 * \li namespace declarations
 * \li sub elements which can be of any DMNode type.
 * <p>
 * XmlNode is also the main factory class of the DM, being about to create instances of itself as well as other nodes
 * such as the TextNode.
 */
@interface XmlNode : DMNode {
	@private
	NSString * name;
	NSString * prefix;
	NSMutableDictionary * nodesByName;
	NSMutableDictionary * attributes;
	NSMutableDictionary * namespaces;
	NSMutableArray * nodesInOrder;
	NSString * defaultSchema;
}

/** \name Properties */
/* @{ */

/**
 * The name of the XmlNode as it would be printed in an xml stream.
 * For example a name of "abc" would yeild this xml
 * \code
 * &lt;<b>abc</b> /&gt;
 * \endcode
 */
@property (nonatomic, readonly) NSString * name;

/** Schema prefix. For example
 * \code
 * &lt;<b>soapenv</b>:Body /&gt;
 * \endcode
 */
@property (nonatomic, retain) NSString * prefix;

/** The defaultSchema is a schema specified without a prefix. There can be only one of these for a XmlNode.
 * For example
 * \code
 * &lt;abc <b>xmlns="http://defaultschema.com"</b> /&gt;
 * \endcode */
@property (retain, nonatomic) NSString * defaultSchema;

/* @} */


/** \name Constructors and factory methods */
/* @{ */
/**
 * Creates a XmlNode with just a name.
 */

- (XmlNode *) initWithName:(NSString *)aName;

/**
 * Creates a XmlNode with a name and namespace prefix.
 */
- (XmlNode *) initWithName:(NSString *)aName prefix:(NSString *)aPrefix;

/**
 * Factory method which creates a node (autorelease) with just a name and returns it.
 * \param aName the name of the xml node.
 */
+ (XmlNode *) createWithName:(NSString *)aName;

/**
 * Factory method which creates a node (autorelease) with a given name and prefix, then returns it.
 * \param aName the name of the xml node.
 * \param aPrefix the namespace prefix to apply.
 */
+ (XmlNode *) createWithName:(NSString *)aName prefix:(NSString *)aPrefix;

/**
 * Factory method which creates a node (autorelease) with a given name, and then sets a single TextNode under it
 * containing the passed value.
 * \param aName the name of the xml node.
 * \param aValue the value to set on the TextNode.
 */
+ (XmlNode *) createWithName:(NSString *)aName value:(NSString *)aValue;

/**
 * Factory method which creates a node (autorelease) with a given name and prefix, and then sets a single TextNode under it
 * containing the passed value.
 * \param aName the name of the xml node.
 * \param aPrefix the namespace prefix to apply.
 * \param aValue the value to set on the TextNode.
 */
+ (XmlNode *) createWithName:(NSString *)aName prefix:(NSString *)aPrefix value:(NSString *)aValue;
/* @} */

/** \name Querying */
/* @{ */
/**
 * Used during search loops to find child XmlNodes based on their names only. Obviously this only finds instances
 * of XmlNode.
 */
- (BOOL) isEqualToName:(NSString *)aName;
/* @}*/

/** \name Subnodes */
/* @{ */

/**
 * Returns the number of nodes within this node.
 */
- (int) countNodes;

/**
 * Locates and returns a XmlNode based on it's name only. Again this will only find XmlNodes.
 */
- (XmlNode *) xmlNodeWithName:(NSString *)aName;

/**
 * Returns the DMObject at the specific index. This can return any type of DMObject.
 */
- (XmlNode *) nodeAtIndex:(int)aIndex;

/**
 * Adds a new child DMNode to the end of the list of sub elements. This is the main method for adding child nodes.
 * If the passed node is a TextNode then it is just added to the nodesInOrder variable. if it's from the XmlNode hirachy then
 * it is also added to the nodesByName dictionary, however this will only happen if there is not a node already present
 * with the specified name. In other words, this method will only index the first occurance of a XmlNode with any give name.
 */
- (void) addNode:(DMNode *)element;

/**
 * Adds a new child XmlNode to the end of the list of DMObjects. This first constructs an instance
 * of XmlNode and then passes it to the addXmlNode(XmlNode *) method.
 * The returned XmlNode is autoreleased.
 * \see addXmlNode:
 */
- (XmlNode *) addXmlNodeWithName:(NSString *)aName;

/**
 * Adds a new child XmlNode to the end of the list of DMObjects. This first constructs an instance
 * of XmlNode and then passes it to the addXmlNode(XmlNode *) method.
 * The returned XmlNode is autoreleased.
 * \see addXmlNode:
 */
- (XmlNode *) addXmlNodeWithName:(NSString *)aName prefix:(NSString *)aPrefix;

/**
 * Adds a new child XmlNode to the end of the list of DMObjects. This first constructs an instance
 * of XmlNode and then passes it to the addXmlNode(XmlNode *) method.
 * The returned XmlNode is autoreleased.
 * \see addXmlNode:
 */
- (XmlNode *) addXmlNodeWithName:(NSString *)aName value:(NSString *)aValue;

/**
 * Adds a new child XmlNode to the end of the list of DMObjects. This first constructs an instance
 * of XmlNode and then passes it to the addXmlNode(XmlNode *) method.
 * The returned XmlNode is autoreleased.
 * \see addXmlNode:
 */
- (XmlNode *) addXmlNodeWithName:(NSString *)aName prefix:(NSString *)aPrefix value:(NSString *)aValue;

/**
 * returns true if the current XmlNode has a child XmlNode with the specified name.
 */
- (BOOL) hasXmlNodeWithName:(NSString *)aName;

/**
 * Returns a NSEnumerator which can be used to iteration through all the DMObjects. For example
 * \code
 * for (DMObject * node in [aXmlNode nodes] {
 *    ... do your stuff here ...
 * }
 * \endcode
 */
- (NSEnumerator *) nodes;

/**
 * Searches the child nodes for XmlNodes with the specific name and returns a new NSArray containing just those nodes.
 */
- (NSEnumerator *) xmlNodesWithName:(NSString *)aName;
/* @}*/

/** \name Namespaces */
/* @{ */

/**
 * Adds a namespace and prefix to the current XmlNode. This will manifest as a namespace declaration
 * in any produced xml. For example:
 * \code
 * XmlNode * node = [[XmlNode alloc] initWithName: @"abc"];
 * [node addNamespace: @"http://url.com" prefix: @"xyz"];
 * \endcode
 * Will result in:
 * \code
 * &lt;xyz:abc xlmns:xyz="http://url.com" /&gt;
 * \endcode
 */
- (void) addNamespace:(NSString *)aUrl prefix:(NSString *)aPrefix;

/**
 * Returns an NSEnumerator which can be used to iterator through all the namespaces added to the current XmlNode.
 * For example
 * \code
 * for (XmlNamespace * namespace in [aNode namespaces] {
 *    ... do your stuff here ...
 * }
 * \endcode
 */
- (NSEnumerator *) namespaces;

/* @}*/

/** \name Attributes */
/* @{ */

/**
 * Sets the name and value of an attribute. Here's an example
 * \code
 * XmlNode * node = [[XmlNode alloc] initWithName: @"element"];
 * [node setAttribute: @"abc" value: @"def"];
 * NSLog(@"%@", [node asXmlString]);
 * \endcode
 * Results in
 * \code
 * &lt;element abc="def" /&gt;
 * \endcode
 */
- (void) setAttribute:(NSString *)aName value:(NSString *)aValue;

/**
 * Returns the value for an attribute.
 */
- (NSString *) attributeValue:(NSString *)aName;

/**
 * Returns a NSEnumerator which can be used to iterate through all attributes. For example
 * \code
 * for (XmlNode * node in [aNode childNodes] {
 *    ... do your stuff here ...
 * }
 * \endcode
 */
- (NSEnumerator *) attributes;

/* @}*/

/** \name Values */
/* @{ */

/**
 * Shortcut method which returns the value of the first child TextNode or nil if there are no child TextNodes.
 */
- (NSString *) value;

/**
 * Adds an additional TextNode to the list of child nodes. THis is the primary method for adding
 * new text noes to the DM.
 * Note: unlike setValue: this method
 * does not clear the list of child Notes. It's primary purpose is for when loading an xml stream which may contain
 * mixed content.
 * The returned TextNode is autoreleased.
 */
- (TextNode *) addTextNodeWithValue:(NSString *)aValue;

/**
 * Short cut method which clears all current child elements and then adds a single TextNode containing the passed text.
 * This method also returns void so that it fits the standard getter/setter pattern and therefore can be used in the
 * shortcut form
 * \code
 * aNode<B>.value</b> = @"value";
 * \endcode
 */
- (void) setValue:(NSString *)value;

/* @}*/

/** \name Xml output */
/* @{ */

/**
 * Generates the XmlNode as a NSString. This is called when the client program needs to serialise the DM for sending to servers.
 */
- (NSString *) asXmlString;

/**
 * Effectively the same as asXmlString: however this "pretty prints" it which is useful for logging purposes where readibility of the
 * xml is the primary factor.
 */
- (NSString *) asPrettyXmlString;
/* @}*/

@end