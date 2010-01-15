//
//  UrlConnectionTests.m
//  dXml
//
//  Created by Derek Clarkson on 7/12/09.
//  Copyright 2009 Derek Clarkson. All rights reserved.
//
#import "GHUnit.h"
#import "UrlConnection.h"

@interface UrlConnectionTests : GHTestCase
{
}
@end

@implementation UrlConnectionTests

- (void) testInitWithUrl {
	UrlConnection *connection = [[[UrlConnection alloc] initWithUrl: @"abc"] autorelease];
	GHAssertNotNil(connection, @"Constructor returned nil object");
}

- (void) testCreateWithUrl {
	UrlConnection *connection = [UrlConnection createWithUrl: @"abc"];
	GHAssertNotNil(connection, @"Create returned nil object");
}

@end