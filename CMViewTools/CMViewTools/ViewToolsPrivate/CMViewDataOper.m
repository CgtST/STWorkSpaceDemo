//
//  CMViewDataOper.m
//  ViewTools
//
//  Created by bingo on 15/11/4.
//  Copyright © 2015年 CM. All rights reserved.
//

#import "CMViewDataOper.h"

@implementation CMViewDataOper

+(CGSize)getFontSizeStr:(nonnull NSString*)str WithFont:(nonnull UIFont*)font withSize:(CGSize)size
{
    if(nil == font || nil == str)
    {
        NSAssert(false,@"传入的参数为空");
        return CGSizeMake(0, 0);
    }
    if([[[UIDevice currentDevice] systemVersion] floatValue] < 7.0)
    {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        return [str sizeWithFont:font constrainedToSize:size lineBreakMode:NSLineBreakByWordWrapping];
#pragma clang diagnostic pop
    }
    else
    {
        NSDictionary *attributeDic = @{NSFontAttributeName:font};
        return  [str boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin |NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesFontLeading attributes:attributeDic context:nil].size;
    }
}

+(CGFloat)getFontWidthStr:(nullable NSString*)str withFont:(nullable UIFont*)font
{
    if(nil == str || nil == font)
    {
        return 0;
    }
    return [CMViewDataOper getFontSizeStr:str WithFont:font withSize:CGSizeMake(1000, 1000)].width;
}

+(CGFloat)getHeightOfStr:(nonnull NSString*)str WithFont:(nonnull UIFont*)font andWidth:(CGFloat)fWidth
{
    return [CMViewDataOper getFontSizeStr:str WithFont:font withSize:CGSizeMake(fWidth, 1000)].height;
}

+(CGFloat)getFontHeight:(nonnull UIFont*)font
{
    return [CMViewDataOper getFontSizeStr:@"国" WithFont:font withSize:CGSizeMake(1000, 1000)].height;
}

@end
