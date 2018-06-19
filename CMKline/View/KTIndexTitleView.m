//
//  KTIndexTitleView.m
//  iBestProduct
//
//  Created by bingo on 2018/6/8.
//  Copyright © 2018年 iBest. All rights reserved.
//


#import "KTIndexTitleView.h"

#define KMoveLineHeght  1
#define KBottomLineHeght  1

#define KFenShiBaseTag   4080

@interface KTIndexTitleView ()
{
    IndexTitleClickBlock _clickBlock;
    NSArray * _IndexTitles;
}




@property (nonatomic,strong) UIView  * moveLineView;  //滑动线
@property (nonatomic,strong) UIView  * bottomLineView;  //底框线


@end

@implementation KTIndexTitleView

-(instancetype)initWithFrame:(CGRect)frame titles:(NSArray *)titles
{
    
    self = [super initWithFrame:frame];
    if (self) {
        
        _IndexTitles = titles;
        _selectedColor = [UIColor colorWithHexString:@"#fb6130"];
        _moveLineColor = [UIColor colorWithHexString:@"#fb6130"]; //默认
        _bottomLineColor = [UIColor colorWithHexString:@"#e8e8e8"];
        _selectIndex = 0; //第一个
        
        [self initUI];
    }
    return self;
}

#pragma mark - Public
//点击了第几个
-(void)clickIndexButtonWithBlock:(IndexTitleClickBlock)block
{
    _clickBlock = block;
}


#pragma mark - Private

-(void)initUI
{
    if(_IndexTitles.count == 0)
    {
        return;
    }
     CGFloat  btnWith = self.bounds.size.width/_IndexTitles.count;
    CGFloat btnHeight = self.bounds.size.height-KMoveLineHeght;
    WEAKSELF
    [_IndexTitles enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CGRect btnRect = CGRectMake(idx*btnWith, 0, btnWith,btnHeight);
        UIButton * button = [weakSelf createButtonWithFrame:btnRect];
        button.tag = KFenShiBaseTag+idx;
        [button setTitle:_IndexTitles[idx] forState:UIControlStateNormal];
        [weakSelf addSubview:button];
    }];
    
    [self addSubview:self.bottomLineView];
    
    self.moveLineView.frame = CGRectMake(0, btnHeight, btnWith, KMoveLineHeght);
    [self addSubview:self.moveLineView];
    
}


-(UIButton *)createButtonWithFrame:(CGRect)frame
{
    UIButton *btn = [[UIButton alloc] initWithFrame:frame];
   
    [btn dk_setTitleColorPicker:DKColorPickerWithKey(ContentColor) forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:16.0];
    [btn addTarget:self action:@selector(clickTitleAction:) forControlEvents:UIControlEventTouchUpInside];
    
    return btn;
}

#pragma mark - Click
-(void)clickTitleAction:(UIButton *)sender
{
    NSUInteger  currentSelectIndex = sender.tag-KFenShiBaseTag;
    if (self.selectIndex == currentSelectIndex) {
        return;
    }
    
    //清掉preBtn的颜色
    UIButton *temp = (UIButton*)[self viewWithTag:KFenShiBaseTag+self.selectIndex];
    [temp dk_setTitleColorPicker:DKColorPickerWithKey(ContentColor) forState:UIControlStateNormal];
    //上色
    [sender setTitleColor:_selectedColor forState:UIControlStateNormal];
    
    WEAKSELF
    [UIView animateWithDuration:0.2 animations:^{
        weakSelf.moveLineView.center = CGPointMake(sender.center.x, weakSelf.moveLineView.center.y);
    }];
    
    self.selectIndex = currentSelectIndex;
    if (_clickBlock) {
        _clickBlock(self.selectIndex);
    }
}



#pragma mark - Getter  and Setter

-(UIView *)moveLineView
{
    if (nil== _moveLineView) {
        
        CGFloat moveLineWith = self.bounds.size.width/ _IndexTitles.count;
        _moveLineView = [[UIView alloc] initWithFrame:CGRectMake(0, self.bounds.size.height-KMoveLineHeght, moveLineWith, 1)];
        _moveLineView.backgroundColor = _moveLineColor;
    }
    return _moveLineView;
}

-(UIView *)bottomLineView
{
    if (nil == _bottomLineView) {
        _bottomLineView = [[UIView alloc] initWithFrame:CGRectMake(0, self.bounds.size.height-KBottomLineHeght, self.bounds.size.width, KBottomLineHeght)];
        
        _bottomLineView.backgroundColor = _bottomLineColor;
    }
    return _bottomLineView;
}

//设置选中的颜色
-(void)setSelectedColor:(UIColor *)selectedColor
{
    _selectedColor = selectedColor;
    self.moveLineView.backgroundColor = selectedColor;
    
    //button颜色
    UIButton *temp = (UIButton*)[self viewWithTag:KFenShiBaseTag+self.selectIndex];
    [temp setTitleColor:selectedColor  forState:UIControlStateNormal];
}


//设置底线色
-(void)setBottomLineColor:(UIColor *)bottomLineColor
{
    _bottomLineColor = bottomLineColor;
    self.bottomLineView.backgroundColor = bottomLineColor;
}

@end
