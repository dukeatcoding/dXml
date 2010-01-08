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

