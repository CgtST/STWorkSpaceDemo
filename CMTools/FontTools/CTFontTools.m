//
//  CDTFontTools.m
//  CommonDataTools
//
//  Created by bingo on 16/10/18.
//  Copyright © 2016年 CM. All rights reserved.
//

#import "CTFontTools.h"

@implementation CTFontTools

+(CGFloat)getHeightOfFont:(nonnull UIFont*)font
{
    return [[self class] getHeightOfStr:@"国" Font:font Width:1000];
}

//无换行
+(CGSize)getFontSizeOfStr:(nonnull NSString*)str Font:(nonnull UIFont*)font
{
    return [[self class] getFontSize:str Font:font Size:CGSizeMake(1000, 1000)];
}

+(CGFloat)getHeightOfStr:(nonnull NSString*)str Font:(nonnull UIFont*)font Width:(CGFloat)fWidth
{
    return [[self class] getFontSize:str Font:font Size:CGSizeMake(fWidth, 1000)].height;
}

+(CGSize)getFontSize:(nonnull NSString*)str Font:(nonnull UIFont*)font Size:(CGSize)size
{
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

//获取固定宽度内字体的实际大小
+(CGFloat)getFontSizeForWidth:(CGFloat)width
{
    CGFloat actualFontSize;
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    [@"国" sizeWithFont:[UIFont systemFontOfSize:20] minFontSize:4 actualFontSize:&actualFontSize forWidth:width lineBreakMode:NSLineBreakByWordWrapping];
#pragma clang diagnostic pop
    return actualFontSize;
}


@end
