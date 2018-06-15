//
//  NSString+FLAdditions.m
//  FutuLogic
//
//  Created by manny on 12-11-26.
//  Copyright (c) 2012年 Futu. All rights reserved.
//

#import "NSString+Additions.h"
#include <CommonCrypto/CommonDigest.h>

@implementation NSString (Additions)

+ (NSString*)hexStringWithData:(unsigned char*)data length:(NSUInteger)length
{
    NSMutableString *tmp = [NSMutableString string];
    for (NSUInteger i=0; i<length; i++)
        [tmp appendFormat:@"%02x", data[i]]; // & 0x00FF
    return [NSString stringWithString:tmp];
}

static char base64EncodingTable[64] = {
    'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P',
    'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z', 'a', 'b', 'c', 'd', 'e', 'f',
    'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v',
    'w', 'x', 'y', 'z', '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '+', '/'
};

+ (NSString *)base64StringWithData:(unsigned char*)data length:(int)length
{
    unsigned long ixtext;
    long ctremaining;
    unsigned char input[3], output[4];
    short i, charsonline = 0, ctcopy;
    NSMutableString *result;
    
    result = [NSMutableString stringWithCapacity: length];
    ixtext = 0;
    
    while (true) {
        ctremaining = length - ixtext;
        if (ctremaining <= 0)
            break;
        for (i = 0; i < 3; i++) {
            unsigned long ix = ixtext + i;
            if (ix < length)
                input[i] = data[ix];
            else
                input[i] = 0;
        }
        output[0] = (input[0] & 0xFC) >> 2;
        output[1] = ((input[0] & 0x03) << 4) | ((input[1] & 0xF0) >> 4);
        output[2] = ((input[1] & 0x0F) << 2) | ((input[2] & 0xC0) >> 6);
        output[3] = input[2] & 0x3F;
        ctcopy = 4;
        switch (ctremaining) {
            case 1:
                ctcopy = 2;
                break;
            case 2:
                ctcopy = 3;
                break;
        }
        
        for (i = 0; i < ctcopy; i++)
            [result appendString: [NSString stringWithFormat: @"%c", base64EncodingTable[output[i]]]];
        
        for (i = ctcopy; i < 4; i++)
            [result appendString: @"="];
        
        ixtext += 3;
        charsonline += 4;
        
        if ((length > 0) && (charsonline >= length))
            charsonline = 0;
    }     
    return result;
}

- (NSString*)md5String
{
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    unsigned char* d = CC_MD5([self UTF8String], (CC_LONG)[self lengthOfBytesUsingEncoding:NSUTF8StringEncoding], digest);
    
    return [NSString stringWithFormat:@"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            d[0], d[1], d[2], d[3], d[4], d[5], d[6], d[7], d[8], d[9], d[10], d[11], d[12], d[13], d[14], d[15],
            nil];
}

- (int64_t)QNFiveZeroNumber
{
    return round([self doubleValue] * 100000.0);
}

+(NSString*)codeFromAccessId:(NSString*)accessId{
    NSMutableString * string = [NSMutableString stringWithString:accessId];
    NSRange range = [string rangeOfString:@"."];
    if (range.length == 0) {
        return @"--";
    }
    NSRange newRange = {range.location,string.length-range.location};
    [string replaceCharactersInRange:newRange withString:@""];
    return string;
}

- (NSString *)stringByTrimmingRepeatedNewlines {
    NSError __autoreleasing *error = NULL;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"\n+" options:0 error:&error];
    if (!error) {
        NSString *resultString = [regex stringByReplacingMatchesInString:self options:0 range:NSMakeRange(0, [self length]) withTemplate:@"\n"];
        return resultString;
    }else {
        return self;
    }
}

@end
