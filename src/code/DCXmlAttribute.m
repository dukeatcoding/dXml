//
//  XmlAttribute.m
//  dXml
//
//  Created by Derek Clarkson on 30/10/09.
//  Copyright 2009 Derek Clarkson. All rights reserved.
//

#import "DCXmlAttribute.h"
#import "dXml.h"

@implementation DCXmlAttribute

@synthesize name;
@synthesize value;

-(DCXmlAttribute *) initWithName: (NSString *) aName value: (NSString *) aValue {
	self = [super init];
	if (self) {
		name = [aName retain];
		self.value = aValue;
	}
	return self;
}

- (void) appendToXmlString: (NSMutableString *) xml {
	[xml appendFormat:@" %@=\"%@\"", name, value];
}

-(void) dealloc {
	self.value = nil;
	DHC_DEALLOC(name);
	[super dealloc];
}

@end