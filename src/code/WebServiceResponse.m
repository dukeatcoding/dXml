//
//  WebServiceResponse.m
//  dXml
//
//  Created by Derek Clarkson on 26/11/09.
//  Copyright 2009 Derek Clarkson. All rights reserved.
//

#import "WebServiceResponse.h"

@implementation WebServiceResponse

@synthesize document;

- (WebServiceResponse *) initWithDocument: (XmlDocument *) aDocument {
	self = [super init];
	if (self) {
		document = [aDocument retain];
	}
	return self;
}

- (XmlNode *) bodyElement {
	return [document xmlNodeWithName: @"Body"];
}

- (XmlNode *) bodyContent {
	return [[document xmlNodeWithName: @"Body"] nodeAtIndex: 0];
}

- (NSEnumerator *) bodyContents {
	return [[document xmlNodeWithName: @"Body"] nodes];
}

- (void) dealloc {
	[document release];
	[super dealloc];
}

@end