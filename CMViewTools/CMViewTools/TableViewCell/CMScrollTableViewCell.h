//
//  CMScrollTableViewCell.h
//  ViewTools
//
//  Created by bingo on 15/11/4.
//  Copyright © 2015年 CM. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CMTableCellScrollDelegate.h"

/*可以左右滑动的单元格，这种单元格使用是回有以下问题：
   1、UITableView的点击事件无法使用
   2、左右滑动了单元格后，再上下滑动UITableView可能会导致前单元格中的scrollView的偏移量不一致
*/

@class CMScrollTableViewCellData;
@protocol CMScrollTableViewCellDelegate;
@interface CMScrollTableViewCell : UITableViewCell<CMTableCellScrollDelegate>

@property(nonatomic,retain,nonnull) NSString *cellSign;  //列标志。通过搜索直接定位到对于的单元格
@property(nonatomic,weak,nullable) id<CMScrollTableViewCellDelegate> scrollTableViewDelegate;
@property(nonatomic,readonly) CGFloat maxOffset; //最大偏移量


-(nonnull instancetype)initWidthColWidth:(nonnull NSArray<__kindof NSNumber*>*)colWidths reuseIdentifier:(nonnull NSString*)reuseIdentifier;

#pragma mark - 属性

-(void)setContentFont:(nonnull UIFont*)font;  //设置字体

-(void)setSepLineColor:(nonnull UIColor*)sepColor;//设置分割线的颜色

#pragma mark - 功能

//设置内容 contentArr
-(void)setContent:(nonnull NSArray<__kindof CMScrollTableViewCellData*> *)contentArr;

//设置滚动时的block
-(void)setScrollBlock:(nonnull void (^)(CGFloat scrollOffset)) scrollblock;

@end


//用于指定给定列的缩进和滑动的开始和结束
@protocol CMScrollTableViewCellDelegate <NSObject>

@optional

-(UIEdgeInsets)CMScrollTableViewCell:(nonnull CMScrollTableViewCell*)CMScrollCell edgeInsetForCol:(NSUInteger)col inBounds:(CGRect)bounds;

-(void)CMScrollTableViewCellStartScroll:(nonnull CMScrollTableViewCell*)CMScrollCell; //开始滑动

-(void)CMScrollTableViewCellEndScroll:(nonnull CMScrollTableViewCell*)CMScrollCell;  //结束滑动

@end


#pragma mark -
#pragma mark *****************************************
#pragma mark CMScrollTableViewCell
#pragma mark *****************************************
#pragma mark -

//滚动视图单元格
@interface CMScrollTableViewCellData : NSObject

@property(nonatomic,retain,nonnull) UIColor *cellTextColor;
@property(nonatomic,retain,nonnull) UIColor *cellBackgroudColor;
@property(nonatomic,copy,nonnull) NSString *cellContentStr;

-(nonnull instancetype)copy;

@end
