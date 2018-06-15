//
//  CMOneAlertButtonView.m
//  ViewTools
//
//  Created by bingo on 15/11/16.
//  Copyright © 2015年 CM. All rights reserved.
//

#import "CMOneAlertButtonView.h"
#import "CMViewDataOper.h"
#import "CMAlertViewController.h"
#import "CMAlertHelper.h"
#import "CMAlertButton.h"
#import "CMAlertWindow.h"

#define K_ButtonHeight 55
#define K_TitleHeight  55
#define K_Space        10
#define K_Font         [UIFont systemFontOfSize:20]
#define K_contentFont  [UIFont systemFontOfSize:17]

#define K_MinContentTextHeight 90  //内容页的最低高度

@interface CMOneAlertButtonView ()
{
    NSArray<__kindof UIView*> *m_sepLineViewArr;
}
@property(nonatomic,readwrite,retain,nullable) UILabel *titleLab;
@property(nonatomic,readwrite,retain,nullable) UIView *sepView;
@property(nonatomic,readwrite,retain,nonnull) UILabel *contentLab;
@property(nonatomic,readwrite,retain,nonnull) UIButton *sureButton;

@end

@implementation CMOneAlertButtonView

-(nonnull instancetype)initWithTitle:(nullable NSString*)title Content:(nonnull NSString*)contentStr
{
    CGFloat contentHeight = ceil([CMViewDataOper getHeightOfStr:contentStr WithFont:K_Font andWidth:(K_AlertView_Width - 2 *K_Space)]);
    if(contentHeight + 2 * K_Space > K_MinContentTextHeight)
    {
        contentHeight += 2 * K_Space;
    }
    else
    {
        contentHeight = K_MinContentTextHeight;
    }
    CGFloat viewHeight =  contentHeight + K_ButtonHeight;
    if(nil != title && title.length > 0)
    {
        viewHeight +=K_TitleHeight;
    }
    CGFloat frameHeight = MIN(viewHeight, K_MaxAlertView_Height);
    self = [super initWithFrame:CGRectMake(0, 0,K_AlertView_Width, frameHeight)];
    if(nil != self)
    {
        CGFloat ypos = 0;
        CGFloat contentWidth = self.frame.size.width - 2 * K_Space;
        self.layer.cornerRadius = 5;
        
        NSMutableArray *mutableArr = [NSMutableArray array];
        
        //标题头
        if(nil != title && title.length > 0)
        {
            self.titleLab = [[UILabel alloc] initWithFrame:CGRectMake(K_Space, ypos,contentWidth , K_TitleHeight)];
            self.titleLab.font = K_Font;
            self.titleLab.text = title;
            self.titleLab.backgroundColor = [UIColor clearColor];
            [self addSubview:self.titleLab];
            
            ypos +=self.titleLab.frame.size.height;
            
            UIView* sepView = [[UIView alloc] initWithFrame:CGRectMake(0, ypos, self.frame.size.width, 1)];
            [self addSubview:sepView];
            [mutableArr addObject:sepView];
            
            ypos += sepView.bounds.size.height;

        }
        
        
        //内容
        {
            CGFloat contentHeight = self.bounds.size.height - ypos - K_ButtonHeight;
            self.contentLab = [[UILabel alloc] initWithFrame:CGRectMake(K_Space, ypos, contentWidth, contentHeight)];
            self.contentLab.backgroundColor = [UIColor clearColor];
            self.contentLab.font = K_contentFont;
            self.contentLab.text = contentStr;
            self.contentLab.textAlignment = NSTextAlignmentCenter;
            self.contentLab.adjustsFontSizeToFitWidth = YES;
            self.contentLab.lineBreakMode = NSLineBreakByWordWrapping;
            self.contentLab.numberOfLines = 0;
            [self addSubview:self.contentLab];
            
            ypos += self.contentLab.bounds.size.height;
        }
        
        //按钮
        {
            UIView* sepView = [[UIView alloc] initWithFrame:CGRectMake(0, ypos, self.frame.size.width, 1)];
            [self addSubview:sepView];
            [mutableArr addObject:sepView];

            __weak CMOneAlertButtonView *alert = self;
            self.sureButton = [CMAlertButton buttonWithType:UIButtonTypeCustom];
            [((CMAlertButton*) self.sureButton) setDismissBlock:^
             {
                 [alert dismiss];
             }];
            self.sureButton.frame = CGRectMake(K_Space, ypos, contentWidth, K_ButtonHeight);
            [self.sureButton setTitle:@"确定" forState:UIControlStateNormal];
            [self.sureButton addTarget:self action:@selector(btnAction) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:self.sureButton];
        }
        m_sepLineViewArr = [NSArray arrayWithArray:mutableArr];
    }
    return self;
}

#pragma mark - action

-(void)btnAction
{
    //此处什么也不做
}

-(void)dismiss
{
    CMAlertWindow *alsertWindow = [self getAlertWindow];
    if(nil != alsertWindow)
    {
        [alsertWindow dismissView];
    }
    else
    {
        CMAlertViewController *controller =  (CMAlertViewController*)[self viewController];
        [controller dismissController];
    }
}

#pragma mark - 重写setter和getter函数

@dynamic sepColor;
-(void)setSepColor:(UIColor *)sepColor
{
    for(UIView *sepview in m_sepLineViewArr)
    {
        sepview.backgroundColor = sepColor;
    }
}

-(UIColor*)sepColor
{
    UIView *firstview = m_sepLineViewArr.firstObject;
    return firstview.backgroundColor;
}

#pragma mark - private

-(CMAlertWindow*)getAlertWindow
{
    for(UIView *superView = self.superview; nil != superView ; superView = superView.superview)
    {
        if(YES == [superView isKindOfClass:[CMAlertWindow class]])
        {
            return (CMAlertWindow*)superView;
        }
    }
    return nil;
}

-(UIViewController*)viewController
{
    for(UIView *next = [self superview];next; next = next.superview)
    {
        UIResponder *nextResPonder = [next nextResponder];
        if(YES == [nextResPonder isKindOfClass:[UIViewController class]])
        {
            return (UIViewController*)nextResPonder;
        }
    }
    return nil;
}

@end
