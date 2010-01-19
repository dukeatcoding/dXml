//
//  SoapWebservice.m
//  dXml
//
//  Created by Derek Clarkson on 26/11/09.
//  Copyright 2009 Derek Clarkson. All rights reserved.
//

#import "SoapWebServiceConnection.h"

@interface SoapWebServiceConnection ()
-(WebServiceResponse *) parseResponseWithData:(NSData *) data errorVar:(NSError * *) aErrorVar;
@end

@implementation SoapWebServiceConnection

@synthesize soapAction;
@synthesize securityType;

- (SoapWebServiceConnection *) init {
	self = [super init];
	if (self) {
		securityType = NONE;
	}
	return self;
}

+ (SoapWebServiceConnection *) createWithUrl: (NSString *) aServerUrl {
	return [self createWithUrl: aServerUrl soapAction: nil];
}

+ (SoapWebServiceConnection *) createWithUrl: (NSString *) aServerUrl soapAction: (NSString *) aSoapAction {
	DHC_LOG(@"Initialising with Url %@ and Action %@", aServerUrl, aSoapAction);
	SoapWebServiceConnection *service = [[(SoapWebServiceConnection *)[SoapWebServiceConnection alloc] initWithUrl: aServerUrl] autorelease];
	service.soapAction = aSoapAction;
	return service;
}

- (WebServiceResponse *) postXmlStringPayload: (NSString *) aBody errorVar:(NSError * *) aErrorVar {

	//Setup a parser and attempt to parse the supplied xml.
	DHC_LOG(@"Parsing xml into document model, error handing %@, xml = %@", DHC_PRETTY_BOOL(aErrorVar == NULL), aBody);
	XmlParser *parser = [XmlParser parserWithXml: aBody];
	XmlNode *subtree = [parser parseSubtree:aErrorVar];

	// If there is no subtree returned then look for errors.
	if(subtree == nil) {
		if (aErrorVar != NULL && aErrorVar == nil) {

			// Cannot remember under what circumstances I saw a nil subtree with no error.
			*aErrorVar = [NSError errorWithDomain:SOAP_WEB_SERVICE_CONNECTION_DOMAIN code:SoapWebServiceConnectionNilResponse userInfo:nil];
			DHC_LOG(@"Generating error %@", aErrorVar);
		}
		return nil;
	}

	// Now forward to the main post routine.
	DHC_LOG(@"Forwarding to postXmlNodePayload");
	return [self postXmlNodePayload:subtree errorVar:aErrorVar];
}

- (WebServiceResponse *) postXmlNodePayload: (XmlNode *) aBody errorVar:(NSError * *) aErrorVar {

	//First assemble the message
	XmlDocument *soapMsg = [self createBasicSoapDM];
	[[soapMsg xmlNodeWithName: @"Body"] addNode: aBody];

	//Now hand it to the security code.
	Security *security = [Security createSecurityWithUserid: userid password: password];
	NSObject <SecurityModel> *securer = [security createSecurityModelOfType: securityType];
	[securer secureSoapMessage: soapMsg];

	DHC_LOG(@"Action: %@", self.soapAction);
	DHC_LOG(@"Compiled soap message:\n%@", [soapMsg asPrettyXmlString]);

	[self setHeaderValue: self.soapAction forKey: @"SOAPAction"];

	//Post the request to the server.
	NSData *data = [self post:[soapMsg asXmlString] errorVar:aErrorVar];

	// And check for errors.
	if (data == nil) {
		DHC_LOG(@"Error detected from posting to server %@", aErrorVar);
		return nil;
	}

	//Parse the data through the xml processor and return a document.
	return [self parseResponseWithData:data errorVar:aErrorVar];
}

-(WebServiceResponse *) parseResponseWithData:(NSData *) data errorVar:(NSError * *) aErrorVar {

	XmlParser *parser = [XmlParser parserWithData: data];
	XmlDocument *document = [parser parse:aErrorVar];
	if (document == nil) {
		DHC_LOG(@"Error detected parsing response into document model, returning nil");
		return nil;
	}

	//Add code to find a fault and generate an error.
	WebServiceResponse *response = [[[WebServiceResponse alloc] initWithDocument: document] autorelease];
	if ([[response bodyElement] hasXmlNodeWithName:@"Fault"]) {
		if (aErrorVar != NULL) {
			XmlNode *fault = [response bodyContent];
			NSString *message = [fault xmlNodeWithName:@"faultstring"].value;
			NSString *code = [fault xmlNodeWithName:@"faultcode"].value;
			NSMutableDictionary *dic = [NSMutableDictionary dictionary];
			[dic setValue:code forKey:SOAP_FAULT_CODE_KEY];
			[dic setValue:message forKey:SOAP_FAULT_MESSAGE_KEY];
			*aErrorVar = [NSError errorWithDomain:SOAP_WEB_SERVICE_CONNECTION_DOMAIN code:SoapWebServiceConnectionSoapFault userInfo:dic];
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