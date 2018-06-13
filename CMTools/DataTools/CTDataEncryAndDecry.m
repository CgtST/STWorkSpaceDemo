//
//  CMDataEncryAndDecry.m
//  CMTools
//
//  Created by bingo on 2018/6/13.
//  Copyright © 2018年 bingo. All rights reserved.
//

#import "CTDataEncryAndDecry.h"
#import <CommonCrypto/CommonDigest.h>


@implementation CTDataEncryAndDecry


//base64加密
+(nonnull NSData*)encryWithbase64:(nonnull NSData*)orgData
{
    if (orgData.length == 0)
        return [NSData data];
    
    long chrLength = ((orgData.length + 2) / 3) * 4;
    char characters[chrLength];
    NSUInteger length = 0;
    
    NSUInteger i = 0;
    static const char encodingTable[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
    while (i < orgData.length)
    {
        char buffer[3] = {0,0,0};
        short bufferLength = 0;
        while (bufferLength < 3 && i < orgData.length)
        {
            buffer[bufferLength++] = ((char *)[orgData bytes])[i++];
        }
        
        //  Encode the bytes in the buffer to four characters, including padding "=" characters if necessary.
        characters[length++] = encodingTable[(buffer[0] & 0xFC) >> 2];
        characters[length++] = encodingTable[((buffer[0] & 0x03) << 4) | ((buffer[1] & 0xF0) >> 4)];
        if (bufferLength > 1)
            characters[length++] = encodingTable[((buffer[1] & 0x0F) << 2) | ((buffer[2] & 0xC0) >> 6)];
        else characters[length++] = '=';
        if (bufferLength > 2)
            characters[length++] = encodingTable[buffer[2] & 0x3F];
        else characters[length++] = '=';
    }
    NSString *dataStr = [[NSString alloc] initWithBytes:characters length:length encoding:NSASCIIStringEncoding];
    return [dataStr dataUsingEncoding:NSUTF8StringEncoding];
}

//base64解密
+(nonnull NSData*)decryWithbase64:(nonnull NSData*)orgData
{
    unsigned char tempcstring[orgData.length];
    [orgData getBytes:tempcstring length:[orgData length]];
    
    
    NSMutableData *theData = [NSMutableData dataWithCapacity: orgData.length];
    
    unsigned char  inbuf[4], outbuf[4];
    short  ixinbuf = 0;
    
    bool flendtext = false;
    unsigned long ixtext = 0;
    while (ixtext < orgData.length)
    {
        unsigned char ch = tempcstring [ixtext++];
        
        bool flignore = false;
        
        if ((ch >= 'A') && (ch <= 'Z'))
        {
            ch = ch - 'A';
        }
        else if ((ch >= 'a') && (ch <= 'z'))
        {
            ch = ch - 'a' + 26;
        }
        else if ((ch >= '0') && (ch <= '9'))
        {
            ch = ch - '0' + 52;
        }
        else if (ch == '+')
        {
            ch = 62;
        }
        else if (ch == '=')
        {
            flendtext = true;
        }
        else if (ch == '/')
        {
            ch = 63;
        }
        else
        {
            flignore = true;
        }
        
        if (!flignore)
        {
            short ctcharsinbuf = 3;
            bool flbreak = false;
            
            if (flendtext)
            {
                if (ixinbuf == 0)
                {
                    break;
                }
                
                if ((ixinbuf == 1) || (ixinbuf == 2))
                {
                    ctcharsinbuf = 1;
                }
                else
                {
                    ctcharsinbuf = 2;
                }
                
                ixinbuf = 3;
                
                flbreak = true;
            }
            
            inbuf [ixinbuf++] = ch;
            
            if (ixinbuf == 4)
            {
                ixinbuf = 0;
                
                outbuf[0] = (inbuf[0] << 2) | ((inbuf[1] & 0x30) >> 4);
                outbuf[1] = ((inbuf[1] & 0x0F) << 4) | ((inbuf[2] & 0x3C) >> 2);
                outbuf[2] = ((inbuf[2] & 0x03) << 6) | (inbuf[3] & 0x3F);
                
                for (int i = 0; i < ctcharsinbuf; i++)
                {
                    [theData appendBytes: &outbuf[i] length: 1];
                }
            }
            
            if (flbreak)
            {
                break;
            }
        }
    }
    
    return theData;
}

+(nonnull NSString*)decryWithMD5:(nonnull NSString*)str
{
    const char *cStr = [str UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    memset(result, 0, sizeof(result));  //如果不清除内存块，可能导致加密错误
    CC_MD5(cStr,(CC_LONG)strlen(cStr),result);
    NSMutableString *resultStr = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(NSUInteger i = 0; i < CC_MD5_DIGEST_LENGTH;i ++)
    {
        [resultStr appendFormat:@"%02X",result[i]];
    }
    return [resultStr copy];
}

+(nonnull NSString*)decryWithSHA:(nonnull NSString*)str
{
    //对字符串进行SHA加密
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    CC_SHA1(data.bytes,(CC_LONG)data.length,digest);
    NSMutableString *outPut = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH*2];
    for(int i=0; i < CC_SHA1_DIGEST_LENGTH;i++)
    {
        [outPut appendFormat:@"%02X",digest[i]];
    }
    return [outPut copy];
}

@end
