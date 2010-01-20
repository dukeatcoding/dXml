//
//  UrlConnection+NSURLConnectionDelegateTests.m
//  dXml
//
//  Created by Derek Clarkson on 8/12/09.
//  Copyright 2009 Derek Clarkson. All rights reserved.
//
#import "GHUnit.h"
#import "DCUrlConnection.h"
#import <OCMock/OCMock.h>
#import "dXml.h"

@interface DCUrlConnection_NSURLConnectionDelegateTests : GHTestCase
{
}

@end

@implementation DCUrlConnection_NSURLConnectionDelegateTests

- (void) testRejectsSelfSignedCertificates {
	DCUrlConnection *conn = [DCUrlConnection createWithUrl: @"abc"];
	GHAssertFalse([conn connection: nil canAuthenticateAgainstProtectionSpace: nil], @"Expected can authenticate to be false");
}

- (void) testApprovesSelfSignedCertificates {
	DCUrlConnection *conn = [DCUrlConnection createWithUrl: @"abc"];
	conn.allowSelfSignedCertificates = YES;
	GHAssertTrue([conn connection: nil canAuthenticateAgainstProtectionSpace: nil], @"Expected can authenticate to be true");
}

- (void) testChallengeReturnsLogonDetails {
	//Mock the challenge and sender.
	id mockChallenge = [OCMockObject mockForClass:[NSURLAuthenticationChallenge class]];
	id mockSender = [OCMockObject mockForClass:[NSURLConnection class]];
	int zero = 0;
	[[[mockChallenge stub] andReturnValue: DHC_MOCK_VALUE(zero)] previousFailureCount];
	[[[mockChallenge stub] andReturn: mockSender] sender];
	[[mockSender expect] useCredential:[OCMArg any] forAuthenticationChallenge: mockChallenge];

	DCUrlConnection *conn = [DCUrlConnection createWithUrl: @"abc"];
	[conn setUsername: @"user" password: @"password"];
	[conn connection: mockSender didReceiveAuthenticationChallenge: mockChallenge];

	[mockSender verify];
	[mockChallenge verify];
}

- (void) testChallengeFailsIfAlreadyFailed {
	//Mock the challenge and sender.
	id mockChallenge = [OCMockObject mockForClass:[NSURLAuthenticationChallenge class]];
	id mockSender = [OCMockObject mockForClass:[NSURLConnection class]];
	int one = 1;
	[[[mockChallenge stub] andReturnValue: DHC_MOCK_VALUE(one)] previousFailureCount];
	[[[mockChallenge stub] andReturn: mockSender] sender];
	[[mockSender expect] cancelAuthenticationChallenge: mockChallenge];

	DCUrlConnection *conn = [DCUrlConnection createWithUrl: @"abc"];
	[conn setUsername: @"user" password: @"password"];
	[conn connection: mockSender didReceiveAuthenticationChallenge: mockChallenge];

	[mockSender verify];
	[mockChallenge verify];
}

@end