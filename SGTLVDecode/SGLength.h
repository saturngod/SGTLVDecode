//
//  SGLength.h
//  tlvParser
//
//  Created by Htain Lin Shwe on 22/5/14.
//  Copyright (c) 2014 2c2p. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SGLength : NSObject
+(BOOL)isValid:(int)byte;
+(int)getLength:(int)byte;
+(BOOL)isMultiByte:(int)byte;
@end
