//
//  UseridPasswordSecurity.m
//  dXml
//
//  Created by Derek Clarkson on 4/12/09.
//  Copyright 2009 Derek Clarkson. All rights reserved.
//

#import "UseridPasswordSecurity.h"
#import "XmlDocument.h"
#import "dXml.h"

@implementation UseridPasswordSecurity
- (UseridPasswordSecurity *) initWithUserid: (NSString *) aUserid password: (NSString *) aPassword {
	self = [super init];
	if (self) {
		userid = [aUserid retain];
		password = [aPassword retain];
	}
	return self;
}

- (void) secureSoapMessage: (XmlDocument *) soapMessage {
	DHC_LOG(@"Userid password security - adding header ws-security elements.");

	XmlNode *header = [soapMessage xmlNodeWithName: @"Header"];

	XmlNode *security = [header addXmlNodeWithName: @"Security" prefix: WSSECURITY_PREFIX];
	[security addNamespace: WSSECURITY_URL prefix: WSSECURITY_PREFIX];

	XmlNode *usernameToken = [security addXmlNodeWithName: @"UsernameToken" prefix: WSSECURITY_PREFIX];
	[usernameToken addNamespace: WSSECURITY_UTILITY_URL prefix: WSSECURITY_UTILITY_PREFIX];
	[usernameToken setAttribute: @"wsu:Id" value: @"UsernameToken-2"];

	[usernameToken addXmlNodeWithName: @"Username" prefix: WSSECURITY_PREFIX value: userid];

	XmlNode *passwordElement = [usernameToken addXmlNodeWithName: @"Password" prefix: WSSECURITY_PREFIX value: password];
	[passwordElement setAttribute: @"Type" value: WSSECURITY_USERNAME_TOKEN_PROFILE_PASSWORDTEXT];
}

- (void) dealloc {
	DHC_DEALLOC(userid);
	DHC_DEALLOC(password);
	[super dealloc];
}

@end