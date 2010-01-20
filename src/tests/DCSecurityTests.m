//
//  SecurityFactoryTests.m
//  dXml
//
//  Created by Derek Clarkson on 4/12/09.
//  Copyright 2009 Derek Clarkson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GHUnit.h"
#import "DCXmlDocument.h"
#import "DCSecurity.h"
#import "DCNoSecurity.h"
#import "DCUseridPasswordSecurity.h"

@interface DCSecurityTests : GHTestCase
{}

@end

@implementation DCSecurityTests

- (void) testCreatesNoSecurity {
	DCSecurity *security= [DCSecurity createSecurityWithUserid: @"userid" password: @"password"];
	id model = [security createSecurityModelOfType: NONE];
	GHAssertTrue([model isKindOfClass:[DCNoSecurity class]], @"Incorrect security class returned.");
}

- (void) testCreatesUseridPasswordSecurity {
	DCSecurity *security = [DCSecurity createSecurityWithUserid: @"userid" password: @"password"];
	id model = [security createSecurityModelOfType: BASIC_USERID_PASSWORD];
	GHAssertTrue([model isKindOfClass:[DCUseridPasswordSecurity class]], @"Incorrect security class returned.");
}

@end