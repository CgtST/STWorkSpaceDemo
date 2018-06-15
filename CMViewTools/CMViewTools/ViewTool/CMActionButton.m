//
//  CMActionButton.m
//  ViewTools
//
//  Created by bingo on 15/11/21.
//  Copyright © 2015年 CM. All rights reserved.
//

#import "CMActionButton.h"

@implementation CMActionButton

-(instancetype) init
{
    self = [super init];
    if(nil != self)
    {
        self.delayTime = 0.25;
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(nil != self)
    {
        self.delayTime = 0.25;
    }
    return self;
}


-(void)sendAction:(SEL)action to:(id)target forEvent:(UIEvent *)event
{
    [super sendAction:action to:target forEvent:event];
    if(self.delayTime > 0)
    {
        self.enabled = NO;
        __weak UIButton *btn = self;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(self.delayTime * NSEC_PER_SEC)), dispatch_get_main_queue(), ^
                       {
                           btn.enabled = YES;
                       });
    }
}

@end
