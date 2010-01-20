//
//  XmlParser.h
//  dXml
//
//  Created by Derek Clarkson on 25/10/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "DCXmlDocument.h"
#import "DCXmlNode.h"
#import "DCXmlDocumentParserDelegate.h"

/**
 * DCXmlParser is the raw parser for detailing with xml streams. In addition to the default NSURL and NSData that
 * the apis support, this class can also deal with xml inside NSStrings which makes testing and other options easy.
 * Once the data has been parsed, it can be returned on one of two ways, either as a DCXmlDocument or as a DCXmlNode. The
 * parserSubTree: method is exposed but ideally designed for parsing sections of a xml tree rather than a whole document.
 * Use parse: for that.
 * \p
 * Here's an example of using this class.
 * \code
 * NSString *xml = @"lt;?xml version=\"1.0\" encoding=\"UTF-8\"&gt;"
 *	@"&lt;soap:Envelope xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\"&gt;"
 *	@"&lt;soap:Body&gt;"
 *	@"&lt;dhc:balance xmlns:dhc=\"" MODEL_SCHEMA "\"&gt;"
 *	@"&lt;forAccountNumber&gt;1234&lt;/forAccountNumber&gt;"
 *	@"&lt;/dhc:balance&gt;"
 *	@"\n\t&lt;/soap:Body&gt;"
 *	@"\n&lt;/soap:Envelope&gt;";
 * &nbsp;
 * DCXmlParser * parser = [DCXmlParser parserWithXml: xml];
 * NSError *error = nil;
 * DCXmlDocument *doc = [parser parse:&error];
 * if (error != nil) {
 *		// Deal with the error.
 * }
 * &nbsp;
 * // Otherwise process the results.
 * \endcode
 * This class requires you to instantiate it with the data and then call parse: or parseSubtree: as a seperate command so that in the future various settings can be added to the class. Then the sequence would become init - setup - parse.
 */
@interface DCXmlParser : NSObject {
	@private
	NSXMLParser * parser;
}

/** \name Constructors and factory methods */
/* @{ */
/**
 * Creates an autorelease instance of DCXmlParser ready to read the supplied data.
 * \param xml the data to read.
 */
+ (DCXmlParser *) parserWithXml:(NSString *)xml;

/**
 * Creates an autorelease instance of DCXmlParser ready to read the supplied data.
 * \param data the data to read.
 */
+ (DCXmlParser *) parserWithData:(NSData *)data;

/**
 * Creates an autorelease instance of DCXmlParser ready to read the supplied data.
 * \param url the url that will be called to access the data.
 */
+ (DCXmlParser *) parserWithUrl:(NSURL *)url;

/**
 * Default constructor which takes xml stored in a string.
 */
- (DCXmlParser *) initWithXml:(NSString *)xml;

/**
 * Default constructor which takes xml stored in a NSData object.
 */
- (DCXmlParser *) initWithData:(NSData *)data;

/**
 * Default constructor which reads an xml stream from a NSURL.
 */
- (DCXmlParser *) initWithUrl:(NSURL *)url;
/* @} */

/** \name Parsing */

/**
 * Initiates the parsing of the supplied source and returns a DCXmlDocument containing the data graph of the results.
 * \param aErrorVar Reference to an error variable where the parser can store an error that occurs. Must be passed as `&aErrorVar`.
 */
- (DCXmlDocument *) parse:(NSError **)aErrorVar;

/**
 * Initiates the parsing of the supplied source and returns a DCXmlNode containing the data graph of the results.
 * \param aErrorVar Reference to an error variable where the parser can store an error that occurs. Must be passed as `&aErrorVar`.
 */
- (DCXmlNode *) parseSubtree:(NSError **)aErrorVar;

@end