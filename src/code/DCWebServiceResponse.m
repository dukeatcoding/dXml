//
//  WebServiceResponse.m
//  dXml
//
//  Created by Derek Clarkson on 26/11/09.
//  Copyright 2009 Derek Clarkson. All rights reserved.
//

#import "DCWebServiceResponse.h"

@implementation DCWebServiceResponse

@synthesize document;

- (DCWebServiceResponse *) initWithDocument:(DCXmlDocument *)aDocument {
	self = [super init];
	if (self) {
		document = [aDocument retain];
	}
	return self;
}

- (DCXmlNode *) bodyElement {
	return [document xmlNodeWithName:@"Body"];
}

- (DCXmlNode *) bodyContent {
	return [[document xmlNodeWithName:@"Body"] nodeAtIndex:0];
}

- (NSEnumerator *) bodyContents {
	return [[document xmlNodeWithName:@"Body"] nodes];
}

- (BOOL) isSoapFault {
	return [[self bodyElement] hasXmlNodeWithName:@"Fault"];
}

- (void) dealloc {
	[document release];
	[super dealloc];
}

@end