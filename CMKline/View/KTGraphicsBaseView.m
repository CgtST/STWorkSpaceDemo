//
//  KTGraphicsBaseView.m
//  iBestProduct
//
//  Created by bingo on 2018/6/8.
//  Copyright © 2018年 iBest. All rights reserved.
//

#import "KTGraphicsBaseView.h"


#define chart_space   10      //图边距10
#define WidthRate (self.bounds.size.width-chart_space*2)/self.bounds.size.width
#define data_start (15/195.0f)
#define data_end (130/195.0f)
#define buttom_string_start (130.0/195.0f)
#define buttom_string_end (145.0f/195.0f)
#define volume_start (145/195.0f)
#define volume_end (180/195.0f)

#define lineWidth 0.5

#define stringLength 50.0
#define string_padding 2

#define KTDefaultFont  12


@implementation KTGraphicsBaseView

-(instancetype)init
{
    self = [super init];
    if (self) {
        self.textFont = [UIFont systemFontOfSize:KTDefaultFont];
    }
    return self
}


#pragma mark 绘图区域

//主图网格区域区域
- (CGRect)gridRect
{
    return CGRectMake(self.bounds.size.width * (1 - WidthRate) / 2 ,
                      self.bounds.size.height * data_start,
                      self.bounds.size.width * WidthRate,
                      self.bounds.size.height * (data_end - data_start));
}

//主图数据区域
- (CGRect)dataRect
{
    return CGRectMake(self.bounds.size.width * (1 - WidthRate) / 2 + lineWidth,
                      self.bounds.size.height * data_start + lineWidth,
                      self.bounds.size.width * WidthRate - lineWidth * 2,
                      self.bounds.size.height * (data_end - data_start) - lineWidth * 2);
}

//左边文本区域
- (CGRect)leftStringRect
{
    return CGRectMake(self.bounds.size.width * (1 - WidthRate) / 2+string_padding,
                      self.bounds.size.height * data_start,
                      stringLength,
                      self.bounds.size.height * (data_end - data_start));
}



//右边文本区域
- (CGRect)rightStringRect
{
    return CGRectMake(self.bounds.size.width * (1 + WidthRate) / 2 -stringLength-string_padding,
                      self.bounds.size.height * data_start,
                      stringLength,
                      self.bounds.size.height * (data_end - data_start));
}

//下部文本区域
- (CGRect)buttomStringRect
{
    return CGRectMake(self.bounds.size.width * (1 - WidthRate) / 2 ,
                      self.bounds.size.height * buttom_string_start,
                      self.bounds.size.width * WidthRate,
                      self.bounds.size.height * (buttom_string_end - buttom_string_start));
}

//量线网格区域
- (CGRect)volumeGridRect
{
    return CGRectMake(self.bounds.size.width * (1 - WidthRate) / 2 ,
                      self.bounds.size.height * volume_start,
                      self.bounds.size.width * WidthRate,
                      self.bounds.size.height * (volume_end - volume_start));
}

//量线数据区域
- (CGRect)volumeDataRect
{
    return CGRectMake(self.bounds.size.width * (1 - WidthRate) / 2 + lineWidth,
                      self.bounds.size.height * volume_start + lineWidth,
                      self.bounds.size.width * WidthRate - lineWidth * 2,
                      self.bounds.size.height * (volume_end - volume_start) - lineWidth * 2);
}



//绘制左边还是右边字符
- (void)drawString:(CGRect)rect stringList:(NSArray *)list lOrR:(bool)lr
{
    if (list.count > 0)
    {
        CGContextRef ctx = UIGraphicsGetCurrentContext();
        CGContextSaveGState(ctx);
        CGContextSetAllowsAntialiasing(ctx, true);
        CGFloat interval = CGRectGetHeight(rect) / (list.count - 1);
        
        
        
        [list enumerateObjectsUsingBlock:^(NSString * obj, NSUInteger idx, BOOL *stop)
         {
             
             UIColor * color  = [UIColor colorWithHexString:@"#666666" alpha:1];
             if (  idx <list.count/2) {
                 color = [IBGlobalMethod upColor];
             }else if(idx == list.count/2){
                 color = [IBGlobalMethod getIBthemeColorWithNormal:@"#666666" night:@"#999999"];
             }else{
                 color = [IBGlobalMethod downColor];
             }
             
             [color setFill];
             
             CGFloat y = CGRectGetMinY(rect) + idx * interval - self.textFont.lineHeight;
             if (idx==0) {
                 y = CGRectGetMinY(rect);
             }
             CGRect stringRect = CGRectMake(CGRectGetMinX(rect) ,y, CGRectGetWidth(rect),self.textFont.lineHeight);
             
             if (lr)
             {
                 [obj drawInRect:stringRect withFont:self.textFont lineBreakMode:NSLineBreakByClipping alignment:NSTextAlignmentLeft];
                 
             }
             else
             {
                 [obj drawInRect:stringRect withFont:self.textFont lineBreakMode:NSLineBreakByClipping alignment:NSTextAlignmentRight];
                 
             }
         }];
        CGContextRestoreGState(ctx);
    }
}

@end
