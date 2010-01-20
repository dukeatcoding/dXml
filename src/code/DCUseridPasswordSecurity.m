//
//  UseridPasswordSecurity.m
//  dXml
//
//  Created by Derek Clarkson on 4/12/09.
//  Copyright 2009 Derek Clarkson. All rights reserved.
//

#import "DCUseridPasswordSecurity.h"
#import "DCXmlDocument.h"
#import "dXml.h"

@implementation DCUseridPasswordSecurity
- (DCUseridPasswordSecurity *) initWithUserid: (NSString *) aUserid password: (NSString *) aPassword {
	self = [super init];
	if (self) {
		userid = [aUserid retain];
		password = [aPassword retain];
	}
	return self;
}

- (void) secureSoapMessage: (DCXmlDocument *) soapMessage {
	DHC_LOG(@"Userid password security - adding header ws-security elements.");

	DCXmlNode *header = [soapMessage xmlNodeWithName: @"Header"];

	DCXmlNode *security = [header addXmlNodeWithName: @"Security" prefix: WSSECURITY_PREFIX];
	[security addNamespace: WSSECURITY_URL prefix: WSSECURITY_PREFIX];

	DCXmlNode *usernameToken = [security addXmlNodeWithName: @"UsernameToken" prefix: WSSECURITY_PREFIX];
	[usernameToken addNamespace: WSSECURITY_UTILITY_URL prefix: WSSECURITY_UTILITY_PREFIX];
	[usernameToken setAttribute: @"wsu:Id" value: @"UsernameToken-2"];

	[usernameToken addXmlNodeWithName: @"Username" prefix: WSSECURITY_PREFIX value: userid];

	DCXmlNode *passwordElement = [usernameToken addXmlNodeWithName: @"Password" prefix: WSSECURITY_PREFIX value: password];
	[passwordElement setAttribute: @"Type" value: WSSECURITY_USERNAME_TOKEN_PROFILE_PASSWORDTEXT];
}

- (void) dealloc {
	DHC_DEALLOC(userid);
	DHC_DEALLOC(password);
	[super dealloc];
}

@end