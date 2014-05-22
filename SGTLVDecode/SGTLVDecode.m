//
//  SGTLVParser.m
//  tlvParser
//
//  Created by Htain Lin Shwe on 22/5/14.
//  Copyright (c) 2014 2c2p. All rights reserved.
//

#import "SGTLVDecode.h"
#import "SGTag.h"
#import "SGLength.h"

@implementation SGTLVDecode
+ (NSDictionary*)decodeWithString:(NSString*)tlv
{
    if(tlv.length %2 !=0)
    {
        NSLog(@"Invalid TLV");
        return nil;
    }
    
    int length = tlv.length/2;
    int currentLoc = 0;
    
    NSMutableArray *bytes = [[NSMutableArray alloc] initWithCapacity:length];
    for (int i =0; i < length; i++) {
        NSString *byte = [tlv substringWithRange:NSMakeRange(currentLoc, 2)];
        currentLoc +=2;
        [bytes addObject:@([SGTLVDecode hexToInt:byte])];
    }
    
    return [SGTLVDecode decodeTlv:bytes];
}

+(NSDictionary*)decodeTlv:(NSArray*)bytes
{
    NSMutableArray *tag = [[NSMutableArray alloc] init];
    NSMutableDictionary *tree = [[NSMutableDictionary alloc] init];
    
    int cursor = 0;
    int extent = bytes.count;
    
    BOOL tagIsConstructed = YES;
    
    int actualLength = 0;
    NSString *actualTag = @"";
    NSString *actualVal = @"";
    while (cursor < extent) {
        
        
        actualLength = 0;
        actualTag = @"";
        actualVal = @"";
        
        if(bytes.count <= cursor)
        {
            break;
        }
        
        [tag addObject:bytes[cursor]];
        
        
        int firstTag = [tag[0] intValue];
        
        if (![SGTag isValid:firstTag]) {
            
            cursor++;
            
            continue;
        }
        
        
        tagIsConstructed = [SGTag isConstructed:firstTag];
        
        if([SGTag isMultiByte:firstTag])
        {
            cursor ++;
            if(bytes.count <= cursor)
            {
                break;
            }
            
            [tag addObject:bytes[cursor]];
            
            int currentByte = [bytes[cursor] intValue];
            
            if(![SGTag isLast:currentByte])
            {
                cursor++;
                
                if(bytes.count <= cursor)
                {
                    break;
                }
                
                [tag addObject:bytes[cursor]];
            }
        }
        
        NSString *fullTag = @"";
        for (NSNumber *num in tag) {

            NSString *hexStr = [NSString stringWithFormat:@"%02lX",
                                (unsigned long)[num integerValue]];

            fullTag = [fullTag stringByAppendingString:hexStr];
            
        }
        
        actualTag = fullTag;
        
        [tag removeAllObjects];
        
        cursor++;
        
        
        
        ////// length
        
        if(bytes.count <= cursor)
        {
            break;
        }
        
        //$length = $bytes[$cursor];
        NSNumber *length = bytes[cursor];
        int intLength =[length intValue];
        
        if(![SGLength isValid:intLength])
        {
            break;
        }
        int mylength = [SGLength getLength:intLength];
        
        actualLength = intLength;
        
        if([SGLength isMultiByte:intLength])
        {
            int length_cursor = 0;
            int length_extent = mylength;
            
            NSMutableArray *tagLength = [[NSMutableArray alloc] init];
            
            while (length_cursor < length_extent) {
                cursor++;
                if(bytes.count <= cursor)
                {
                    break;
                }
                int tmp = [bytes[cursor] intValue] << ((length_extent - length_cursor -1) * 8);
                [tagLength addObject:@(tmp)];
                
                length_cursor++;
            }
            
            if(bytes.count <= cursor)
            {
                break;
            }
            
            int length_output = 0;
            
            for (NSNumber *length_part in tagLength) {
                length_output = length_output | [length_part intValue];
            }
            
            actualLength = length_output;
            
        }
        
        
        cursor++;
        
        /////value
        
        if(bytes.count <= cursor)
        {
            break;
        }
        
        NSArray *value = [bytes subarrayWithRange:NSMakeRange(cursor, actualLength)];
        
        NSDictionary *newVal = nil;
        if(tagIsConstructed)
        {
            newVal = [SGTLVDecode decodeTlv:value];
        }
        else {
            
            NSString *fullVal = @"";
            for (NSNumber *num in value) {
                
                NSString *hexStr = [NSString stringWithFormat:@"%02lX",
                                    (unsigned long)[num integerValue]];
                
                fullVal = [fullVal stringByAppendingString:hexStr];
                
            }
            
            actualVal = fullVal;
            
        }
        
        cursor +=actualLength;
        
        tree[actualTag] = @{@"name": [SGTag getName:actualTag],
                            @"length" : @(actualLength),
                            @"value" : actualVal
                            };

        
    }
    
    return tree;
}

+ (NSString*)hexToString:(NSString*)str
{
    NSMutableString * newString = [[NSMutableString alloc] init];
    int i = 0;
    while (i < [str length])
    {
        NSString * hexChar = [str substringWithRange: NSMakeRange(i, 2)];
        int value = 0;
        sscanf([hexChar cStringUsingEncoding:NSASCIIStringEncoding], "%x", &value);
        [newString appendFormat:@"%c", (char)value];
        i+=2;
    }
    return newString;
}

+ (int)hexToInt:(NSString*)hex
{
    unsigned result = 0;
    NSScanner *scanner = [NSScanner scannerWithString:hex];
    [scanner scanHexInt:&result];
    return result;
}



@end
