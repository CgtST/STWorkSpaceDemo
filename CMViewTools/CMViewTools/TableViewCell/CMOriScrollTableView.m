//
//  CMOriScrollTableView.m
//  ViewTools
//
//  Created by bingo on 15/11/4.
//  Copyright © 2015年 CM. All rights reserved.
//

#import "CMOriScrollTableView.h"
#import "CMTableCellScrollDelegate.h"

@interface CMOriScrollTableView ()

@end

@implementation CMOriScrollTableView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(nil != self)
    {
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        //点击手势手势,底层的scrollView截获了鼠标点击事件
        UITapGestureRecognizer *tapGesture =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture:)] ;
        [self addGestureRecognizer:tapGesture];
    }
    return self;
}


-(void)tapGesture:(UITapGestureRecognizer*)gesture
{
    if(UIGestureRecognizerStateEnded == gesture.state)
    {
        CGPoint pt = [gesture locationInView:self];
        NSIndexPath *path =  [self indexPathForRowAtPoint:pt];
        if(nil == path)
        {
            return;
        }
        UITableViewCell *selectedCell = [self cellForRowAtIndexPath:path];
        if(nil == selectedCell)
        {
            return;
        }
        if(YES == [[selectedCell class] conformsToProtocol:@protocol(CMTableCellScrollDelegate)])
        {
            selectedCell.backgroundColor = ((id<CMTableCellScrollDelegate>)selectedCell).selBgColor;
        }
        NSIndexPath *indexPath = [self indexPathForCell:selectedCell];
        [self selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
        if(nil != self.delegate && YES == [self.delegate respondsToSelector:@selector(tableView:didSelectRowAtIndexPath:)])
        {
            __unsafe_unretained CMOriScrollTableView *tableView = self;
            [self.delegate tableView:tableView didSelectRowAtIndexPath:indexPath];
        }
        //清空颜色
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, NSEC_PER_MSEC * 200), dispatch_get_main_queue(), ^
       {
           selectedCell.backgroundColor = [UIColor clearColor];
       });
    }
}

- (nullable __kindof UITableViewCell *)dequeueReusableCellWithIdentifier:(NSString *)identifier
{
    UITableViewCell *cell = [super dequeueReusableCellWithIdentifier:identifier];
    if(YES == [[cell class] conformsToProtocol:@protocol(CMTableCellScrollDelegate)])
    {
        id<CMTableCellScrollDelegate> retCell = (id<CMTableCellScrollDelegate>)cell;
        NSArray *arr = [self visibleCells];
        for(UITableViewCell *scrollCell in arr)
        {
            if(YES == [[scrollCell class] conformsToProtocol:@protocol(CMTableCellScrollDelegate)])
            {
                retCell.cellOffset = ((id<CMTableCellScrollDelegate>)scrollCell).cellOffset;
                break;
            }

        }
    }
    return cell;
}

@end
