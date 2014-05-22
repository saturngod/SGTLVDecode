//
//  Tag.h
//  tlvParser
//
//  Created by Htain Lin Shwe on 22/5/14.
//  Copyright (c) 2014 2c2p. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SGTag : NSObject
+(BOOL)isValid:(int)byte;
+(BOOL)isConstructed:(int)byte;
+(int)getEncoding:(int)byte;
+(BOOL)isMultiByte:(int)byte;
+(BOOL)isLast:(int)byte;
+(NSString*)getName:(NSString*)tag;
@end
