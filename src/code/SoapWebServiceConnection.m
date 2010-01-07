////  SoapWebservice.m//  dXml////  Created by Derek Clarkson on 26/11/09.//  Copyright 2009 Derek Clarkson. All rights reserved.//#import "SoapWebServiceConnection.h"@interface SoapWebServiceConnection ()- (WebServiceResponse *) createWebServiceResponseWithDocument: (XmlDocument *) document;@end@implementation SoapWebServiceConnection@synthesize soapAction;@synthesize securityType;- (SoapWebServiceConnection *) init {	self = [super init];	if (self) {		securityType = NONE;	}	return self;}/** * Creates autorelease web service instances for the specified url. */+ (SoapWebServiceConnection *) createWithUrl: (NSString *) aServerUrl {	return [self createWithUrl: aServerUrl soapAction: nil];}/** * Creates autorelease web service instances for the specified url and action. */+ (SoapWebServiceConnection *) createWithUrl: (NSString *) aServerUrl soapAction: (NSString *) aSoapAction {	DHC_LOG(@"Initialising with Url %@ and Action %@", aServerUrl, aSoapAction);	SoapWebServiceConnection *service = [[[SoapWebServiceConnection alloc] initWithUrl: aServerUrl] autorelease];	service.soapAction = aSoapAction;	return service;}/* * Embeds the passed xml string inside a soap request and sends it to the url. */- (WebServiceResponse *) postXmlStringPayload: (NSString *) aBody {	XmlParser *parser = [XmlParser parserWithXml: aBody];	XmlNode * subtree = [parser parseSubtree];	if (subtree == nil) {		DHC_LOG(@"Nil subtree returned from parsing:\n%@", aBody);		NSException *exception = [XmlException exceptionWithName: @"SubtreeNilResponseException" reason: @"The XML produced a nil response from the subtree parser." userInfo: nil];		@throw exception;	}	return [self postXmlNodePayload:subtree];}/* * Embeds the passed XmlNode in a soap request and sends it to the url. */- (WebServiceResponse *) postXmlNodePayload: (XmlNode *) aBody {	//First assemble the message	XmlDocument *soapMsg = [self createBasicSoapDOM];	[[soapMsg xmlNodeWithName: @"Body"] addNode: aBody];	//Now hand it to the security code.	Security *security = [Security createSecurityWithUserid: userid password: password];	NSObject <SecurityModel> *securer = [security createSecurityModelOfType: securityType];	[securer secureSoapMessage: soapMsg];	DHC_LOG(@"Action: %@", self.soapAction);	DHC_LOG(@"Compiled soap message:\n%@", [soapMsg asPrettyXmlString]);	[self setHeaderValue: self.soapAction forKey: @"SOAPAction"];	NSData *data = [self post:[soapMsg asXmlString]];	//Parse the data through the xml processor and get a document.	XmlParser *parser = [XmlParser parserWithData: data];	XmlDocument *document = [parser parse];	return [self createWebServiceResponseWithDocument: document];}/* * Wraps the response from the web service. */- (WebServiceResponse *) createWebServiceResponseWithDocument: (XmlDocument *) document {	if ([[document xmlNodeWithName: @"Body"] hasXmlNodeWithName: @"Fault"]) {		DHC_LOG(@"Generating Fault response instance");		return [[[WebServiceFault alloc] initWithDocument: document] autorelease];	}	DHC_LOG(@"Generating normal response instance");	return [[[WebServiceResponse alloc] initWithDocument: document] autorelease];}- (void) dealloc {	DHC_DEALLOC(userid);	DHC_DEALLOC(password);	[super dealloc];}@end