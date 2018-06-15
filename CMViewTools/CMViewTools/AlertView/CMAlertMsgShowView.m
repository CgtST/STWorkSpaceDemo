//
//  CMAlertMsgShowView.m
//  ViewTools
//
//  Created by bingo on 16/1/6.
//  Copyright © 2016年 CM. All rights reserved.
//

#import "CMAlertMsgShowView.h"
#import "CMViewDataOper.h"

@interface CMAlertMsgShowView ()
{
    UILabel *m_contentLab;
}
@end

@implementation CMAlertMsgShowView

-(nonnull instancetype)initWithContent:(nonnull NSString*)contentStr
{
    CGFloat maxWidth = [UIScreen mainScreen].bounds.size.width * 0.6; //最多占屏幕0.6的宽度
    CGFloat height = [CMViewDataOper getHeightOfStr:contentStr WithFont:[UIFont systemFontOfSize:18] andWidth:maxWidth];
    CGFloat textWidth = [CMViewDataOper getFontWidthStr:contentStr withFont:[UIFont systemFontOfSize:18]];
    CGFloat width = MIN(textWidth, maxWidth);
    
    self = [super initWithFrame:CGRectMake(0, 0, width + 20, height + 20)];  //留出一定的边框
    if(nil != self)
    {
        self.backgroundColor = [UIColor whiteColor]; //默认颜色，可以通过外部设置
        self.layer.cornerRadius = 4;
        //添加文本对象
        {
            m_contentLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, MIN(textWidth, maxWidth), height)];
            m_contentLab.backgroundColor = [UIColor clearColor];
            m_contentLab.center = self.center;
            m_contentLab.font = [UIFont systemFontOfSize:18];
            m_contentLab.text = contentStr;
            m_contentLab.textAlignment = NSTextAlignmentCenter;
            m_contentLab.adjustsFontSizeToFitWidth = YES;
            m_contentLab.lineBreakMode = NSLineBreakByWordWrapping;
            m_contentLab.numberOfLines = 0;
            [self addSubview:m_contentLab];
        }
    }
    return self;
}

-(void)setContentTextColor:(nonnull UIColor*)contentColor
{
    m_contentLab.textColor = contentColor;
}

-(void)setContentFont:(nonnull UIFont*)font
{
    m_contentLab.font = font;
}

@end
