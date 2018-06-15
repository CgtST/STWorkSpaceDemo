//
//  CMTitleSortBtn.h
//  ViewTools
//
//  Created by bingo on 15/11/5.
//  Copyright © 2015年 CM. All rights reserved.
//

#import <UIKit/UIKit.h>


//可以进行排序的标题
@interface CMTitleSortBtn : UIButton

@property(nonatomic,readonly) NSUInteger sortWay; //自定义排序方式，与sortImages中的图片对应,初始值为0
@property(nonatomic,retain,nonnull) NSArray<__kindof UIImage*> *sortImages; //各种排序显示的状态图片
@property(nonatomic) CGSize imageSize; //图片范围
@property(nonatomic) CGFloat imageTextSpace; //图片和文字之间的距离,默认为0
@property(nonatomic) NSInteger theSortType; //排序类型,有外部设定

-(void)updateLayout;

@end
