//
//  UseridPasswordSecurityTests.m
//  dXml
//
//  Created by Derek Clarkson on 4/12/09.
//  Copyright 2009 Derek Clarkson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GHUnit.h"
#import "DCXmlDocument.h"
#import "DCUseridPasswordSecurity.h"
#import "NSObject+SoapTemplates.h"
#import "dXml.h"

@interface UseridPasswordSecurityTests : GHTestCase
{}

@end

@implementation UseridPasswordSecurityTests

- (void) testDocumentIsModified {
	DCUseridPasswordSecurity *security = [[[DCUseridPasswordSecurity alloc] initWithUserid: @"userid" password: @"password"] autorelease];
	DCXmlDocument *document = [self createBasicSoapDM];
	
	[security secureSoapMessage: document];

	DHC_LOG(@"Built Xml:\n%@", [document asPrettyXmlString]);
	
	DCXmlNode *headerElement = [document xmlNodeWithName: @"Header"];
	DCXmlNode *securityElement = [headerElement xmlNodeWithName: @"Security"];
	GHAssertNotNil(securityElement, @"No security element found");
	DCXmlNode *usernameToken = [securityElement xmlNodeWithName: @"UsernameToken"];
	GHAssertNotNil(usernameToken, @"No securityToken element found");
	DCXmlNode *username = [usernameToken xmlNodeWithName: @"Username"];
	GHAssertNotNil(username, @"No userid element found");
	GHAssertEqualStrings(username.value, @"userid", @"userid not set");
	DCXmlNode *password = [usernameToken xmlNodeWithName: @"Password"];
	GHAssertNotNil(password, @"No password element found");
	GHAssertEqualStrings(password.value, @"password", @"password not set");
}

@end