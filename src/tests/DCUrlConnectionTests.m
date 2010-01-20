//
//  UrlConnectionTests.m
//  dXml
//
//  Created by Derek Clarkson on 7/12/09.
//  Copyright 2009 Derek Clarkson. All rights reserved.
//
#import "GHUnit.h"
#import "DCUrlConnection.h"

@interface DCUrlConnectionTests : GHTestCase
{
}
@end

@implementation DCUrlConnectionTests

- (void) testInitWithUrl {
	DCUrlConnection *connection = [[[DCUrlConnection alloc] initWithUrl: @"abc"] autorelease];
	GHAssertNotNil(connection, @"Constructor returned nil object");
}

- (void) testCreateWithUrl {
	DCUrlConnection *connection = [DCUrlConnection createWithUrl: @"abc"];
	GHAssertNotNil(connection, @"Create returned nil object");
}

@end