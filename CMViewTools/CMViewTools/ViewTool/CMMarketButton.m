//
//  CMMarketButton.m
//  ViewTools
//
//  Created by bingo on 15/11/5.
//  Copyright © 2015年 CM. All rights reserved.
//

#import "CMMarketButton.h"
#import "CMViewDataOper.h"

#define K_LeftSpace 10

#define K_customFont [UIFont systemFontOfSize:14]
#define K_priceFont [UIFont systemFontOfSize:18]

@interface CMMarketButton ()

@property(nonatomic,readonly) CGFloat custHeight;
@property(nonatomic,readonly) CGFloat priceHeight;

@end

@implementation CMMarketButton

#pragma mark - 初始化

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.layer.cornerRadius = 1.5;
        _custHeight = ceil([CMViewDataOper getFontHeight:K_customFont]);
        _priceHeight = ceil([CMViewDataOper getFontHeight:K_priceFont]);
        
        CGFloat ypos = floor((frame.size.height - 2 * self.custHeight - self.priceHeight)/2);
        //名称
        {
            _nameLabel = [self createLable:CGRectMake(K_LeftSpace, ypos, self.bounds.size.width - K_LeftSpace, self.custHeight)];
            [self addSubview:_nameLabel];
            ypos += _nameLabel.bounds.size.height;
        }
        
        //最新价
        {
            _newestPriceLab = [self createLable:CGRectMake(K_LeftSpace, ypos, self.bounds.size.width - K_LeftSpace, self.priceHeight)];
            _newestPriceLab.font = [UIFont systemFontOfSize:17];
            [self addSubview:_newestPriceLab];
            ypos += _newestPriceLab.bounds.size.height;
        }
        
        //（涨跌、涨幅）
        {
            _risePricePresentLab = [self createLable:CGRectMake(K_LeftSpace, ypos, self.bounds.size.width - K_LeftSpace, self.custHeight)];
            [self addSubview:_risePricePresentLab];
            
        }
    }
    return self;
}

-(UILabel *)createLable:(CGRect)frame
{
    UILabel *lab = [[UILabel alloc] initWithFrame:frame];
    lab.backgroundColor = [UIColor clearColor];
    lab.text = @"-";
    lab.textAlignment = NSTextAlignmentLeft;
    lab.textColor = [UIColor blackColor]; //默认颜色，可以通过外部设置
    lab.font = [UIFont systemFontOfSize:14];
    lab.adjustsFontSizeToFitWidth = YES;
    lab.minimumScaleFactor = 0.5;
    return lab;
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

-(void)setFontColor:(nonnull UIColor*)color
{
    self.nameLabel.textColor = color;
    self.newestPriceLab.textColor = color;
    self.risePricePresentLab.textColor = color;
}

-(void)clearData
{
    self.nameLabel.text = @"-";
    self.newestPriceLab.text = @"-";
    self.risePricePresentLab.text = @"-";
}

#pragma mark - 重写setter和getter函数

-(void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    if(nil != _nameLabel)
    {
       CGFloat ypos = floor((frame.size.height - 2 * self.custHeight - self.priceHeight)/2);
        {
            _nameLabel.frame = CGRectMake(K_LeftSpace,ypos, self.bounds.size.width - K_LeftSpace, self.custHeight);
            ypos += _nameLabel.bounds.size.height;
        }
        
        //最新价
        {
            _newestPriceLab.frame  = CGRectMake(K_LeftSpace, ypos, self.bounds.size.width - K_LeftSpace, self.priceHeight);
            ypos += _newestPriceLab.bounds.size.height;
        }
        
        //（涨跌、涨幅）
        {
            _risePricePresentLab.frame = CGRectMake(K_LeftSpace, ypos, self.bounds.size.width - K_LeftSpace, self.custHeight);
        }

    }
}


@end
