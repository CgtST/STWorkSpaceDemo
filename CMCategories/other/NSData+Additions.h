//
//  NSData+FLAdditions.h
//  QNEngine
//
//  Created by owen on 14-5-26.
//  Copyright (c) 2014年 Futu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (Additions)

- (NSString *)MD5String;
- (NSString *)base32String;

+ (id)dataWithBase32String:(NSString *)base32String;

- (NSData *)AES256EncryptWithKey:(NSString *)key;
- (NSData *)AES256DecryptWithKey:(NSString *)key;

@end
