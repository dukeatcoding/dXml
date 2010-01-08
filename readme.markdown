# Introduction

dXml was conceived when I was starting with ObjC and iPhone development. Seeing a number of people on the web looking for a DOM style parser and being interested in testing soap web services for a project, I decided to write a static library which contained the following features:

* A parser to convert a stream of xml into an object model.
* The ability to interact with web sites and handle the basic setup and communication.
* The ability to talk to soap based web services, constructing and deconstructing messages as necessary.

## Building xml structures.

The bulk of dXml's document model is handled by two class - XmlNode and TextNode.

XmlNode is the basic building block of the model. This means that every xml element is represented by a XmlNode instances. For example, deltas look at the following xml code:

	<abc>
		<def>ghi</def>
	</abc>

When building this in the object mode, dXml will:

1. Create an instance of XmlNode for the `<abc>` element.
1. Create a second instance of XmlNode for the `<def>` element and add it as a sub node of the `<abc>` node.
1. Create a TextNode for the string "hi" and add it as a sub node of the `<def>` node.

TextNodes cannot have sub nodes. In tree terms, they can only be leaves. XmlNode on the other hand can have none, one or many sub nodes, being both branches and leaves. As a result, XmlNode has a range of messages that can be sent to it to manipulate it's sub nodes. Some of which operate on all the sub nodes it contains, some which take the names of sub XmlNodes as parameters. XmlNode also tracks the order of any sub nodes added so there are some messages which can take a index to retrieve a specific sub node.

### Creating a model programmatically.

Now lets look at creating a document model in code. Here's an example piece of code that creates the example xml we have used above:

	XmlNode *rootElement = [[[XmlNode alloc] initWithName:  @"abc"] autorelease];
	[rootElement addXmlNodeWithName: @"def" value: @"ghi"];

Very simple. here's a much more practical and sophisticated example: 

	XmlDocument *document = [[[XmlDocument alloc] initWithName: @"envelope" prefix: @"soap"] autorelease];
	[document addNamespace: @"http://schemas.xmlsoap.org/soap/envelope/" prefix: @"soap"];
	[document setAttribute: @"soap:encodingStyle" value: @"http://schemas.xmlsoap.org/soap/encoding/"];
	XmlNode *bodyElement = [document addXmlNodeWithName: @"body" prefix: @"soap"];
	XmlNode *getLastTradePriceElement = [bodyElement addXmlNodeWithName: @"GetLastTradePrice" prefix: @"m"];
	[getLastTradePriceElement addNamespace: @"http://trading-site.com.au" prefix: @"m"];
	[getLastTradePriceElement addXmlNodeWithName: @"symbol" value: @"MOT"];

	NSLog([document asPrettyXmlString]);

Notice the introduction of XmlDocument. This is really just a simple extension of XmlNode, but it's presence will cause the the generated xml to also include the standard xml version declaration. Here's the xml you will see printed in the log:

	<?xml version="1.0" encoding="UTF-8"?>
	<soap:envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/" soap:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
		<soap:body>
			<m:GetLastTradePrice xmlns:m="http://trading-site.com.au">
				<symbol>MOT</symbol>
			</m:GetLastTradePrice>
		</soap:body>
	</soap:envelope>

### Creating a model from an xml source.

Ok, so that was good if you are doing this from scratch. but theres a second way to create a document model in dXml. This method utilises a NSString* containing xml, which is then parsed into the document model. here the same soap message from above using this method:

	const NSString * WEB_SERVICE_XML = @"<?xml version=\"1.0\" encoding=\"UTF-8\"?>"
		@"<soap:envelope xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\""
		@" soap:encodingStyle=\"http://schemas.xmlsoap.org/soap/encoding/\">"
		@"<soap:body>"
		@"<m:GetLastTradePrice xmlns:m=\"http://trading-site.com.au\">"
		@"<symbol>MOT</symbol>"
		@"</m:GetLastTradePrice>"
		@"</soap:body>"
		@"</soap:envelope>";

	XmlParser *parser = [XmlParser parserWithXml: xml];	XmlDocument *xmlDoc = [parser parse];

