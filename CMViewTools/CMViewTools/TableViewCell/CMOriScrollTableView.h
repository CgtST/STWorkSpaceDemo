//
//  CMOriScrollTableView.h
//  ViewTools
//
//  Created by bingo on 15/11/4.
//  Copyright © 2015年 CM. All rights reserved.
//

#import <UIKit/UIKit.h>


/*掌上财富横向移动表格,使用该表格时
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 返回的必须是
 从CMTableCellScrollDelegate继承的对象。
 该表格主要是解决使用表格进行左右滑动时引起的偏移量不一致问题
 */
@interface CMOriScrollTableView : UITableView

@end

