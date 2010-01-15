//
//  DOMNode.h
//  dXml
//
//  Created by Derek Clarkson on 13/12/09.
//  Copyright 2009 Derek Clarkson. All rights reserved.
//
 
// Use class to reference instead of import because import will create a circular reference and we want to
// delay type checking to avoid it.
@class XmlNode;

/**
 * The abstract parent of all DM node classes. This class should never be used directly because it merely provides some common code for the implementation classes. Instead make use of XmlNode and TextNode.
 */
@interface DMNode : NSObject
{
    XmlNode * parentNode;
}

/** \name Properties */

/** Used to locate the parent XmlNode in the DM tree.
 * Note that this is a weak reference (not retained). This avoids memory leaks caused
 * by circular references between parent and child nodes in the tree. */
@property (nonatomic, assign) XmlNode * parentNode;

/**
 * Internal method used during pretty printing for adding tabs and new lines.
 * \param xml A NSMutableString where the code will be appended.
 * \param prettyPrint If TRUE or YES, will cause this method to append a CR/LF combination and identDepth number of tab characters.
 * \param indentDepth the number of tabs to add to indent the text that will be printed next.
 */
- (void) newLineAndIndent:(NSMutableString *)xml prettyPrint:(bool)prettyPrint indentDepth:(int)indentDepth;

/**
 * Internal method used to serialise the DM out to a string. THis method does nothing by default and should be
 * overridden in derived classes to implement the necessary printing of values.
 * \param xml A NSMutableString where the code will be appended.
 * \param prettyPrint If TRUE or YES, is used inidicate that the text should be printed in a visually friendly style.
 * \param indentDepth the number of tabs to add to indent the text that will be printed next.
 */
- (void) appendToXmlString:(NSMutableString *)xml prettyPrint:(bool)prettyPrint indentDepth:(int)indentDepth;

@end


