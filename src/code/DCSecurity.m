//
//  Security.m
//  dXml
//
//  Created by Derek Clarkson on 4/12/09.
//  Copyright 2009 Derek Clarkson. All rights reserved.
//

#import "DCSecurity.h"
#import "dXml.h"
#import "DCNoSecurity.h"
#import "DCUseridPasswordSecurity.h"

@implementation DCSecurity
- (DCSecurity *) initWithUserid: (NSString *) aUserid password: (NSString *) aPassword {
	self = [super init];
	if (self) {
		userid = [aUserid retain];
		password = [aPassword retain];
	}
	return self;
}

- (NSObject <DCSecurityModel> *) createSecurityModelOfType: (SECURITYTYPE) securityType {
	switch (securityType) {
	case NONE:
		return [[[DCNoSecurity alloc] init] autorelease];

	case BASIC_USERID_PASSWORD:
		return [[[DCUseridPasswordSecurity alloc] initWithUserid: userid password: password] autorelease];

	default:
		return nil;
	}
}

+ (DCSecurity *) createSecurityWithUserid: (NSString *) aUserid password: (NSString *) aPassword {
	return [[[DCSecurity alloc] initWithUserid: aUserid password: aPassword] autorelease];
}

- (void) dealloc {
	DHC_DEALLOC(userid);
	DHC_DEALLOC(password);
	[super dealloc];
}

@end