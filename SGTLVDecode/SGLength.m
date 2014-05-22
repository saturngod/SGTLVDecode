//
//  SGLength.m
//  tlvParser
//
//  Created by Htain Lin Shwe on 22/5/14.
//  Copyright (c) 2014 2c2p. All rights reserved.
//

#import "SGLength.h"

@implementation SGLength
+(BOOL)isValid:(int)byte
{
    if (byte != 0x80 && byte >= 0x00 && byte <= 0x84) {
        return YES;
    }
    
    return NO;
}

+(int)getLength:(int)byte
{
    return byte & 0x7f;
}

+(BOOL)isMultiByte:(int)byte
{
    return 0x01 == (byte >> 7);
}

@end
