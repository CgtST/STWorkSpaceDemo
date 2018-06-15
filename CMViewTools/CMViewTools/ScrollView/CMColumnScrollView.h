//
//  CMColumnScrollView.h
//  ViewTools
//
//  Created by bingo on 15/11/3.
//  Copyright © 2015年 CM. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CMColumnScrollViewDelegate;

//掌上财富列滚动表格
@interface CMColumnScrollView : UIView

@property(nonatomic,retain,nullable) UIColor *selectedBackColor; //选中时的背景颜色，默认为nil
@property(nonatomic,readonly) CGFloat maxOffset; //最大偏移量
@property(nonatomic,readonly) CGFloat offset;

-(nonnull instancetype)initWithFrame:(CGRect)frame andFixCol:(NSUInteger)fixColCount;

//创建内容
-(BOOL)createContentColWidth:(nonnull NSArray<__kindof NSNumber*>*) colWidths andDelegate:(nonnull id<CMColumnScrollViewDelegate>)delegate;

//获取所有的视图,用于更新数据时用（视图是按照列的顺序来显示的）
-(nonnull NSArray<__kindof UIView*>*)getAllView;

//获取对应列的视图
-(nullable UIView*)getsubViewAtCol:(NSUInteger)col;

//设置偏移量
-(void)setCellOffset:(CGFloat)cellOffset;

//设置滚动时的block
-(void)setScrollBlock:(nonnull void (^)(CGFloat scrollOffset)) scrollblock;

@end

@protocol CMColumnScrollViewDelegate <NSObject>

@required

-(nonnull UIView*)CMColumnScrollView:(nonnull CMColumnScrollView*)CMScrollCell contentViewAtCol:(NSUInteger)col;

@optional

-(UIEdgeInsets)CMColumnScrollView:(nonnull CMColumnScrollView*)CMScrollCell edgeInsetForCol:(NSUInteger)col inBounds:(CGRect)bounds;

-(void)CMColumnScrollViewStartScroll:(nonnull CMColumnScrollView*)CMScrollCell; //开始滑动

-(void)CMColumnScrollViewEndScroll:(nonnull CMColumnScrollView*)CMScrollCell;  //结束滑动

@end
