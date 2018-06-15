//
//  CMScrollTitleView.m
//  ViewTools
//
//  Created by bingo on 15/11/4.
//  Copyright © 2015年 CM. All rights reserved.
//

#import "CMScrollTitleView.h"
#import "CMViewDataOper.h"

#define  K_fHighLightView2Bot  2
#define  K_HighLightViewHeight 1.5

typedef void (^ClickBlock)(NSUInteger clickIndex);

@interface CMScrollTitleView ()<UIScrollViewDelegate>
{
    ClickBlock m_Click;
    CALayer *m_maskLayer;  //遮罩图层，用于显示左右两侧的半透明效果
}
@property(nonatomic,readonly) CGFloat maskWidth; //遮罩部分宽度
@property(nonatomic,retain,nonnull) NSArray<__kindof NSNumber*> *titleWidthsArr; //标题距离
@property(nonatomic) NSUInteger leftFixTitleCount; //左侧固定的数量
@property(nonatomic) NSUInteger rightFixTitleCount; //右侧固定的数量
@property(nonatomic,readonly,retain,nonnull) UIView *highLightView;
@property(nonatomic,readonly,retain,nonnull) UIScrollView *scrollContentView; //滑动视图
@property(nonatomic,readonly,retain,nonnull) UIView *leftFixContentView; //视图左侧固定部分
@property(nonatomic,readonly,retain,nonnull) UIView *rightFixContentView; //视图右侧固定部分

@end

@implementation CMScrollTitleView

#pragma mark -初始化和销毁

-(nonnull instancetype)initWithFrame:(CGRect)frame
{
    return [self initWithFrame:frame rightFixCount:0 leftFixCount:0];
}

//rightFix:右侧固定栏目个数
-(nonnull instancetype)initWithFrame:(CGRect)frame rightFixCount:(NSUInteger)fixCount
{
    return [self initWithFrame:frame rightFixCount:fixCount leftFixCount:0];
}

//rightFix:右侧固定栏目个数 ,leftFixCount：左侧固定栏目个数
-(nonnull instancetype)initWithFrame:(CGRect)frame rightFixCount:(NSUInteger)rightFixCount leftFixCount:(NSUInteger)leftFixCount
{
    self = [super initWithFrame:frame];
    if (nil != self)
    {
        self.titleFont = [UIFont systemFontOfSize:15];
        self.titleColor = [UIColor blackColor]; //默认颜色，可以通过外部设置
        self.selectedTitleColor = [UIColor blueColor]; //默认颜色，可以通过外部设置
        self.leftFixTitleCount = leftFixCount;
        self.rightFixTitleCount = rightFixCount;
        _maskWidth = 30;
    }
    return self;
    
}

#pragma mark - public函数

-(void)setSelectedSignViewColor:(nonnull UIColor*)color
{
    self.highLightView.backgroundColor = color;
}

-(void)setClick:(nonnull void (^)(NSUInteger clickIndex)) clickblock
{
    m_Click = clickblock;
}

-(void)setSelectedIndex:(NSUInteger)selectedIndex OnClick:(BOOL)bonClick  //bOnClick表示是否会触发点击事件
{
    if(selectedIndex >= self.titleArray.count) //越界处理
    {
        selectedIndex = self.titleArray.count > 0 ? self.titleArray.count - 1 : 0;
    }
    _selectedIndex = selectedIndex;
    [self setBtnSelectedOfIndex:_selectedIndex];
    if(YES == bonClick)
    {
        [self doSelectedAction];
    }
}

-(void)doSelectedAction //触发选中事件
{
    if(nil != m_Click)
    {
        m_Click(self.selectedIndex);
    }
}


#pragma mark -按钮点击

- (void)onClick:(nonnull UIButton *)sender
{
    [self setBtnSelectedOfIndex:sender.tag - 1];
    [self doSelectedAction];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self changeGradientColor:scrollView.contentOffset.x];
}

#pragma mark - 重写setter和getter函数

@synthesize highLightView = _highLightView;
-(UIView*)highLightView
{
    if(nil == _highLightView)
    {
        _highLightView = [[UIView alloc] initWithFrame:CGRectMake(0.0, self.bounds.size.height - K_HighLightViewHeight - K_fHighLightView2Bot,0, K_HighLightViewHeight)];
        _highLightView.backgroundColor = [UIColor clearColor];
        if(self.leftFixTitleCount > 0)
        {
            [self addSubview:_highLightView];
        }
        else
        {
            [self.scrollContentView addSubview:_highLightView];
        }
    }
    return _highLightView;
}

@synthesize scrollContentView = _scrollContentView;
-(UIScrollView*)scrollContentView
{
    if(nil == _scrollContentView)
    {
        _scrollContentView = [[UIScrollView alloc] initWithFrame:self.bounds];
        _scrollContentView.backgroundColor = [UIColor clearColor];
        _scrollContentView.delegate =self;
        _scrollContentView.alwaysBounceVertical = NO;
        _scrollContentView.bounces = NO;
        _scrollContentView.showsHorizontalScrollIndicator = NO;
        _scrollContentView.showsVerticalScrollIndicator = NO;
        [self addSubview:_scrollContentView];
        
        m_maskLayer = [CALayer layer];
        m_maskLayer.bounds = _scrollContentView.frame;
        m_maskLayer.position = self.scrollContentView.center;
        m_maskLayer.opacity = 0.9;
        [self.layer addSublayer:m_maskLayer];
        
        CAGradientLayer *gradientLayer = [CAGradientLayer layer];
        gradientLayer.bounds = m_maskLayer.bounds;
        gradientLayer.position = CGPointMake(gradientLayer.bounds.size.width/2, gradientLayer.bounds.size.height/2);
        gradientLayer.startPoint = CGPointMake(0, 0.5);
        gradientLayer.endPoint = CGPointMake(1, 0.5);
        m_maskLayer.mask = gradientLayer;
        
        [self setmaskColor:self.backgroundColor];
        
    }
    return _scrollContentView;
}

@synthesize leftFixContentView = _leftFixContentView;
-(UIView*)leftFixContentView
{
    if(nil == _leftFixContentView)
    {
        _leftFixContentView = [[UIView alloc] initWithFrame:self.bounds];
        [self addSubview:_leftFixContentView];
    }
    return _leftFixContentView;
}

@synthesize rightFixContentView = _rightFixContentView;
-(UIView*)rightFixContentView
{
    if(nil == _rightFixContentView)
    {
        _rightFixContentView = [[UIView alloc] initWithFrame:self.bounds];
        [self addSubview:_rightFixContentView];
    }
    return _rightFixContentView;
}

-(void)setTitleArray:(NSArray<__kindof NSString *> *)titleArray
{
    _titleArray = titleArray;
    
    //计算按钮宽度
    [self calBtnWidth:titleArray];
    
    //构造容器视图
    {
        if(self.leftFixTitleCount + self.rightFixTitleCount >= titleArray.count)
        {
            self.leftFixTitleCount = 0;
            self.rightFixTitleCount = 0;
        }
        
        //计算各个视图的宽度
        CGFloat leftFixWidth = 0;
        CGFloat rightFixWidth = 0;
        CGFloat scrollContentWidth = 0;
        for(NSUInteger i = 0; i < self.leftFixTitleCount;i++)
        {
            leftFixWidth += [self.titleWidthsArr[i] doubleValue];
        }
        for(NSUInteger i = self.leftFixTitleCount;i < self.titleWidthsArr.count - self.rightFixTitleCount;i++)
        {
            scrollContentWidth += [self.titleWidthsArr[i] doubleValue];
        }
        for(NSUInteger i = self.titleWidthsArr.count - self.rightFixTitleCount; i < self.titleWidthsArr.count ; i++)
        {
            rightFixWidth += [self.titleWidthsArr[i] doubleValue];
        }
        
        //添加视图或者修改视图范围
        {
            CGRect frame = self.leftFixContentView.frame;
            frame.size.width = leftFixWidth;
            self.leftFixContentView.frame = frame;
        }
        {
            CGRect frame = self.rightFixContentView.frame;
            frame.size.width = rightFixWidth;
            frame.origin.x = self.bounds.size.width - rightFixWidth;
            self.rightFixContentView.frame = frame;
        }
        {
            [self updateScrollViewFrame];
            [self.scrollContentView setContentSize:CGSizeMake(scrollContentWidth, self.scrollContentView.bounds.size.height)];
        }
    }
    
    //创建按钮
    [self createBtn:self.titleWidthsArr WidthTitles:titleArray];
    
    //选中第一个标签
    self.selectedIndex = 0;
}

-(void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    if(nil != _highLightView)
    {
        CGRect lineViewframe = self.highLightView.frame;
        lineViewframe.origin.y = self.bounds.size.height - lineViewframe.size.height - K_fHighLightView2Bot;
        self.highLightView.frame = lineViewframe;
    }
    if(nil == _scrollContentView)
    {
        return;
    }
    
    //更新视图容器大小
    {
        CGRect leftFixframe = self.leftFixContentView.frame;
        leftFixframe.size.height = self.bounds.size.height;
        self.leftFixContentView.frame = leftFixframe;
        
        CGRect scrollframe = self.scrollContentView.frame;
        scrollframe.size.height = self.bounds.size.height;
        scrollframe.size.width = self.bounds.size.width - (self.leftFixContentView.bounds.size.width + self.rightFixContentView.bounds.size.width);
        self.scrollContentView.frame = scrollframe;
        
        CGRect rightFixFrame = self.rightFixContentView.frame;
        rightFixFrame.size.height = self.bounds.size.height;
        rightFixFrame.origin.x = self.scrollContentView.frame.origin.x + self.scrollContentView.frame.size.width;
        self.rightFixContentView.frame = rightFixFrame;
        [self updateScrollViewFrame];
    }
    
    //更新容器内视图大小
    NSArray<__kindof UIView*> *containerViewArr = @[self.leftFixContentView,self.scrollContentView,self.rightFixContentView];
    for(UIView *containerView in containerViewArr)
    {
        for(UIView *subview in containerView.subviews)
        {
            if(NO == [subview isKindOfClass:[UIButton class]])  //只修改按钮大小
            {
                continue;
            }
            CGRect subframe = subview.frame;
            subframe.size.height = containerView.bounds.size.height;
            subview.frame = subframe;
        }
    }
    
    [self changeGradientColor:self.scrollContentView.contentOffset.x];
}

-(void)setSelectedIndex:(NSUInteger)selectedIndex
{
    [self setSelectedIndex:selectedIndex OnClick:YES];
}

-(void)setTitleFont:(UIFont *)titleFont
{
    _titleFont = titleFont;
    if(nil == _scrollContentView)
    {
        return;
    }
    NSArray<__kindof UIView*> *containerViewArr = @[self.leftFixContentView,self.scrollContentView,self.rightFixContentView];
    for(UIView *containerView in containerViewArr)
    {
        for(UIView *subview in containerView.subviews)
        {
            if(YES == [subview isKindOfClass:[UIButton class]])
            {
                UIButton *button = (UIButton*)(subview);
                button.titleLabel.font = titleFont;
            }
        }
    }
}

-(void)setTitleColor:(UIColor *)titleColor
{
    _titleColor = titleColor;
    if(nil == _scrollContentView)
    {
        return;
    }
    NSArray<__kindof UIView*> *containerViewArr = @[self.leftFixContentView,self.scrollContentView,self.rightFixContentView];
    for(UIView *containerView in containerViewArr)
    {
        for(UIView *subview in containerView.subviews)
        {
            if(YES == [subview isKindOfClass:[UIButton class]])
            {
                UIButton *button = (UIButton*)(subview);
                [button setTitleColor:titleColor forState:UIControlStateNormal];
            }
        }
    }
}

-(void)setSelectedTitleColor:(UIColor *)selectedTitleColor
{
    _selectedTitleColor = selectedTitleColor;
    if(nil == _scrollContentView)
    {
        return;
    }
    NSArray<__kindof UIView*> *containerViewArr = @[self.leftFixContentView,self.scrollContentView,self.rightFixContentView];
    for(UIView *containerView in containerViewArr)
    {
        for(UIView *subview in containerView.subviews)
        {
            if(YES == [subview isKindOfClass:[UIButton class]])
            {
                UIButton *button = (UIButton*)(subview);
                [button setTitleColor:selectedTitleColor forState:UIControlStateSelected];
            }
        }
    }
}

-(void)setBackgroundColor:(UIColor *)backgroundColor
{
    [super setBackgroundColor:backgroundColor];
    [self setmaskColor:backgroundColor];
}


#pragma mark - private

- (void)moveHighlightedViewTo:(CGFloat) x AndChangeWidth:(CGFloat)width
{
    [UIView beginAnimations:@"highlightedView" context:nil];
    [UIView setAnimationDuration:0.3];
    CGRect rect = self.highLightView.frame;
    rect.origin.x = x;
    rect.size.width = width;
    self.highLightView.frame = rect;
    [UIView commitAnimations];
}

-(void)setBtnSelectedOfIndex:(NSUInteger)selectedIndex
{
    _selectedIndex = selectedIndex;
    UIButton *selectedBtn = [self modifyBtnSelectedState:selectedIndex];
    if(selectedIndex >= self.leftFixTitleCount && selectedIndex < self.titleArray.count - self.rightFixTitleCount) //在scrollView中
    {
        if(YES == [self bInscrollView])
        {
            [self moveInScrollView:selectedBtn];
        }
        else
        {
            [self moveSelfToScrollView:selectedBtn];
        }
    }
    else
    {
        if(YES == [self bInscrollView])
        {
            [self moveScrollViewToSelf:selectedBtn];
        }
        else
        {
            [self moveInSelf:selectedBtn];
        }
    }
}

-(BOOL)bInscrollView
{
    return self.highLightView.superview != self;
}

-(void)moveSelfToScrollView:(UIButton*)selectedBtn
{
    CGRect frame = [self convertRect:self.highLightView.frame toView:self.scrollContentView];
    self.highLightView.frame = frame;
    [self.highLightView removeFromSuperview];
    [self.scrollContentView addSubview:self.highLightView];
    [self moveInScrollView:selectedBtn];
}

-(void)moveScrollViewToSelf:(UIButton*)selectedBtn
{
    CGRect frame = [self convertRect:self.highLightView.frame fromView:self.scrollContentView];
    self.highLightView.frame = frame;
    [self.highLightView removeFromSuperview];
    [self addSubview:self.highLightView];
    
    [self moveInSelf:selectedBtn];
}

-(void)moveInScrollView:(UIButton*)selectedBtn
{
    if(self.scrollContentView.contentSize.width <= self.scrollContentView.bounds.size.width + 0.5) //滚动范围足够,+0.5防止浮点比较错误
    {
        [self.scrollContentView setContentOffset:CGPointMake(0,0) animated:NO];
    }
    else
    {
        CGFloat scrollViewCenterX = self.scrollContentView.bounds.size.width/2;
        if(selectedBtn.center.x < scrollViewCenterX )
        {
            [self.scrollContentView setContentOffset:CGPointMake(0,0) animated:NO];
        }
        else if(selectedBtn.center.x < self.scrollContentView.contentSize.width - scrollViewCenterX)
        {
            //需要滚动视图
            [self.scrollContentView setContentOffset:CGPointMake((selectedBtn.center.x - scrollViewCenterX),0) animated:YES];
        }
        else
        {
            [self.scrollContentView setContentOffset:CGPointMake((self.scrollContentView.contentSize.width - self.scrollContentView.bounds.size.width),0) animated:NO];
        }
    }
    CGFloat width = [CMViewDataOper getFontWidthStr:selectedBtn.currentTitle withFont:self.titleFont];
    CGFloat xoffset =(selectedBtn.bounds.size.width - width)/2;
    [self moveHighlightedViewTo:selectedBtn.frame.origin.x + xoffset AndChangeWidth:width];
}

-(void)moveInSelf:(UIButton*)selectedBtn
{
    CGRect selectedFrame = [self convertRect:selectedBtn.frame fromView:selectedBtn.superview];
    CGFloat width = [CMViewDataOper getFontWidthStr:selectedBtn.currentTitle withFont:self.titleFont];
    CGFloat xoffset =(selectedFrame.size.width - width)/2;
    [self moveHighlightedViewTo:selectedFrame.origin.x + xoffset AndChangeWidth:width];
}


//修改按钮的选中状态
-(UIButton*)modifyBtnSelectedState:(NSUInteger)selectedIndex
{
    UIButton *selectedBtn = nil;
    NSArray<__kindof UIView*> *allBtnContainer = @[self.leftFixContentView,self.scrollContentView,self.rightFixContentView];
    NSUInteger curBtnIndex = 0;
    for(UIView *btnContainer in allBtnContainer)
    {
        for(UIView *subview in btnContainer.subviews)
        {
            if(NO == [subview isKindOfClass:[UIButton class]])
            {
                continue;
            }
            UIButton *btn = (UIButton*)subview;
            btn.selected = NO;
            if(selectedIndex == curBtnIndex)
            {
                selectedBtn = btn;
            }
            curBtnIndex ++;
        }
    }
    selectedBtn.selected = YES;
    return selectedBtn;

}

-(void)updateScrollViewFrame
{
    CGFloat orignX = self.leftFixContentView.frame.origin.x + self.leftFixContentView.frame.size.width;
    CGFloat width = self.rightFixContentView.frame.origin.x - orignX;
    CGRect frame = self.scrollContentView.frame;
    frame.origin.x = orignX;
    frame.size.width = width > 0 ? width : self.maskWidth;
    self.scrollContentView.frame = frame;
    
    m_maskLayer.bounds = self.scrollContentView.frame;
    m_maskLayer.position = self.scrollContentView.center;
    
    CAGradientLayer *gradientLayer = (CAGradientLayer*)m_maskLayer.mask;
    gradientLayer.bounds = m_maskLayer.bounds;
    gradientLayer.position = m_maskLayer.position;
}

-(void)createBtn:(NSArray<__kindof NSNumber*>*)btnWidths WidthTitles:(NSArray<__kindof NSString *> *)titleArray
{
    //清空旧的视图
    NSMutableArray<__kindof UIButton*> *btnArr = [NSMutableArray array];
    {
        NSArray<__kindof UIView*> *clearViewArr = @[self.leftFixContentView,self.scrollContentView,self.rightFixContentView];
        for(UIView *clearView in clearViewArr)
        {
            for(UIView *subview in clearView.subviews)
            {
                if(YES == [subview isKindOfClass:[UIButton class]])
                {
                    [btnArr addObject:(UIButton*)subview];
                    [subview removeFromSuperview];
                }
            }
        }
    }
    
    //构造足够的按钮
    for(NSUInteger i = btnArr.count;i < titleArray.count;i++)
    {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setBackgroundColor:[UIColor clearColor]];
        [button addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
        [button setTitleColor:self.titleColor forState:UIControlStateNormal];
        [button setTitleColor:self.selectedTitleColor forState:UIControlStateSelected];
        [button.titleLabel setFont:self.titleFont];

        [btnArr addObject:button];
    }
    
    CGFloat offsetx = 0.0;
    for (NSInteger i = 0; i < titleArray.count; ++i)
    {
        UIButton *button = btnArr.lastObject;
        [btnArr removeLastObject];
        button.tag = i + 1;
        [button setTitle:titleArray[i] forState:UIControlStateNormal];
        if (i == 0)
        {
            button.selected = YES;
        }
        CGFloat btnWidth = [btnWidths[i] floatValue];
        if(i < self.leftFixTitleCount)
        {
            button.frame = CGRectMake(offsetx, 0.0, btnWidth, self.leftFixContentView.bounds.size.height);
            [self.leftFixContentView addSubview:button];
        }
        else if(i < titleArray.count - self.rightFixTitleCount)
        {
            offsetx = self.leftFixTitleCount == i ? 0 : offsetx;
            button.frame = CGRectMake(offsetx, 0.0, btnWidth, self.scrollContentView.bounds.size.height);
            [self.scrollContentView addSubview:button];
        }
        else
        {
            offsetx = titleArray.count - self.rightFixTitleCount == i ? 0 : offsetx;
            button.frame = CGRectMake(offsetx, 0.0, btnWidth, self.rightFixContentView.bounds.size.height);
            [self.rightFixContentView addSubview:button];
        }
        offsetx +=btnWidth;
    }
}
//计算按钮宽度
-(void)calBtnWidth:(NSArray<__kindof NSString *> *)titleArray
{
    if(0 == titleArray.count)
    {
        return ;
    }
    
    NSArray *titlesWidth = [self getWidhtOfTitle:titleArray];
    
    CGFloat ftotalWidth = 0;  //所有按钮的宽度之和
    for(int i=0; i< [titlesWidth count];i++)
    {
        ftotalWidth += [[titlesWidth objectAtIndex:i] floatValue];
    }
    
    //获取按钮之间的间距
    CGFloat btnMinSpaceDist = 8;
    if(ftotalWidth + btnMinSpaceDist * titleArray.count > self.bounds.size.width)  //按钮之间的间距不够
    {
        btnMinSpaceDist = 20;
    }
    else
    {
        btnMinSpaceDist = floor((self.bounds.size.width - ftotalWidth) / [titleArray count]);
    }
    
    //计算按钮之间新的间距
    NSMutableArray *arr = [NSMutableArray array];
    for(int i=0; i< [titlesWidth count];i++)
    {
        CGFloat width = [[titlesWidth objectAtIndex:i] floatValue];
        [arr addObject:[NSNumber numberWithFloat:(width + btnMinSpaceDist)]];
    }
    self.titleWidthsArr = [NSArray arrayWithArray:arr];
}

-(NSArray *)getWidhtOfTitle:(NSArray<__kindof NSString *> *)titleArr
{
    NSMutableArray *arr = [NSMutableArray array];
    for(int i=0; i< [titleArr count]; i++)
    {
        NSString *strtitle = [titleArr objectAtIndex:i];
        CGFloat width = ceilf([CMViewDataOper getFontWidthStr:strtitle withFont:self.titleFont]);
        [arr addObject:[NSNumber numberWithFloat:width]];
    }
    return arr;
}


//设置遮罩颜色
-(void)setmaskColor:(UIColor*)maskColor;
{
    if(nil == _scrollContentView)
    {
        return;
    }
    m_maskLayer.backgroundColor = maskColor.CGColor;
    [self changeGradientColor:self.scrollContentView.contentOffset.x];
    
}

-(void)changeGradientColor:(CGFloat)offset
{
    NSArray *colorArr = nil;
    NSArray *locationArr = nil;
    if(self.scrollContentView.contentSize.width <= self.scrollContentView.bounds.size.width) //没有滚动范围
    {
        colorArr = [NSArray arrayWithObjects:(__bridge id)[UIColor clearColor].CGColor,(__bridge id)[UIColor clearColor].CGColor,nil];
        locationArr = @[@0,@1.0];
    }
    else
    {
        CGFloat maskScale = self.maskWidth / self.scrollContentView.bounds.size.width;
        maskScale = maskScale >= 1.0 ? 0.5 : maskScale;
        CGFloat maxContentOffset = MAX(self.scrollContentView.contentSize.width - self.scrollContentView.bounds.size.width,0);
        
        if(offset < 0.5) //移动到最左侧
        {
            colorArr = [NSArray arrayWithObjects:(__bridge id)[UIColor clearColor].CGColor,(__bridge id)[UIColor clearColor].CGColor,(__bridge id)m_maskLayer.backgroundColor,nil];
            locationArr = @[@0,@(0.99 - maskScale),@0.99];
        }
        else if(offset > maxContentOffset - 0.5) //移动到最右侧
        {
            colorArr = [NSArray arrayWithObjects:(__bridge id)m_maskLayer.backgroundColor,(__bridge id)[UIColor clearColor].CGColor,(__bridge id)[UIColor clearColor].CGColor,nil];
            locationArr = @[@0.01,@(maskScale),@1];
        }
        else
        {
            colorArr = [NSArray arrayWithObjects:(__bridge id)m_maskLayer.backgroundColor,(__bridge id)[UIColor clearColor].CGColor,(__bridge id)[UIColor clearColor].CGColor,(__bridge id)m_maskLayer.backgroundColor,nil];
            locationArr = @[@0.01,@(maskScale),@(0.99 - maskScale),@0.99];
        }
    }
    CAGradientLayer *gradientLayer = (CAGradientLayer*)m_maskLayer.mask;
    gradientLayer.colors = colorArr;
    gradientLayer.locations = locationArr;
    
}



@end
