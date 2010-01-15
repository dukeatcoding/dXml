//
//  UseridPasswordSecurityTests.m
//  dXml
//
//  Created by Derek Clarkson on 4/12/09.
//  Copyright 2009 Derek Clarkson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GHUnit.h"
#import "XmlDocument.h"
#import "UseridPasswordSecurity.h"
#import "NSObject+SoapTemplates.h"
#import "dXml.h"

@interface UseridPasswordSecurityTests : GHTestCase
{}

@end

@implementation UseridPasswordSecurityTests

- (void) testDocumentIsModified {
	UseridPasswordSecurity *security = [[[UseridPasswordSecurity alloc] initWithUserid: @"userid" password: @"password"] autorelease];
	XmlDocument *document = [self createBasicSoapDM];
	
	[security secureSoapMessage: document];

	DHC_LOG(@"Built Xml:\n%@", [document asPrettyXmlString]);
	
	XmlNode *headerElement = [document xmlNodeWithName: @"Header"];
	XmlNode *securityElement = [headerElement xmlNodeWithName: @"Security"];
	GHAssertNotNil(securityElement, @"No security element found");
	XmlNode *usernameToken = [securityElement xmlNodeWithName: @"UsernameToken"];
	GHAssertNotNil(usernameToken, @"No securityToken element found");
	XmlNode *username = [usernameToken xmlNodeWithName: @"Username"];
	GHAssertNotNil(username, @"No userid element found");
	GHAssertEqualStrings(username.value, @"userid", @"userid not set");
	XmlNode *password = [usernameToken xmlNodeWithName: @"Password"];
	GHAssertNotNil(password, @"No password element found");
	GHAssertEqualStrings(password.value, @"password", @"password not set");
}

@end