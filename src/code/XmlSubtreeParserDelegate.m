//
//  XmlParserDelegate.m
//  dXml
//
//  Created by Derek Clarkson on 16/11/09.
//  Copyright 2009 Derek Clarkson. All rights reserved.
//

#import "XmlSubtreeParserDelegate.h"
#import "dXml.h"
#import "XmlNamespace.h"

@interface XmlSubtreeParserDelegate ()

-(void) appendCachedText;

@end


@implementation XmlSubtreeParserDelegate

@synthesize rootNode;
@synthesize error;

- (void) createNodeWithName: (NSString *) aName {
	XmlNode *newNode = [[XmlNode alloc] initWithName: aName];
	[currentNode addNode: newNode];
	[currentNode release];
	currentNode = newNode;
}

-(void) appendCachedText {
	//If there is a value then set it and release.
	if (valueCache != nil) {
		[currentNode addTextNodeWithValue: valueCache];
		[valueCache release];
		valueCache = nil;
	}
}


- (void) parser: (NSXMLParser *) parser didStartElement: (NSString *) elementName namespaceURI: (NSString *) namespaceURI qualifiedName: (NSString *) qualifiedName attributes: (NSDictionary *) attributeDict {
	[self appendCachedText];

	DHC_LOG(@"Starting element %@, namespace %@, prefix %@", elementName, namespaceURI, qualifiedName);

	//Create the new element and add it to the current element's list of properties.
	//Then set it as the current one.
	[self createNodeWithName: elementName];
	if (rootNode == nil) {
		rootNode = [currentNode retain];
	}

	//populate attributes.
	for (id key in attributeDict) {
		DHC_LOG(@"Adding attribute %@ = %@", key, [attributeDict objectForKey: key]);
		[currentNode setAttribute: key value:[attributeDict objectForKey: key]];
	}

	//populate namespace prefix.
	NSArray *qualifiedNameTokens = [qualifiedName componentsSeparatedByString: @":"];
	if ([qualifiedNameTokens count] > 1) {
		currentNode.prefix = [qualifiedNameTokens objectAtIndex: 0];
	}

	//Add namespace from cache.
	for (NSString *key in[namespaceCache keyEnumerator]) {
		NSString *url = [namespaceCache valueForKey: key];
		if ([@"" isEqualToString: key]) {
			//Root schemas will have a zero length string prefix.
			DHC_LOG(@"Setting root schema %@", url);
			currentNode.defaultSchema = url;
		} else {
			DHC_LOG(@"Adding schema %@:%@", key, url);
			[currentNode addNamespace: url prefix: key];
		}
	}
	[namespaceCache removeAllObjects];
}

- (void) parser: (NSXMLParser *) parser didEndElement: (NSString *) elementName namespaceURI: (NSString *) namespaceURI qualifiedName: (NSString *) qName {

	[self appendCachedText];

	DHC_LOG(@"Ending element %@ with %i sub nodes", elementName, [currentNode countNodes]);

	//Make the parent the current element. This works with the top level because it will have a
	//nil parent, but sending messages to nil is valid so the retain works.
	XmlNode *parent = [currentNode parentNode];
	[currentNode release];
	currentNode = [parent retain];
}

/*
 *	This occurs when a namespace declaration occurs, but is triggered before the element start so
 *	we have to cache the namespaces.
 */
- (void) parser: (NSXMLParser *) parser didStartMappingPrefix: (NSString *) prefix toURI: (NSString *) namespaceURI {
	//ignore namespace events triggered by switching to default namespace.
	if ([@"" isEqualToString: prefix] &&[@"" isEqualToString: namespaceURI]) {
		return;
	}

	DHC_LOG(@"Found namespace prefix %@ for url %@", prefix, namespaceURI);
	if (namespaceCache == nil) {
		namespaceCache = [[NSMutableDictionary alloc] init];
	}
	[namespaceCache setValue: namespaceURI forKey: prefix];
}

- (void) parser: (NSXMLParser *) parser foundCharacters: (NSString *) string {
	//bail if the string is blank.
	NSString *trimedString = DHC_TRIM(string);
	if ([trimedString length] == 0) {
		return;
	}

	DHC_LOG(@"Receiving characters: %@", string);

	//Create the cache if needed.
	if (valueCache == nil) {
		valueCache = [[NSMutableString alloc] initWithString: trimedString];
		return;
	}

	//Otherwise append the data.
	[valueCache appendString: @" "];
	[valueCache appendString: trimedString];
}

- (void) parser: (NSXMLParser *) parser parseErrorOccurred: (NSError *) parseError {
	DHC_LOG(@"Parse Error: %@", parseError);
	self.error = parseError;
}

- (void) parser: (NSXMLParser *) parser validationErrorOccurred: (NSError *) validationError {
	DHC_LOG(@"Validation Error: %@", validationError);
	self.error = validationError;
}

- (void) dealloc {
	self.error = nil;
	DHC_DEALLOC(namespaceCache);
	DHC_DEALLOC(currentNode);
	DHC_DEALLOC(valueCache);
	DHC_DEALLOC(rootNode);
	[super dealloc];
}

@end