# DXml v0.1.0 (20Jan 2010)

* Added more defines to SoapWebServiceConnection.h to help with extracting data from responses.
* Added a new category to NSError to manage soap fault details.
* Added isSoapFault message to WebServiceResponse.
* Added simple BSD license.
* Inline with suggested coding practices on [Cocoa Dev Central](http://cocoadevcentral.com/articles/000082.php) I've renamed all classes and values to have a prefix of "DC". This helps to ensure that when used with other libraries we avoid conflicting names. This is the reason for the minor version increment as all previous code will break.

# dXml v0.0.2 (18 Jan 2010)

* Added changelog to release build and dmg file.
* Renamed NSObject (SoapTemplates) createBasicSoapDOM to createBasicSoapDM to avoid confuson with the w3c DOM.
* Started grouping messages in the api documentation.
* Moved integration tests to their own executable. This is not part of the normal build so that developers do not need a full server setup to build dXml.
* Removed soap faults and exceptions from api. Changed to set NSError references as recommended by Apple's programming guides.
* Changed XmlNode:isEqualsToName: to isEqualToName:.

# dXml v0.0.1 (Jan 2010)

Initial release code to GitHub.