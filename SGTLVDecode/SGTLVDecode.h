//
//  SGTLVParser.h
//  tlvParser
//
//  Created by Htain Lin Shwe on 22/5/14.
//  Copyright (c) 2014 2c2p. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SGTLVDecode : NSObject

+ (NSString*)hexToString:(NSString*)str;
+ (int)hexToInt:(NSString*)hex;

+ (NSDictionary*)decodeWithString:(NSString*)tlv;
@end
