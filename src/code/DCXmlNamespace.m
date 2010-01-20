//
//  XmlNamespace.m
//  dXml
//
//  Created by Derek Clarkson on 24/11/09.
//  Copyright 2009 Derek Clarkson. All rights reserved.
//

#import "DCXmlNamespace.h"
#import "dXml.h"


@implementation DCXmlNamespace

@synthesize url;
@synthesize prefix;

-(DCXmlNamespace *) initWithUrl: (NSString *) aUrl prefix: (NSString *) aPrefix {
	self = [super init];
	if (self) {
		url = [aUrl retain];
		prefix = [aPrefix retain];
	}
	return self;
}

- (void) appendToXmlString: (NSMutableString *) xml {
	[xml appendFormat:@" xmlns:%@=\"%@\"", prefix, url];
}

-(void) dealloc {
	DHC_DEALLOC(url);
	DHC_DEALLOC(prefix);
	[super dealloc];
}

@end
