//
//  CMColumnScrollView.m
//  ViewTools
//
//  Created by bingo on 15/11/3.
//  Copyright © 2015年 CM. All rights reserved.
//

#import "CMColumnScrollView.h"

#pragma mark -
#pragma mark **********************************
#pragma mark CM_UIScrollView(内部类)
#pragma mark **********************************
#pragma mark -


@interface CM_UIScrollView : UIScrollView

@end

@implementation CM_UIScrollView

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    [[[self nextResponder] nextResponder] touchesBegan:touches withEvent:event];  //需要通过两级传递，才能传给CMColumnScrollView
}

-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesCancelled:touches withEvent:event];
    [[[self nextResponder] nextResponder]  touchesCancelled:touches withEvent:event];
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
    [[[self nextResponder] nextResponder]  touchesEnded:touches withEvent:event];
}

@end

#pragma mark -
#pragma mark **********************************
#pragma mark  CMColumnScrollView
#pragma mark **********************************
#pragma mark -


#define  K_TAG_Content  3000
typedef void (^ScrollBlock)(CGFloat scrollOffset);

@interface CMColumnScrollView ()<UIScrollViewDelegate>
{
    UIView *m_contentView;
    UIScrollView *m_scrollView;
    ScrollBlock m_scrollBlock;
    bool m_hadScrollEnd;  //是否已经调用了结束拖拽函数
}
@property(nonatomic,weak) id<CMColumnScrollViewDelegate> columnDelegate;
@property(nonatomic,retain,nullable) NSArray<__kindof NSNumber*> *colWidthsArr; //列宽
@property(nonatomic,readonly) NSUInteger mFixCols;  //固定行数

@end


@implementation CMColumnScrollView

-(nonnull instancetype)initWithFrame:(CGRect)frame andFixCol:(NSUInteger)fixColCount
{
    self = [super initWithFrame:frame];
    if(nil!=self)
    {
        self.backgroundColor = [UIColor clearColor];
        
        m_contentView = [[UIView alloc] initWithFrame:self.bounds];
        m_contentView.backgroundColor = [UIColor clearColor];
        [self addSubview:m_contentView];
        
        _mFixCols = fixColCount;
        self.selectedBackColor = nil;
        m_hadScrollEnd = true;
    }
    return self;
}

#pragma mark - public

//创建内容
-(BOOL)createContentColWidth:(nonnull NSArray<__kindof NSNumber*>*) colWidths andDelegate:(nonnull id<CMColumnScrollViewDelegate>)delegate
{
    if(NO == [delegate conformsToProtocol:@protocol(CMColumnScrollViewDelegate)])
    {
        return NO;
    }
    self.colWidthsArr = colWidths;
    self.columnDelegate = delegate;
    if(NO == [self canCreateView])
    {
        return NO;
    }
    [self clearOldView];
    NSArray<__kindof UIView*> *viewArr = [self createNewView];
    [self distributeSubView:viewArr];
    [self modifySubViewFrame];
    return YES;
}

//获取所有的视图,用于更新数据时用（视图是按照列的顺序来显示的）
-(nonnull NSArray<__kindof UIView*>*)getAllView
{
    NSMutableArray *arr = [NSMutableArray array];
    
    for(NSUInteger i = 0; i<self.colWidthsArr.count;i++)
    {
        UIView *subView = [self getsubViewAtCol:i];
        if(nil != subView)
        {
            [arr addObject:subView];
        }
    }
    return [NSArray arrayWithArray:arr];
}

//获取对应列的视图
-(nullable UIView*)getsubViewAtCol:(NSUInteger)col
{
    return [m_contentView viewWithTag:K_TAG_Content + col];
}

-(void)setCellOffset:(CGFloat)cellOffset
{
    m_scrollView.contentOffset = CGPointMake(cellOffset, 0);
}

-(void)setScrollBlock:(nonnull void (^)(CGFloat scrollOffset)) scrollblock
{
    m_scrollBlock = scrollblock;
}

#pragma mark - UIScrollViewDelegate

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if(nil != self.columnDelegate && YES == [self.columnDelegate respondsToSelector:@selector(CMColumnScrollViewStartScroll:)])
    {
        __unsafe_unretained CMColumnScrollView *colScrollView = self;
        [self.columnDelegate CMColumnScrollViewStartScroll:colScrollView];
    }
}
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if(!m_hadScrollEnd)  //没有调用结束滑动
    {
        if(nil != self.columnDelegate && YES == [self.columnDelegate respondsToSelector:@selector(CMColumnScrollViewEndScroll:)])
        {
            __unsafe_unretained CMColumnScrollView *colScrollView = self;
            [self.columnDelegate CMColumnScrollViewEndScroll:colScrollView];
        }
        m_hadScrollEnd = true;
    }
}
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
   if(NO == decelerate) //没有加速度时
   {
       if(nil != self.columnDelegate && YES == [self.columnDelegate respondsToSelector:@selector(CMColumnScrollViewEndScroll:)])
       {
           __unsafe_unretained CMColumnScrollView *colScrollView = self;
           [self.columnDelegate CMColumnScrollViewEndScroll:colScrollView];
       }
   }
   else
   {
        m_hadScrollEnd = false;
   }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView;
{
    if(nil != m_scrollBlock)
    {
        m_scrollBlock(scrollView.contentOffset.x);
    }
}
-(void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    //修改终点位置
    CGFloat targetX = 0;
    for(NSUInteger i = self.mFixCols;i<self.colWidthsArr.count;i++)
    {
        CGFloat desx = targetX + [[self.colWidthsArr objectAtIndex:i] floatValue];
        if(targetX < targetContentOffset->x && targetContentOffset->x < desx)
        {
            if(targetContentOffset->x - targetX > desx - targetContentOffset->x)  //距离后面一个目标更近
            {
                targetContentOffset->x = desx;
            }
            else
            {
                targetContentOffset->x = targetX;
            }
            break;
        }
        else
        {
            targetX = desx;
        }
    }

}

#pragma mark - 重写setter和getter函数

-(void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    if(nil != m_contentView)
    {
        m_contentView.frame = self.bounds;
        
        

        
        if(nil != m_scrollView)
        {
            CGRect scrollFrame = m_scrollView.frame;
            CGFloat fixColWidth = 0;
            for(NSUInteger i=0;i<self.mFixCols;i++)
            {
                fixColWidth += [[self.colWidthsArr objectAtIndex:i] floatValue];
            }
            scrollFrame.size.height = self.bounds.size.height;
            scrollFrame.size.width  = self.bounds.size.width - fixColWidth;
            scrollFrame.origin.x = fixColWidth;
            m_scrollView.frame = scrollFrame;
        }
        
        [self modifySubViewFrame];
    }
}

@dynamic maxOffset;
-(CGFloat)maxOffset
{
    return m_scrollView.contentSize.width - m_scrollView.bounds.size.width;
}

@dynamic offset;
-(CGFloat)offset
{
    return m_scrollView.contentOffset.x;
}

#pragma mark - private

-(BOOL)canCreateView
{
    if(nil == self.columnDelegate)
    {
        return NO;
    }
    if(nil == self.colWidthsArr || self.colWidthsArr.count < self.mFixCols)
    {
        return NO;
    }
    return YES;
}

-(void)clearOldView
{
    //清除原来的视图
    for(UIView *view in m_contentView.subviews)
    {
        if(view != m_scrollView)
        {
            [view removeFromSuperview];
        }
    }
    
    //清除scrollView中的视图
    for(UIView *view in m_scrollView.subviews)
    {
        [view removeFromSuperview];
    }
}

-(nonnull NSArray<__kindof UIView*>*)createNewView
{
    //创建新视图
    NSMutableArray *viewArr = [NSMutableArray array];
    {
        for(NSUInteger i=0;i<self.colWidthsArr.count;i++)
        {
            __unsafe_unretained CMColumnScrollView *scrollColview = self;
            UIView *subView = [self.columnDelegate CMColumnScrollView:scrollColview contentViewAtCol:i];
            subView.tag = K_TAG_Content + i;
            subView.clipsToBounds = YES;
            [viewArr addObject:subView];
        }
    }
    return viewArr;
}

//分配视图
-(void)distributeSubView:(nonnull NSArray<__kindof UIView*>*)viewArr
{
    CGFloat fixColWidth = 0;
    for(NSUInteger i=0;i<self.mFixCols;i++)
    {
        [m_contentView addSubview:[viewArr objectAtIndex:i]];
        fixColWidth += [[self.colWidthsArr objectAtIndex:i] floatValue];
    }
    if(self.mFixCols < self.colWidthsArr.count)
    {
        if(nil == m_scrollView)
        {
            m_scrollView = [[CM_UIScrollView alloc] initWithFrame:self.bounds];
            m_scrollView.backgroundColor = [UIColor clearColor];
            m_scrollView.bounces = NO;
            m_scrollView.showsHorizontalScrollIndicator = NO;
            m_scrollView.showsVerticalScrollIndicator = NO;
            m_scrollView.delegate = self;
            m_scrollView.decelerationRate = 0.9;
            [m_contentView addSubview:m_scrollView];
        }
        CGFloat scrollWidth = 0;
        for(NSUInteger i = self.mFixCols;i<self.colWidthsArr.count;i++)
        {
            [m_scrollView addSubview:[viewArr objectAtIndex:i]];
            scrollWidth += [[self.colWidthsArr objectAtIndex:i] floatValue];
        }
        
        CGRect scrollFrame = self.bounds;
        scrollFrame.origin.x = fixColWidth;
        scrollFrame.size.width -=fixColWidth;
        m_scrollView.frame = scrollFrame;
        [m_scrollView setContentSize:CGSizeMake(scrollWidth, 0)];
    }
    else
    {
        [m_scrollView removeFromSuperview];
        m_scrollView = nil;
    }
}

//修改所有视图的frame
-(void)modifySubViewFrame
{
    for(NSUInteger i=0;i<self.colWidthsArr.count;i++)
    {
        UIView *subView = [self getsubViewAtCol:i];
        NSAssert(nil != subView, @"获取不到滚动行的内容");
        subView.frame = [self getFrameAtCol:i];
    }
}

-(CGRect)getFrameAtCol:(NSUInteger)col
{
    CGRect frame = CGRectZero;
    NSUInteger startCol = col < self.mFixCols ? 0 : self.mFixCols;
    CGFloat xpos = 0;
    for(NSUInteger i = startCol;i<col;i++)
    {
        xpos += [[self.colWidthsArr objectAtIndex:i] floatValue];
    }
    frame =  CGRectMake(xpos, 0, [[self.colWidthsArr objectAtIndex:col] floatValue], self.bounds.size.height);
    
    if(nil != self.columnDelegate && YES == [self.columnDelegate respondsToSelector:@selector(CMColumnScrollView:edgeInsetForCol:inBounds:)])
    {
        __unsafe_unretained CMColumnScrollView *scrollColview = self;
        UIEdgeInsets edgeInset = [self.columnDelegate CMColumnScrollView:scrollColview edgeInsetForCol:col inBounds:frame];
        frame = UIEdgeInsetsInsetRect(frame, edgeInset);
    }
    return frame;
}

#pragma mark - 手势触摸相关

-(void)touchesBegan
{
    if(nil != self.selectedBackColor)
    {
        self.backgroundColor = self.selectedBackColor;
    }
}

-(void)touchesEnd
{
    if(nil != self.selectedBackColor)
    {
        self.backgroundColor = [UIColor clearColor];
    }
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self touchesBegan];
    [super touchesBegan:touches withEvent:event];
}

-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self touchesEnd];
    [super touchesCancelled:touches withEvent:event];
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self touchesEnd];
    [super touchesEnded:touches withEvent:event];
}


@end









