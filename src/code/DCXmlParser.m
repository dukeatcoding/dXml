//
//  XmlParser.m
//  dXml
//
//  Created by Derek Clarkson on 25/10/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "DCXmlParser.h"
#import "dXml.h"
#import "DCXmlNode.h"

//Private method category used to hide methods (almost).
@interface DCXmlParser ()
-(DCXmlNode *) parseWithDelegate:(DCXmlSubtreeParserDelegate *) delegate returnNodeSelector:(SEL) message errorVar:(NSError * *) aErrorVar;
@end

@implementation DCXmlParser
+ (DCXmlParser *) parserWithXml:(NSString *) xml {
	DHC_LOG(@"Being asked to parse: %@", xml);
	return [[[DCXmlParser alloc] initWithXml: xml] autorelease];
}

+ (DCXmlParser *) parserWithData: (NSData *) data {
	return [[[DCXmlParser alloc] initWithData: data] autorelease];
}

+ (DCXmlParser *) parserWithUrl: (NSURL *) url {
	return [[[DCXmlParser alloc] initWithUrl: url] autorelease];
}

- (DCXmlParser *) initWithXml: (NSString *) xml {
	return [self initWithData:DHC_STRING_TO_DATA(xml)];
}

- (DCXmlParser *) initWithData: (NSData *) data {
	self = [super init];
	if (self) {
		parser = [[NSXMLParser alloc] initWithData: data];
	}
	return self;
}

- (DCXmlParser *) initWithUrl: (NSURL *) url {
	self = [super init];
	if (self) {
		parser = [[NSXMLParser alloc] initWithContentsOfURL: url];
	}
	return self;
}

- (DCXmlDocument *) parse:(NSError * *) aErrorVar {
	DHC_LOG(@"parsing a Document, error handing %@", DHC_PRETTY_BOOL(aErrorVar != NULL));
	DCXmlSubtreeParserDelegate *delegate = [[[DCXmlDocumentParserDelegate alloc] init] autorelease];
	return (DCXmlDocument *)[self parseWithDelegate:delegate returnNodeSelector:@selector(document) errorVar:aErrorVar];
}

- (DCXmlNode *) parseSubtree:(NSError * *) aErrorVar {
	DHC_LOG(@"parsing a Subtree, error handing %@", DHC_PRETTY_BOOL(aErrorVar != NULL));
	DCXmlSubtreeParserDelegate *delegate = [[[DCXmlSubtreeParserDelegate alloc] init] autorelease];
	return [self parseWithDelegate:delegate returnNodeSelector:@selector(rootNode) errorVar:aErrorVar];
}

-(DCXmlNode *) parseWithDelegate:(DCXmlSubtreeParserDelegate *) delegate returnNodeSelector:(SEL) message errorVar:(NSError * *) aErrorVar {

	DHC_LOG(@"Parsing, error handing %@", DHC_PRETTY_BOOL(aErrorVar != NULL));

	//Not worth processing xml if cannot understand selector.
	assert([delegate respondsToSelector:message]);

	//Now parse.
	parser.shouldProcessNamespaces = YES;
	parser.shouldReportNamespacePrefixes = YES;
	[parser setDelegate: delegate];
	[parser parse];
	if (delegate.error != nil) {
		DHC_LOG(@"Delegate has an error");
		if (aErrorVar != NULL) {
			DHC_LOG(@"Returning error from delegate");
			*aErrorVar = delegate.error;
		}
		else{
			DHC_LOG(@"Ignoring it");
		}
		return nil;
	}

	DHC_LOG(@"Returning value from delegate");
	return (DCXmlNode *)[delegate performSelector:message];
}

- (void) dealloc {
	DHC_DEALLOC(parser);
	[super dealloc];
}

@end