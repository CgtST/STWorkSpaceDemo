//
//  CMTitleSortBtn.m
//  ViewTools
//
//  Created by bingo on 15/11/5.
//  Copyright © 2015年 CM. All rights reserved.
//

#import "CMTitleSortBtn.h"
#import "CMViewDataOper.h"

@interface CMTitleSortBtn ()

@property(nonatomic,readwrite) NSUInteger sortWay;

@end

@implementation CMTitleSortBtn

-(instancetype)init
{
    return [self initWithFrame:CGRectZero];
}

-(instancetype)initWithFrame:(CGRect)frame
{
    self  = [super initWithFrame:frame];
    if(nil != self)
    {
        self.sortWay = 0;
        self.titleLabel.adjustsFontSizeToFitWidth = YES;
        self.titleLabel.minimumScaleFactor = 0.5;
        self.imageTextSpace = 0;
    }
    return self;
}

#pragma mark - public

-(void)updateLayout
{
    if(nil ==self.imageView || nil == self.imageView.image)  //没有设置图片
    {
        return;
    }
    if(CGSizeEqualToSize(self.imageSize, CGSizeZero))
    {
        self.imageSize = self.imageView.image.size;
    }
    CGFloat titleLength = [CMViewDataOper getFontWidthStr:self.currentTitle withFont:self.titleLabel.font];
    CGFloat imageTop = self.bounds.size.height - self.imageSize.height;
    imageTop = imageTop > 0 ? imageTop /2 : 0;
    CGFloat imageRight = self.bounds.size.width - titleLength - self.imageTextSpace - self.imageSize.width; //图片，文字距离左右两侧的距离
    imageRight = imageRight > 0 ? imageRight / 2 : 0;
    
    self.imageEdgeInsets = UIEdgeInsetsMake(imageTop, self.bounds.size.width - imageRight - self.imageSize.width, imageTop,imageRight) ;
    
    self.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    CGFloat offsetx = [self titleRectForContentRect:self.bounds].origin.x; //获取文字绘制范围，因为在底层使用图片时，还是使用的事图片的原始大小
    
    self.titleEdgeInsets = UIEdgeInsetsMake(0, imageRight - offsetx, 0, 0);
}


#pragma mark - 重载的函数

-(void)sendAction:(SEL)action to:(id)target forEvent:(UIEvent *)event
{
    if(self.sortImages.count > 0)
    {
        self.sortWay = (self.sortWay + 1) % self.sortImages.count;
    }
    [super sendAction:action to:target forEvent:event];
}

#pragma mark - 重写setter和getter函数

-(void)setSortWay:(NSUInteger)sortWay
{
    _sortWay = sortWay;
    if(self.sortImages.count > 0)
    {
        [self setImage:[self.sortImages objectAtIndex:self.sortWay] forState:UIControlStateNormal];
        [self setImage:[self.sortImages objectAtIndex:self.sortWay] forState:UIControlStateHighlighted];
    }
}

-(void)setSortImages:(NSArray<__kindof UIImage *> *)sortImages
{
    _sortImages = sortImages;
    if(self.sortImages.count > 0)
    {
        [self setImage:[self.sortImages objectAtIndex:self.sortWay] forState:UIControlStateNormal];
        [self setImage:[self.sortImages objectAtIndex:self.sortWay] forState:UIControlStateHighlighted];
    }
}

@end
