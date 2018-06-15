//
//  CMScrollTableViewCell.m
//  ViewTools
//
//  Created by bingo on 15/11/4.
//  Copyright © 2015年 CM. All rights reserved.
//

#import "CMScrollTableViewCell.h"
#import "CMColumnScrollView.h"

@interface CMScrollTableViewCell ()<CMColumnScrollViewDelegate>
{
    CMColumnScrollView *m_scrollCellView;
    UIView  *m_sepLineLine;
}
@property(nonatomic,readonly) NSUInteger mColCount;
@property(nonatomic,readonly) CGFloat sepLineHeight;

@end

@implementation CMScrollTableViewCell

-(nonnull instancetype)initWidthColWidth:(nonnull NSArray<__kindof NSNumber*>*)colWidths reuseIdentifier:(nonnull NSString*)reuseIdentifier
{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if (nil != self)
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
        _mColCount = colWidths.count;
        _sepLineHeight = 1 / [UIScreen mainScreen].scale;
        
        m_scrollCellView = [[CMColumnScrollView alloc] initWithFrame:self.contentView.bounds andFixCol:1];
        [m_scrollCellView createContentColWidth:colWidths andDelegate:self];
        [self.contentView addSubview:m_scrollCellView];
        
        
        m_sepLineLine= [[UIView alloc] initWithFrame:CGRectMake(0.0, self.bounds.size.height - self.sepLineHeight, self.bounds.size.width, self.sepLineHeight)];
        m_sepLineLine.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:m_sepLineLine];
    }
    return self;
}


#pragma mark - public

-(void)setContentFont:(nonnull UIFont*)font
{
    NSArray *viewArr = [m_scrollCellView getAllView];
    for(UILabel *lab in viewArr)
    {
        lab.font = font;
    }
}


-(void)setSepLineColor:(nonnull UIColor*)sepColor
{
    m_sepLineLine.backgroundColor = sepColor;
}

-(void)setContent:(nonnull NSArray<__kindof CMScrollTableViewCellData*> *)contentArr
{
    for(NSUInteger i = 0; i<contentArr.count;i++)
    {
        CMScrollTableViewCellData *cellData = [contentArr objectAtIndex:i];
        UIView *subView = [m_scrollCellView getsubViewAtCol:i];
        if(nil != subView && YES == [subView isKindOfClass:[UILabel class]])
        {
            UILabel *lab = (UILabel*)subView;
            lab.text = cellData.cellContentStr;
            lab.backgroundColor = cellData.cellBackgroudColor;
            lab.textColor = cellData.cellTextColor;
        }
    }
}


-(void)setScrollBlock:(nonnull void (^)(CGFloat scrollOffset)) scrollblock
{
    [m_scrollCellView setScrollBlock:scrollblock];
}

#pragma mark - CMColumnScrollViewDelegate

-(nonnull UIView*)CMColumnScrollView:(nonnull CMColumnScrollView*)CMScrollCell contentViewAtCol:(NSUInteger)col
{
    UILabel *fixLab = [[UILabel alloc] init];
    fixLab.backgroundColor = [UIColor clearColor];
    fixLab.textColor =[UIColor blackColor]; //默认颜色，可以通过外部设置
    fixLab.font = [UIFont systemFontOfSize:18];
    fixLab.textAlignment = NSTextAlignmentCenter;
    if(0 == col)
    {
        fixLab.textAlignment = NSTextAlignmentLeft;
        fixLab.lineBreakMode = NSLineBreakByTruncatingTail;
    }
    return fixLab;
}

-(UIEdgeInsets)CMColumnScrollView:(nonnull CMColumnScrollView*)CMScrollCell edgeInsetForCol:(NSUInteger)col inBounds:(CGRect)bounds
{
    if(nil != self.scrollTableViewDelegate && YES == [self.scrollTableViewDelegate respondsToSelector:@selector(CMScrollTableViewCell:edgeInsetForCol:inBounds:)])
    {
        __unsafe_unretained CMScrollTableViewCell *scrollTableCell = self;
        return [self.scrollTableViewDelegate CMScrollTableViewCell:scrollTableCell edgeInsetForCol:col inBounds:bounds];
    }
    return UIEdgeInsetsZero;
}

-(void)CMColumnScrollViewStartScroll:(nonnull CMColumnScrollView*)CMScrollCell
{
    if(nil != self.scrollTableViewDelegate && YES == [self.scrollTableViewDelegate respondsToSelector:@selector(CMScrollTableViewCellStartScroll:)])
    {
        __unsafe_unretained CMScrollTableViewCell *scrollTableCell = self;
       [self.scrollTableViewDelegate CMScrollTableViewCellStartScroll:scrollTableCell];
    }
}

-(void)CMColumnScrollViewEndScroll:(nonnull CMColumnScrollView*)CMScrollCell
{
    if(nil != self.scrollTableViewDelegate && YES == [self.scrollTableViewDelegate respondsToSelector:@selector(CMScrollTableViewCellEndScroll:)])
    {
        __unsafe_unretained CMScrollTableViewCell *scrollTableCell = self;
        [self.scrollTableViewDelegate CMScrollTableViewCellEndScroll:scrollTableCell];
    }
}


#pragma mark - 重写setter和getter函数

-(void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    
    if( nil != m_scrollCellView)
    {
        m_scrollCellView.frame = self.bounds;
        m_sepLineLine.frame = CGRectMake(0.0, self.bounds.size.height - self.sepLineHeight, self.bounds.size.width, self.sepLineHeight);
    }
}

@dynamic cellOffset;
-(void)setCellOffset:(CGFloat)cellOffset
{
    [m_scrollCellView setCellOffset:cellOffset];
}
-(CGFloat)cellOffset
{
    return m_scrollCellView.offset;
}

@dynamic selBgColor;
-(void)setSelBgColor:(UIColor *)selBgColor
{
    m_scrollCellView.selectedBackColor = selBgColor;
}

-(UIColor*)selBgColor
{
    return m_scrollCellView.selectedBackColor;
}

@dynamic maxOffset;
-(CGFloat)maxOffset
{
    return m_scrollCellView.maxOffset;
}

@end

#pragma mark -
#pragma mark *****************************************
#pragma mark CMScrollTableViewCellData
#pragma mark *****************************************
#pragma mark -

@implementation CMScrollTableViewCellData

-(instancetype)init
{
    self = [super init];
    if(nil != self)
    {
        self.cellTextColor = [UIColor blackColor]; //默认颜色，可以通过外部设置
        self.cellBackgroudColor = [UIColor clearColor];
        self.cellContentStr = @"";
    }
    return self;
}

-(nonnull instancetype)copy
{
    CMScrollTableViewCellData *cellData = [[CMScrollTableViewCellData alloc] init];
    cellData.cellTextColor = self.cellTextColor;
    cellData.cellBackgroudColor = self.cellBackgroudColor;
    cellData.cellContentStr = self.cellContentStr;
    return cellData;
}

@end
