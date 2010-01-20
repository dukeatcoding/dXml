//
//  UrlConnection+NSURLConnectionDelegate.h
//  dXml
//
//  Created by Derek Clarkson on 7/12/09.
//  Copyright 2009 Derek Clarkson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DCUrlConnection.h"

/**
  * This category adds further functionality to a DCUrlConnection. The main purpose is to break the code base for
  * DCUrlConnection up into managable units. In this case we have a collection of delegate methods from NSURLConnection
  * which handle the responses from a url.
  * 
  * There is not a lot of code
  * here. Most of it is around two things: connection:didReceiveData: which is used to assemble the text contained
  * within an xml tag. And
  * connection:canAuthenticateAgainstProtectionSpace: which handles certificates and ssl security.
  */
@interface DCUrlConnection (NSURLConnectionDelegate)

/** \name Delegate methods 
 * These methods are called b NSURLConnection during the interaction with a url.
 */
/** &nbsp; */
- (NSURLRequest *) connection: (NSURLConnection *) connection willSendRequest: (NSURLRequest *) request redirectResponse: (NSURLResponse *) response;

/** &nbsp; */
- (BOOL) connection: (NSURLConnection *) connection canAuthenticateAgainstProtectionSpace: (NSURLProtectionSpace *) protectionSpace;

/** &nbsp; */
- (NSInputStream *) connection: (NSURLConnection *) connection needNewBodyStream: (NSURLRequest *) request;

/** &nbsp; */
- (void) connection: (NSURLConnection *) connection didReceiveAuthenticationChallenge: (NSURLAuthenticationChallenge *) challenge;

/** &nbsp; */
- (void) connection: (NSURLConnection *) connection didCancelAuthenticationChallenge: (NSURLAuthenticationChallenge *) challenge;

/** &nbsp; */
- (BOOL) connectionShouldUseCredentialStorage: (NSURLConnection *) connection;

/** &nbsp; */
- (void) connection: (NSURLConnection *) connection didReceiveResponse: (NSURLResponse *) response;

/** &nbsp; */
- (void) connection: (NSURLConnection *) connection didReceiveData: (NSData *) data;

/** &nbsp; */
- (void) connection: (NSURLConnection *) connection didSendBodyData: (NSInteger) bytesWritten totalBytesWritten: (NSInteger) totalBytesWritten totalBytesExpectedToWrite: (NSInteger) totalBytesExpectedToWrite;

/** &nbsp; */
- (void) connectionDidFinishLoading: (NSURLConnection *) connection;

/** &nbsp; */
- (void) connection: (NSURLConnection *) connection didFailWithError: (NSError *) error;

/** &nbsp; */
- (NSCachedURLResponse *) connection: (NSURLConnection *) connection willCacheResponse: (NSCachedURLResponse *) cachedResponse;

@end