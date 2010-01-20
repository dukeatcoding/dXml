//
//  NoSecurity.m
//  dXml
//
//  Created by Derek Clarkson on 4/12/09.
//  Copyright 2009 Derek Clarkson. All rights reserved.
//

#import "DCNoSecurity.h"
#import "dXml.h"

@implementation DCNoSecurity

-(void) secureSoapMessage:(DCXmlDocument *) soapMessage {
	DHC_LOG (@"NO security - leaving soap message untouched.");
}

@end
