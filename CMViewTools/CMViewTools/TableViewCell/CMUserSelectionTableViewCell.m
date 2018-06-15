//
//  CMUserSelectionTableViewCell.m
//  ViewTools
//
//  Created by bingo on 15/11/3.
//  Copyright © 2015年 CM. All rights reserved.
//

#import "CMUserSelectionTableViewCell.h"

#pragma mark -
#pragma mark  CM_ZXNameInfoView
#pragma mark -

@interface CM_ZXNameInfoView : UIView
{
    UIView *m_textViewContent;  //装载名称的视图
}
@property(nonatomic) BOOL showImage; //显示对应的商品图片
@property(nonatomic) BOOL showCode;  //两行显示时，显示代码
@property(nonatomic,readonly,nonnull) UILabel* merchNameLab; //商品名称
@property(nonatomic,readonly,nullable) UILabel *merchCodeLab; //商品代码
@property(nonatomic,readonly,nullable) UIImageView *merchMarkImageView; //商品显示的图片
@property(nonatomic) CGFloat merchCodeLabHeight; //默认为整个视图的1/3高度,只有在showCode为YES时才有效
@property(nonatomic,readonly) CGFloat imageViewWidth;

-(void)updateLayout;  //更新布局

@end

@implementation CM_ZXNameInfoView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (nil != self)
    {
        self.backgroundColor = [UIColor clearColor];
        m_textViewContent = [[UIView alloc] initWithFrame:frame];
        m_textViewContent.backgroundColor = [UIColor clearColor];
        [self addSubview:m_textViewContent];
        
        _merchNameLab = [[UILabel alloc] initWithFrame:m_textViewContent.bounds];
        _merchNameLab.textAlignment = NSTextAlignmentLeft;
        _merchNameLab.textColor = [UIColor blackColor]; //默认颜色，可以通过外部设置
        _merchNameLab.text = @"";
        _merchNameLab.backgroundColor = [UIColor clearColor];
        _merchNameLab.numberOfLines = 0;
        _merchNameLab.lineBreakMode = NSLineBreakByWordWrapping;
        [m_textViewContent addSubview:_merchNameLab];
        
        self.merchCodeLabHeight = m_textViewContent.bounds.size.height/3;
        _imageViewWidth = 20;
        _merchCodeLab = nil;
        _merchMarkImageView = nil;
        _showCode = NO;
        _showImage = NO;
    }
    return self;
}

-(void)updateLayout
{
    CGFloat xpos = YES == self.showImage ? self.imageViewWidth : 0.0;
    {
        m_textViewContent.frame = CGRectMake(xpos, 0, self.bounds.size.width - xpos, self.bounds.size.height);
        CGFloat nameLabHeight = YES == self.showCode ? m_textViewContent.bounds.size.height - self.merchCodeLabHeight : m_textViewContent.bounds.size.height;
        self.merchNameLab.frame = CGRectMake(0, 0, m_textViewContent.bounds.size.width, nameLabHeight);
        if(nil != self.merchCodeLab)
        {
            self.merchCodeLab.frame = CGRectMake(nameLabHeight, 0, m_textViewContent.bounds.size.width, self.merchCodeLabHeight);
        }
    }
    if(nil != self.merchMarkImageView)
    {
        self.merchMarkImageView.frame = CGRectMake(0, 0, self.imageViewWidth, self.imageViewWidth);
    }
}

#pragma mark 重写setter和getter函数

-(void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    [self updateLayout];
}

-(void)setShowImage:(BOOL)showImage
{
    if(self.showImage == showImage)
    {
        return;
    }
    _showImage = showImage;
    if(YES == self.showImage)
    {
        _merchMarkImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.imageViewWidth, self.imageViewWidth)];
        _merchMarkImageView.backgroundColor = [UIColor clearColor];
        [self addSubview:_merchMarkImageView];
    }
    else
    {
        [_merchMarkImageView removeFromSuperview];
        _merchMarkImageView = nil;
    }
}

-(void)setShowCode:(BOOL)showCode
{
    if(self.showCode == showCode)
    {
        return;
    }
    _showCode = showCode;
    if(YES == self.showCode)
    {
        _merchCodeLab = [[UILabel alloc] initWithFrame:m_textViewContent.bounds];
        _merchCodeLab.backgroundColor = [UIColor clearColor];
        _merchCodeLab.textColor = [UIColor blackColor]; //默认颜色，可以通过外部设置
        _merchCodeLab.text = @"";
        _merchCodeLab.font = [UIFont systemFontOfSize:14];
        [m_textViewContent addSubview:_merchCodeLab];
    }
    else
    {
        [_merchCodeLab removeFromSuperview];
        _merchCodeLab = nil;
    }

}

@end

#pragma mark -
#pragma mark CMUserSelectionTableViewCell
#pragma mark -

@interface CMUserSelectionTableViewCell ()
{
    CM_ZXNameInfoView *m_nameView; //名称
    UILabel *m_newPriceLab;  //现价
    UIButton *m_riseresentBtn;  //涨跌/涨跌幅等
    CALayer *m_riseresentLayer; //涨跌/涨跌幅等背景颜色
    UIView *m_sepLineView; //分割线
    
    __unsafe_unretained id m_target;
    SEL m_action;
}
@property(nonatomic,readonly) CGRect btnRect;  //按钮限制的范围
@property(nonatomic,readonly) CGFloat sepLineHeight; //分割线高度
@end

@implementation CMUserSelectionTableViewCell

-(nonnull instancetype)initWithcolWidths:(nonnull NSArray<__kindof NSNumber*>*)colWidths reuseIdentifier:(nonnull NSString*)reuseIdentifier
{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if (nil != self)
    {
        self.backgroundColor = [UIColor clearColor];
        _sepLineHeight = 1 / [UIScreen mainScreen].scale;
        //补充不足的元素
        NSMutableArray *widthArr = [NSMutableArray arrayWithArray:colWidths];
        for(NSUInteger i = widthArr.count; i<4 ;i++)
        {
            [widthArr addObject:@([UIScreen mainScreen].bounds.size.width/5)];
        }
        
        CGFloat xpos = [[widthArr objectAtIndex:0] doubleValue];
        
        //名称
        {
            m_nameView = [[CM_ZXNameInfoView alloc] initWithFrame:CGRectMake(xpos, 0, [[widthArr objectAtIndex:1] doubleValue], self.bounds.size.height)];
            m_nameView.backgroundColor = [UIColor clearColor];
            m_nameView.merchNameLab.font = [UIFont systemFontOfSize:18];
            [self.contentView addSubview:m_nameView];
            xpos += m_nameView.bounds.size.width;
        }
        
        //现价
        {
            m_newPriceLab = [[UILabel alloc] initWithFrame:CGRectMake(xpos, 0, [[widthArr objectAtIndex:2] doubleValue], self.bounds.size.height)];
            m_newPriceLab.backgroundColor = [UIColor clearColor];
            m_newPriceLab.textColor = [UIColor blackColor]; //默认颜色，可以通过外部设置
            m_newPriceLab.text = @"";
            m_newPriceLab.font = [UIFont systemFontOfSize:18];
            m_newPriceLab.textAlignment = NSTextAlignmentLeft;
            [self.contentView addSubview:m_newPriceLab];
            xpos += m_newPriceLab.bounds.size.width;
        }

        //涨跌/涨跌幅等
        {
            _btnRect = CGRectMake(xpos, 0, [[widthArr objectAtIndex:3] doubleValue], self.bounds.size.height);
            m_riseresentBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            m_riseresentBtn.clipsToBounds = YES;
            m_riseresentBtn.frame = self.btnRect;
            m_riseresentBtn.titleLabel.font = [UIFont systemFontOfSize:18];
            m_riseresentBtn.backgroundColor = [UIColor clearColor];
            [m_riseresentBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal]; //默认颜色，可以通过外部设置
            [m_riseresentBtn setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted]; //默认颜色，可以通过外部设置
            m_riseresentBtn.layer.cornerRadius = 1.5;
            m_riseresentBtn.userInteractionEnabled = NO;
            [self.contentView addSubview:m_riseresentBtn];
            
            m_riseresentLayer = [CALayer layer];
            m_riseresentLayer.bounds = m_riseresentBtn.layer.bounds;
            m_riseresentLayer.position = m_riseresentBtn.layer.position;
            m_riseresentLayer.cornerRadius = m_riseresentBtn.layer.cornerRadius;
            m_riseresentLayer.masksToBounds = YES;
            [self.contentView.layer insertSublayer:m_riseresentLayer atIndex:0];
        }
        
        self.buttonEdgeInset = UIEdgeInsetsMake(5, 0, 5, 0);
        
        //分割线
        m_sepLineView = [[UIView alloc] initWithFrame:CGRectMake(0, self.bounds.size.height - self.sepLineHeight, self.bounds.size.width, self.sepLineHeight)];
        m_sepLineView.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:m_sepLineView];
        
        //选中时的背景颜色
        self.selectedBackgroundView = [[UIView alloc] initWithFrame:self.bounds];
        self.selectedBackgroundView.backgroundColor = [UIColor clearColor];
    }
    
    return self;
}
#pragma mark  public

-(BOOL)isSameMerch:(nonnull NSString *)merchCode andMarket:(NSInteger)market
{
    if(market != self.iMarket)
    {
        return NO;
    }
    if(nil == self.merchCode)
    {
        return NO;
    }
    return [self.merchCode isEqualToString:merchCode];
}

-(void)setContentFont:(nonnull UIFont*)font
{
    m_nameView.merchNameLab.font = font;
    m_newPriceLab.font = font;
    m_riseresentBtn.titleLabel.font = font;
}

-(void)setContentTextColor:(nonnull UIColor*)textColor
{
    m_nameView.merchNameLab.textColor = textColor;
    m_nameView.merchCodeLab.textColor = textColor;
    m_newPriceLab.textColor = textColor;
}
-(void)setRiseValueTextColor:(nonnull UIColor*)riseValueColor  //设置第三列的字体颜色
{
    [m_riseresentBtn setTitleColor:riseValueColor forState:UIControlStateNormal];
    [m_riseresentBtn setTitleColor:riseValueColor forState:UIControlStateHighlighted];
}

-(void)setSelectedBackgroundColor:(nonnull UIColor*)bgColor
{
    self.selectedBackgroundView.backgroundColor = bgColor;
}

-(void)setSepLineColor:(nonnull UIColor*)sepColor
{
    m_sepLineView.backgroundColor = sepColor;
}

//为按钮（第三列）添加点击事件
- (void)addTarget:(nullable id)target action:(nullable SEL)action
{
    m_target = target;
    m_action = action;
    if(nil != target && nil != action)
    {
        m_riseresentBtn.userInteractionEnabled = YES;
        [m_riseresentBtn addTarget:self action:@selector(updateContent) forControlEvents:UIControlEventTouchUpInside];
        
    }
    else
    {
        [m_riseresentBtn removeTarget:self action:@selector(updateContent) forControlEvents:UIControlEventTouchUpInside];
        m_riseresentBtn.userInteractionEnabled = NO;
    }
}

//设置商品名称
-(void)setMerchName:(nonnull NSString*)merchName
{
    [self setMerchName:merchName andMerchCode:nil andImage:nil];
}

//显示两列标题时需要添加merchCode
-(void)setMerchName:(nonnull NSString*)merchName andMerchCode:(nullable NSString*)merchCode andImage:(nullable UIImage*)image
{
    m_nameView.showImage = nil != image;
    m_nameView.showCode = nil != merchCode;
    if(nil != image)
    {
        [m_nameView.merchMarkImageView setImage:image];
    }
    if(nil != merchCode)
    {
        m_nameView.merchCodeLab.text = merchCode;
    }
    if(nil != image || nil != merchCode)
    {
        [m_nameView updateLayout];
    }
    m_nameView.merchNameLab.text = merchName;
}

//设置最新价
-(void)setNewPrice:(nonnull NSString*)newPrice
{
    m_newPriceLab.text = newPrice;
}

//设置涨幅等和背景颜色
-(void)setRiseValue:(nonnull NSString*)value withBackColor:(nonnull UIColor*)backgroundColor
{
    [m_riseresentBtn setTitle:value forState:UIControlStateNormal];
    [m_riseresentBtn setTitle:value forState:UIControlStateHighlighted];
    m_riseresentBtn.backgroundColor = backgroundColor;
    m_riseresentLayer.backgroundColor = backgroundColor.CGColor;
}

#pragma mark - 按钮点击事件

-(void)updateContent
{
    if(YES == [m_target respondsToSelector:m_action])
    {
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"   //消除警告
        __unsafe_unretained CMUserSelectionTableViewCell *cell = self;
        [m_target performSelector:m_action withObject:cell];
    }
}

#pragma mark  重写setter和getter函数

-(void)setButtonEdgeInset:(UIEdgeInsets)buttonEdgeInset
{
    _buttonEdgeInset = buttonEdgeInset;
    m_riseresentBtn.frame = UIEdgeInsetsInsetRect(self.btnRect, buttonEdgeInset);
    m_riseresentLayer.bounds = m_riseresentBtn.layer.bounds;
    m_riseresentLayer.position = m_riseresentBtn.layer.position;
}

-(void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    
    if(nil != m_nameView)
    {
        self.selectedBackgroundView.frame = self.bounds;
        m_sepLineView.frame = CGRectMake(0, self.bounds.size.height - self.sepLineHeight, self.bounds.size.width, self.sepLineHeight);
        _btnRect.size.height = frame.size.height;
        
        //名称
        {
            CGRect viewframe = m_nameView.frame;
            viewframe.size.height = frame.size.height;
            m_nameView.frame = viewframe;
        }
        
        //现价
        {
            CGRect viewframe = m_newPriceLab.frame;
            viewframe.size.height = frame.size.height;
            m_newPriceLab.frame = viewframe;
        }
        
        //涨跌/涨跌幅等
        {
            [self setButtonEdgeInset:self.buttonEdgeInset];
        }
    }
    
}

@end



