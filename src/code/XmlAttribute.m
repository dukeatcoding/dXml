//
//  XmlAttribute.m
//  dXml
//
//  Created by Derek Clarkson on 30/10/09.
//  Copyright 2009 Derek Clarkson. All rights reserved.
//

#import "XmlAttribute.h"
#import "dXml.h"

@implementation XmlAttribute

@synthesize name;
@synthesize value;

-(XmlAttribute *) initWithName: (NSString *) aName value: (NSString *) aValue {
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