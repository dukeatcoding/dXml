//
//  UseridPasswordSecurity.h
//  dXml
//
//  Created by Derek Clarkson on 4/12/09.
//  Copyright 2009 Derek Clarkson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Security.h"

/**
 * This security handler will implement a basic userid/password style security model. When asked to process a soap message, it will add ws-security xml elements to the soap messages header area and put the userid and password into those elements.
 */
@interface UseridPasswordSecurity : NSObject <SecurityModel>{
	@private
	NSString *userid;
	NSString *password;
}

/**
 * default constructor.
 */
- (UseridPasswordSecurity *) initWithUserid: (NSString *) aUserid password: (NSString *) aPassword;

@end