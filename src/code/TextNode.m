//
//  TextNode.m
//  dXml
//
//  Created by Derek Clarkson on 13/12/09.
//  Copyright 2009 Derek Clarkson. All rights reserved.
//

#import "TextNode.h"


@implementation TextNode
@synthesize value;

-(TextNode *) initWithText:(NSString *) text {
	self = [super init];
	if (self) {
		self.value = text;
	}
	return self;
}

- (void) appendToXmlString: (NSMutableString *) xml prettyPrint: (bool) prettyPrint indentDepth: (int) indentDepth{
	[xml appendString:self.value];
}

@end
