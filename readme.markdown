# Introduction
 
dXml was conceived when I was starting with ObjC and iPhone development. Seeing a number of people on the web looking for a DOM style parser and being interested in testing soap web services for a project, I decided to write a static library which contained the following features:

* A parser to convert a stream of xml into an object model.
* The ability to interact with web sites and handle the basic setup and communication.
* The ability to talk to soap based web services, constructing and deconstructing messages as necessary.
 
# Documentation

dXml is documented thanks to [Tomaz's appledoc](http://github.com/tomaz/appledoc). This tool allows use to generate an XCode formatted document bundle which you can install into xcode. To install this documentation into Xcode, simply copy the docs/docset directory into ~/Library/Developer/Shared/Documentation/Docsets directory and it should immediately become available in xcode's help system.

# Adding to your iPhone project 

Adding this library to you project is simple. Follow these steps:

1. Drag the contents of the dmg distribution file into a folder on your system. For example ~/ext/api/dXml
1. Open your xcode project and navigate to *Frameworks*.
1. Add a new folder in Frameworks. This is not necessary but I'd recommend it because it helps keeps things organised. I'd call it *dXml*.
1. Open the installation folder in finder and select all the header files and the lib_dXml.a static library file and drag them to the newly created folder in xcode. 
1. XCode will prompt as to whether you want to copy the files into the project. I generally say no.

That is all you should need to do.
 
# The quick guide to dXml

## Building xml structures.

The bulk of dXml's document model is handled by two class - DCXmlNode and DCTextNode.

DCXmlNode is the basic building block of the model. This means that every xml element is represented by a DCXmlNode instances. For example, lets look at the following xml code:

	<abc>
		<def>ghi</def>
	</abc>

When building this in the object mode, dXml will:

1. Create an instance of DCXmlNode for the `<abc>` element.
1. Create a second instance of DCXmlNode for the `<def>` element and add it as a sub node of the `<abc>` node.
1. Create a DCTextNode for the string "hi" and add it as a sub node of the `<def>` node.

DCTextNodes cannot have sub nodes. In tree terms, they can only be leaves. DCXmlNode on the other hand can have none, one or many sub nodes, being both branches and leaves. As a result, DCXmlNode has a range of messages that can be sent to it to manipulate it's sub nodes. Some of which operate on all the sub nodes it contains, some which take the names of sub DCXmlNodes as parameters. DCXmlNode also tracks the order of any sub nodes added so there are some messages which can take a index to retrieve a specific sub node.

### Creating a model programmatically.

Now lets look at creating a document model in code. Here's an example piece of code that creates the example xml we have used above:

	DCXmlNode *rootElement = [[[DCXmlNode alloc] initWithName:  @"abc"] autorelease];
	[rootElement addXmlNodeWithName: @"def" value: @"ghi"];

Very simple. here's a much more practical example: 

	DCXmlDocument *document = [[[DCXmlDocument alloc] initWithName: @"envelope" prefix: @"soap"] autorelease];
	[document addNamespace: @"http://schemas.xmlsoap.org/soap/envelope/" prefix: @"soap"];
	[document setAttribute: @"soap:encodingStyle" value: @"http://schemas.xmlsoap.org/soap/encoding/"];
	DCXmlNode *bodyElement = [document addXmlNodeWithName: @"body" prefix: @"soap"];
	DCXmlNode *getLastTradePriceElement = [bodyElement addXmlNodeWithName: @"GetLastTradePrice" prefix: @"m"];
	[getLastTradePriceElement addNamespace: @"http://trading-site.com.au" prefix: @"m"];
	[getLastTradePriceElement addXmlNodeWithName: @"symbol" value: @"MOT"];

	NSLog([document asPrettyXmlString]);

Notice the introduction of DCXmlDocument. This is really just a simple extension of DCXmlNode, but it's presence will cause the the generated xml to also include the standard xml version declaration. Here's the xml you will see printed in the log:

	<?xml version="1.0" encoding="UTF-8"?>
	<soap:envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/" 
						soap:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
		<soap:body>
			<m:GetLastTradePrice xmlns:m="http://trading-site.com.au">
				<symbol>MOT</symbol>
			</m:GetLastTradePrice>
		</soap:body>
	</soap:envelope>


### Creating a model from an xml source.

Ok, so that was good if you are doing this from scratch. but theres a second way to create a document model in dXml. This method utilises a NSString* containing xml, which is then parsed into the document model. Here is the same soap message from above using this method:

	const NSString * WEB_SERVICE_XML = @"<?xml version=\"1.0\" encoding=\"UTF-8\"?>"
		@"<soap:envelope xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\""
		@" soap:encodingStyle=\"http://schemas.xmlsoap.org/soap/encoding/\">"
		@"<soap:body>"
		@"<m:GetLastTradePrice xmlns:m=\"http://trading-site.com.au\">"
		@"<symbol>MOT</symbol>"
		@"</m:GetLastTradePrice>"
		@"</soap:body>"
		@"</soap:envelope>";

	DCXmlParser *parser = [DCXmlParser parserWithXml: xml];
	NSError *error = nil;
	DCXmlDocument *xmlDoc = [parser parse:&error];
	
	if (error != nil) {
		//Deal the error in error
	}

### Parsing xml

dXml's parsing abilities are of course based around the SDK NSXMLParser class. However I have wrapped all the internally functionality with some tweaks of my own. Mainly to process a stream of xml into the document model. Because developers also regaularly want to parse xml that is stored in NSString objects rather than the default NSData and NSUrl sources, I've added that functionality as well. 

In the previous section there is an example of using the DCXmlParser. It's not hard, just a few lines of code:

	DCXmlParser *parser = [DCXmlParser parserWithXml: xml];
	NSError *error = nil;
	DCXmlDocument *xmlDoc = [parser parse:&error];

	if (error != nil) {
		//Deal the error in error
	}

There are two other variations on the factory message `[DCXmlParser parserWithXml: xml]`. `[DCXmlParser parserWithData: data]` and `[DCXmlParser parserWithUrl: url]`. These provide the same parsing abilities as supplied by NSXMLParser.


### Generating xml

By the time you are reading this you should already have figured out the two methods for generating xml from the document model. `[model asXmlString]` and `[model asPrettyXmlString]`. Usually in code you wout use asXmlString to produce output for a server request. asPrettyXmlString is just present to help with debug logs.

### More about DCXmlNode

Seeing as DCXmlNode contains the major chunk of functionality, here is a list of some of the most common messages you may send to it and what they do:

#### Constructors
***

##### - (DCXmlNode \*) initWithName: (NSString \*) *aName*</td>
Produces in xml: `<aName />`

##### - (DCXmlNode \*) initWithName: (NSString \*) *aName* prefix: (NSString \*) *aPrefix*;
Produces in xml: `<aPrefix:aName />`

#### Search messages
***

##### - (DCXmlNode \*) xmlNodeWithName: (NSString \*) *aName*;
Returns the sub node with the specified name.

##### - (DCXmlNode \*) nodeAtIndex: (int) *index*;
Returns the sub node at the index. 

#### Adding new sub nodes
***

##### - (void) addNode: (DCDMNode \*) element;
Appends the passed node to the list of nodes.

##### - (DCXmlNode \*) addXmlNodeWithName: (NSString \*) *aName*;
Creates a new DCXmlNode and appends it to the list of nodes.

##### - (DCXmlNode \*) addXmlNodeWithName: (NSString \*) *aName* prefix: (NSString \*) *aPrefix*;
Creates a new DCXmlNode and appends it to the list of nodes.

##### - (DCXmlNode \*) addXmlNodeWithName: (NSString \*) *aName* value: (NSString \*) *aValue*;
Creates a new DCXmlNode and appends it to the list of nodes.

##### - (DCXmlNode \*) addXmlNodeWithName: (NSString \*) *aName* prefix: (NSString \*) *aPrefix* value: (NSString \*) *aValue*;
Creates a new DCXmlNode and appends it to the list of nodes.

##### -(DCTextNode \*) addTextNodeWithValue: (NSString \*) *aValue*;
Creates a new DCTextNode and appends it to the list of nodes.

#### Querying
***

##### - (BOOL) hasXmlNodeWithName: (NSString \*) *aName*;
Returns YES/TRUE if there is an DCXmlNode in the list of sub nodes with the passed name.

##### - (NSString \*) attributeValue: (NSString \*) *aName*;
Returns the value of the attribute.

##### -(NSString \*) value;
A shortcut message which assumes that there is only a single DCTextNode in the list of nodes and returns it's value.

##### -(int) countNodes;
Returns the total number of sub nodes.

#### Accessing sub nodes
***

##### - (NSEnumerator \*) nodes;
Provides access to all the sub nodes.

##### - (NSEnumerator \*) xmlNodesWithName: (NSString \*) *aName*;
Searches the sub nodes and only returns DCXmlNodes which have the passed name.

#### Modifying nodes and values
***

##### - (void) addNamespace: (NSString \*) *aUrl* prefix: (NSString \*) *aPrefix*;
Adds a namespace declaration to the node. ie. `xmlns:aPrefix="aUrl"`

##### - (void) setAttribute: (NSString \*) *aName* value: (NSString \*) *aValue*;
Adds or sets the value of an attribute.

##### -(void) setValue: (NSString \*) *value*;
Another shortcut methods. This one assumes you only want a single DCTextNode with a value. If there are any current sub nodes they are removed before the new DCTextNode is created.

#### Producing xml
***

##### - (NSString \*) asXmlString;
Compiles and returns the xml that this node and it's sub nodes represent as a single string.

##### - (NSString \*) asPrettyXmlString;
Compiles and returns the xml that this node and it's sub nodes represent as a single string, formatted for output into logs and files.

## Sending messages to servers

### Any old server

The core class for talking to a server is the DCUrlConnection class. It provides the ability to handle self signed certificates from servers (which is great for developers), userids and passwords, headers and posting requests to servers and returniong the response as a NSData object.

This class is pretty basic at the moment and has only been tested with some basic security setups. A lot more needs to be done here in the realm of security.

### Soap Web Services

DCSoapWebServiceConnection is the main class for making soap web service calls. It enhances the DCUrlConnection by adding soap message generation, soap actions and soap security. Here's is an example of a complete interaction with a server based on using this class and all of the previous stuff in this readme. This time we will use a banking scenario.

First lets assume you ave a header somewhere with:

	#define BANKING_SECURE @"https://localhost:8181/services/Banking"
	#define BALANCE_ACTION @"\"http://localhost:8080/banking/balance\""
	#define MODEL_SCHEMA @"http://localhost/banking/model"


#### 1st with a string based xml:

	// Soap payload as an NSString
	NSString *xml = @"<dhc:balance xmlns:dhc=\"" MODEL_SCHEMA "\">" 
					@" forAccountNumber>1234</forAccountNumber>"
					@"</dhc:balance>";

	//Get a connection object and call the service.
	DCSoapWebServiceConnection *service = [DCSoapWebServiceConnection createWithUrl: BANKING soapAction: BALANCE_ACTION];
	[service setUsername:@"username" password"@"password"];
	NSError *error = nil;
	DCWebServiceResponse *response = [service postXmlStringPayload: xml errorVar:&error];

	// Check for errors.
	if (error != nil) {
		// Do something about the error.
		return;
	}

	NSLog(@"Balance = &@", [[response bodyContent] xmlNodeWithName: @"balance"].value];

#### And now using the api:

	DCXmlNode *xml = [[[DCXmlNode alloc] initWithName: @"balance" prefix: @"dhc"] autorelease];
	[accountBalance addNamespace: MODEL_SCHEMA prefix: @"dhc"];
	[accountBalance addXmlNodeWithName: @"forAccountNumber" prefix: nil value: @"1234"];

	//Get a connection object and call the service.
	DCSoapWebServiceConnection *service = [DCSoapWebServiceConnection createWithUrl: BANKING soapAction: BALANCE_ACTION];
	[service setUsername:@"username" password"@"password"];
	NSError *error = nil;
	DCWebServiceResponse *response = [service postXmlNodePayload: xml errorVar:&error];

	// Check for errors.
	if (error != nil) {
		// Do something about the error.
		return;
	}

	NSLog(@"Balance = &@", [[response bodyContent] xmlNodeWithName: @"balance"].value];

### Faults

All soap errors are returned in standard NSError objects. As such some additional messages have been added to various classes to help deal with them.

Firstly, the DCWebServiceResponse class now has a `isFault` message which returns true if the response contains a soap fault. Although this is not used directly because DCSoapWebServiceConnection will automatically convert soap faults to NSErrors.

Secondly, there is a nw category called NSError(SoapFault) which provies methods for creating NSError objects containg soap faults as well as methods for accessing their details. By adding this category to the NSError class it becomes trivial to deal with soap faults.

So here's some code showing how to use these features:

	NSError *error = nil;
	DCWebServiceResponse *response = [service postXmlNodePayload: xml errorVar:&error];

	// Check for errors.
	if (error != nil) {
		if (error.isSoapFault) {
			NSLog(@"Fault code    = &@", error.soapFaultCode);
			NSLog(@"Fault message = &@", error.soapFaultMessage);
			return;
		}
	}


