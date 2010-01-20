//
//  SoapWebservice.m
//  dXml
//
//  Created by Derek Clarkson on 26/11/09.
//  Copyright 2009 Derek Clarkson. All rights reserved.
//

#import "DCSoapWebServiceConnection.h"
#import "NSError+SoapFault.h"

@interface DCSoapWebServiceConnection ()
- (DCWebServiceResponse *) parseResponseWithData:(NSData *)data errorVar:(NSError **)aErrorVar;
@end

@implementation DCSoapWebServiceConnection

@synthesize soapAction;
@synthesize securityType;

- (DCSoapWebServiceConnection *) init {
	self = [super init];
	if (self) {
		securityType = NONE;
	}
	return self;
}

+ (DCSoapWebServiceConnection *) createWithUrl:(NSString *)aServerUrl {
	return [self createWithUrl:aServerUrl soapAction:nil];
}

+ (DCSoapWebServiceConnection *) createWithUrl:(NSString *)aServerUrl soapAction:(NSString *)aSoapAction {
	DHC_LOG(@"Initialising with Url %@ and Action %@", aServerUrl, aSoapAction);
	DCSoapWebServiceConnection * service = [[(DCSoapWebServiceConnection *)[DCSoapWebServiceConnection alloc] initWithUrl:aServerUrl] autorelease];
	service.soapAction = aSoapAction;
	return service;
}

- (DCWebServiceResponse *) postXmlStringPayload:(NSString *)aBody errorVar:(NSError **)aErrorVar {

	// Setup a parser and attempt to parse the supplied xml.
	DHC_LOG(@"Parsing xml into document model, error handing %@, xml = %@", DHC_PRETTY_BOOL(aErrorVar == NULL), aBody);
	DCXmlParser * parser = [DCXmlParser parserWithXml:aBody];
	DCXmlNode * subtree = [parser parseSubtree:aErrorVar];

	// If there is no subtree returned then look for errors.
	if (subtree == nil) {
		if (aErrorVar != NULL && aErrorVar == nil) {

			// Cannot remember under what circumstances I saw a nil subtree with no error.
			*aErrorVar = [NSError errorWithDomain:@"x" code:SoapWebServiceConnectionNilResponse userInfo:nil];
			DHC_LOG(@"Generating error %@", aErrorVar);
		}
		return nil;
	}

	// Now forward to the main post routine.
	DHC_LOG(@"Forwarding to postXmlNodePayload");
	return [self postXmlNodePayload:subtree errorVar:aErrorVar];
}

- (DCWebServiceResponse *) postXmlNodePayload:(DCXmlNode *)aBody errorVar:(NSError **)aErrorVar {

	// First assemble the message
	DCXmlDocument * soapMsg = [self createBasicSoapDM];

	[[soapMsg xmlNodeWithName:@"Body"] addNode:aBody];

	// Now hand it to the security code.
	DCSecurity * security = [DCSecurity createSecurityWithUserid:userid password:password];
	NSObject <DCSecurityModel> * securer = [security createSecurityModelOfType:securityType];
	[securer secureSoapMessage:soapMsg];

	DHC_LOG(@"Action: %@", self.soapAction);
	DHC_LOG(@"Compiled soap message:\n%@", [soapMsg asPrettyXmlString]);

	[self setHeaderValue:self.soapAction forKey:@"SOAPAction"];

	// Post the request to the server.
	NSData * data = [self post:[soapMsg asXmlString] errorVar:aErrorVar];

	// And check for errors.
	if (data == nil) {
		DHC_LOG(@"Error detected from posting to server %@", aErrorVar);
		return nil;
	}

	// Parse the data through the xml processor and return a document.
	return [self parseResponseWithData:data errorVar:aErrorVar];
}

- (DCWebServiceResponse *) parseResponseWithData:(NSData *)data errorVar:(NSError **)aErrorVar {

	DCXmlParser * parser = [DCXmlParser parserWithData:data];
	DCXmlDocument * document = [parser parse:aErrorVar];

	if (document == nil) {
		DHC_LOG(@"Error detected parsing response into document model, returning nil");
		return nil;
	}

	// Add code to find a fault and generate an error.
	DCWebServiceResponse * response = [[[DCWebServiceResponse alloc] initWithDocument:document] autorelease];

	// Handle soap faults.
	if ([response isSoapFault]) {
		if (aErrorVar != NULL) {
			*aErrorVar = [NSError errorWithSoapResponse:response];
		}
		return nil;
	}

	return response;

}


- (void) dealloc {
	DHC_DEALLOC(userid);
	DHC_DEALLOC(password);
	[super dealloc];
}

@end