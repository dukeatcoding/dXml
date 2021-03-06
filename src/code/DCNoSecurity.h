//
//  NoSecurity.h
//  dXml
//
//  Created by Derek Clarkson on 4/12/09.
//  Copyright 2009 Derek Clarkson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DCSecurity.h"

/**
 * For the conveniance of calling code, this is a security handler that does nothing.
 * \see Security
 */
@interface DCNoSecurity : NSObject <DCSecurityModel>{
}

@end