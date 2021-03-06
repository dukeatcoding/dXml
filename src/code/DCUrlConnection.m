//
//  UrlConnection.m
//  dXml
//  Manages a connection to a server and it's responses.
//  Created by Derek Clarkson on 7/12/09.
//  Copyright 2009 Derek Clarkson. All rights reserved.
//

#import "DCUrlConnection.h"
#import "dXml.h"

//Private methods.
@interface DCUrlConnection ()
- (NSMutableURLRequest *) createRequestWithMsg: (NSString *) aMsg;
- (void) addHeadersToRequest: (NSURLRequest *) theRequest;
- (void) executeEventsUntilAllDataReceived;
@end

@implementation DCUrlConnection

@synthesize allowSelfSignedCertificates;
@synthesize storeCredentials;
@synthesize serverUrl;

- (DCUrlConnection *) initWithUrl: (NSString *) aUrl {
	self = [super init];
	if (self) {
		serverUrl = [aUrl retain];
		headers = [[NSMutableDictionary alloc] init];
		self.allowSelfSignedCertificates = NO;
		self.storeCredentials = NO;
	}
	return self;
}

+ (DCUrlConnection *) createWithUrl: (NSString *) aUrl {
	return [[[DCUrlConnection alloc] initWithUrl: aUrl] autorelease];
}

-(void) setUsername: (NSString *) aUsername password:(NSString *) aPassword {
	[aUsername retain];
	[aPassword retain];
	DHC_DEALLOC(userid);
	DHC_DEALLOC(password);
	userid = aUsername;
	password = aPassword;
}


- (NSData *) post: (NSString *) bodyContent errorVar:(NSError * *) aErrorVar {
	DHC_LOG(@"Sending message to server on Url: %@", self.serverUrl);

	NSMutableURLRequest *request = [self createRequestWithMsg: bodyContent];
	[request setHTTPMethod: @"POST"];
	[self addHeadersToRequest: request];

	NSURLConnection *connection = [NSURLConnection connectionWithRequest: request delegate: self];
	if (connection == nil) {
		DHC_LOG(@"Nil connection object returned");
		if (aErrorVar != NULL) {
			*aErrorVar = [NSError errorWithDomain:URL_CONNECTION_DOMAIN code:UrlConnectionErrorNilConnection userInfo:nil];
			DHC_LOG(@"Returning error %@", aErrorVar);
		}
		return nil;
	}

	//Clear data to allow for repeat calls.
	DHC_DEALLOC(delegateError);
	DHC_DEALLOC(responseData);
	DHC_LOG(@"Creating new response data object");
	responseData = [[NSMutableData data] retain];
	responseReceived = NO;

	//Allow the run loop to process the url events.
	[self executeEventsUntilAllDataReceived];

	//Check for errors.
	if (delegateError != nil) {
		DHC_LOG(@"Detected delegate error %@", delegateError);
		if (aErrorVar != NULL) {
			*aErrorVar = delegateError;
			DHC_LOG(@"Returning error %@", delegateError);
		}
		return nil;
	}

	DHC_LOG(@"Returning responseData");
	return responseData;
}

/*
 * Executes events in the run loop until the flag is set indicating that all data has been received.
 */
- (void) executeEventsUntilAllDataReceived {
	NSDate *wayInTheFuture = [NSDate distantFuture];
	while (!responseReceived) {
		DHC_LOG(@"Firing run loop");
		[[NSRunLoop currentRunLoop] runMode: NSDefaultRunLoopMode beforeDate: wayInTheFuture];
	}
}

/*!
 * Appends additional headers supplied by the caller.
 */
- (void) addHeadersToRequest: (NSMutableURLRequest *) theRequest {
	NSString *value;
	for (NSString *key in[headers keyEnumerator]) {
		value = [headers valueForKey: key];
		DHC_LOG(@"Adding header %@: %@", key, value);
		[theRequest addValue: value forHTTPHeaderField: key];
	}
}

/*
 * Generates a MSURLRequest object setup to send the message.
 */
- (NSMutableURLRequest *) createRequestWithMsg: (NSString *) aMsg {
	NSURL *url = [NSURL URLWithString: self.serverUrl];
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL: url];

	//Standard headers.
	NSString *msgLength = [[NSNumber numberWithInteger:[aMsg length]] stringValue];
	[request addValue: msgLength forHTTPHeaderField: @"Content-Length"];
	[request addValue: @"text/xml; charset=utf-8" forHTTPHeaderField: @"Content-Type"];

	//Set the body and return.
	[request setHTTPBody:DHC_STRING_TO_DATA(aMsg)];
	return request;
}

- (void) setHeaderValue: (NSString *) value forKey: (NSString *) key {
	[headers setValue: value forKey: key];
}

- (void) dealloc {
	DHC_DEALLOC(delegateError);
	DHC_DEALLOC(serverUrl);
	DHC_DEALLOC(headers);
	DHC_DEALLOC(responseData);
	DHC_DEALLOC(userid);
	DHC_DEALLOC(password);
	[super dealloc];
}

@end