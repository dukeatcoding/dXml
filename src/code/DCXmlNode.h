//
//  DCXmlNode.h
//  dXml
//
//  Created by Derek Clarkson on 25/10/09.
//  Copyright 2009 Derek Clarkson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DCDMNode.h"
@class DCTextNode;

/**
 * DCXmlNode is the main class used to represent nodes in the Document Model (DM) tree.
 * The DCXmlParser and it's two delegates (DCXmlSubtreeParserDelegate and DCXmlDocumentParserDelegate)
 * will generate the whole DM using instances of this class and the DCTextNode class. The bulk of the functionality of the 
 * api with regards to the document model is embedded in this class.
 * <p>
 * DCXmlNodes contain all the data required to represent a xml element in the object graph:
 * \li name
 * \li prefix
 * \li attributes
 * \li namespace declarations
 * \li sub elements which can be of any DMNode type.
 * <p>
 * DCXmlNode is also the main factory class of the DM, being about to create instances of itself as well as other nodes
 * such as the DCTextNode.
 */
@interface DCXmlNode : DCDMNode {
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
 * The name of the DCXmlNode as it would be printed in an xml stream.
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

/** The defaultSchema is a schema specified without a prefix. There can be only one of these for a DCXmlNode.
 * For example
 * \code
 * &lt;abc <b>xmlns="http://defaultschema.com"</b> /&gt;
 * \endcode */
@property (retain, nonatomic) NSString * defaultSchema;

/* @} */


/** \name Constructors and factory methods */
/* @{ */
/**
 * Creates a DCXmlNode with just a name.
 */

- (DCXmlNode *) initWithName:(NSString *)aName;

/**
 * Creates a DCXmlNode with a name and namespace prefix.
 */
- (DCXmlNode *) initWithName:(NSString *)aName prefix:(NSString *)aPrefix;

/**
 * Factory method which creates a node (autorelease) with just a name and returns it.
 * \param aName the name of the xml node.
 */
+ (DCXmlNode *) createWithName:(NSString *)aName;

/**
 * Factory method which creates a node (autorelease) with a given name and prefix, then returns it.
 * \param aName the name of the xml node.
 * \param aPrefix the namespace prefix to apply.
 */
+ (DCXmlNode *) createWithName:(NSString *)aName prefix:(NSString *)aPrefix;

/**
 * Factory method which creates a node (autorelease) with a given name, and then sets a single DCTextNode under it
 * containing the passed value.
 * \param aName the name of the xml node.
 * \param aValue the value to set on the DCTextNode.
 */
+ (DCXmlNode *) createWithName:(NSString *)aName value:(NSString *)aValue;

/**
 * Factory method which creates a node (autorelease) with a given name and prefix, and then sets a single DCTextNode under it
 * containing the passed value.
 * \param aName the name of the xml node.
 * \param aPrefix the namespace prefix to apply.
 * \param aValue the value to set on the DCTextNode.
 */
+ (DCXmlNode *) createWithName:(NSString *)aName prefix:(NSString *)aPrefix value:(NSString *)aValue;
/* @} */

/** \name Querying */
/* @{ */
/**
 * Used during search loops to find child DCXmlNodes based on their names only. Obviously this only finds instances
 * of DCXmlNode.
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
 * Locates and returns a DCXmlNode based on it's name only. Again this will only find DCXmlNodes.
 */
- (DCXmlNode *) xmlNodeWithName:(NSString *)aName;

/**
 * Returns the DMObject at the specific index. This can return any type of DMObject.
 */
- (DCXmlNode *) nodeAtIndex:(int)aIndex;

/**
 * Adds a new child DCDMNode to the end of the list of sub elements. This is the main method for adding child nodes.
 * If the passed node is a DCTextNode then it is just added to the nodesInOrder variable. if it's from the DCXmlNode hirachy then
 * it is also added to the nodesByName dictionary, however this will only happen if there is not a node already present
 * with the specified name. In other words, this method will only index the first occurance of a DCXmlNode with any give name.
 */
- (void) addNode:(DCDMNode *)element;

/**
 * Adds a new child DCXmlNode to the end of the list of DCDMNodes. This first constructs an instance
 * of DCXmlNode and then passes it to the addXmlNode(XmlNode *) method.
 * The returned DCXmlNode is autoreleased.
 * \see addXmlNode:
 */
- (DCXmlNode *) addXmlNodeWithName:(NSString *)aName;

/**
 * Adds a new child DCXmlNode to the end of the list of DCDMNodes. This first constructs an instance
 * of DCXmlNode and then passes it to the addXmlNode(XmlNode *) method.
 * The returned DCXmlNode is autoreleased.
 * \see addXmlNode:
 */
- (DCXmlNode *) addXmlNodeWithName:(NSString *)aName prefix:(NSString *)aPrefix;

/**
 * Adds a new child DCXmlNode to the end of the list of DCDMNodes. This first constructs an instance
 * of DCXmlNode and then passes it to the addXmlNode(XmlNode *) method.
 * The returned DCXmlNode is autoreleased.
 * \see addXmlNode:
 */
- (DCXmlNode *) addXmlNodeWithName:(NSString *)aName value:(NSString *)aValue;

/**
 * Adds a new child DCXmlNode to the end of the list of DCDMNodes. This first constructs an instance
 * of DCXmlNode and then passes it to the addXmlNode(XmlNode *) method.
 * The returned DCXmlNode is autoreleased.
 * \see addXmlNode:
 */
- (DCXmlNode *) addXmlNodeWithName:(NSString *)aName prefix:(NSString *)aPrefix value:(NSString *)aValue;

/**
 * returns true if the current DCXmlNode has a child DCXmlNode with the specified name.
 */
- (BOOL) hasXmlNodeWithName:(NSString *)aName;

/**
 * Returns a NSEnumerator which can be used to iteration through all the DCDMNodes. For example
 * \code
 * for (DCDMNode * node in [aXmlNode nodes] {
 *    ... do your stuff here ...
 * }
 * \endcode
 */
- (NSEnumerator *) nodes;

/**
 * Searches the child nodes for DCXmlNodes with the specific name and returns a new NSArray containing just those nodes.
 */
- (NSEnumerator *) xmlNodesWithName:(NSString *)aName;
/* @}*/

/** \name Namespaces */
/* @{ */

/**
 * Adds a namespace and prefix to the current DCXmlNode. This will manifest as a namespace declaration
 * in any produced xml. For example:
 * \code
 * DCXmlNode * node = [[DCXmlNode alloc] initWithName: @"abc"];
 * [node addNamespace: @"http://url.com" prefix: @"xyz"];
 * \endcode
 * Will result in:
 * \code
 * &lt;xyz:abc xlmns:xyz="http://url.com" /&gt;
 * \endcode
 */
- (void) addNamespace:(NSString *)aUrl prefix:(NSString *)aPrefix;

/**
 * Returns an NSEnumerator which can be used to iterator through all the namespaces added to the current DCXmlNode.
 * For example
 * \code
 * for (DCXmlNamespace * namespace in [aNode namespaces] {
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
 * DCXmlNode * node = [[DCXmlNode alloc] initWithName: @"element"];
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
 * for (DCXmlNode * node in [aNode childNodes] {
 *    ... do your stuff here ...
 * }
 * \endcode
 */
- (NSEnumerator *) attributes;

/* @}*/

/** \name Values */
/* @{ */

/**
 * Shortcut method which returns the value of the first child DCTextNode or nil if there are no child DCTextNodes.
 */
- (NSString *) value;

/**
 * Adds an additional DCTextNode to the list of child nodes. THis is the primary method for adding
 * new text noes to the DM.
 * Note: unlike setValue: this method
 * does not clear the list of child Notes. It's primary purpose is for when loading an xml stream which may contain
 * mixed content.
 * The returned DCTextNode is autoreleased.
 */
- (DCTextNode *) addTextNodeWithValue:(NSString *)aValue;

/**
 * Short cut method which clears all current child elements and then adds a single DCTextNode containing the passed text.
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
 * Generates the DCXmlNode as a NSString. This is called when the client program needs to serialise the DM for sending to servers.
 */
- (NSString *) asXmlString;

/**
 * Effectively the same as asXmlString: however this "pretty prints" it which is useful for logging purposes where readibility of the
 * xml is the primary factor.
 */
- (NSString *) asPrettyXmlString;
/* @}*/


-(DCXmlNode *) xmlNodeWithXPath:(NSString *) aXpath;

-(NSString *) valueWithXPath:(NSString *) aXpath;

@end