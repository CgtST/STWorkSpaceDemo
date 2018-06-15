//
//  CMAlertButton.m
//  ViewTools
//
//  Created by bingo on 16/1/6.
//  Copyright © 2016年 CM. All rights reserved.
//

#import "CMAlertButton.h"

typedef void (^AlertViewDismissBlock)(void);

@interface CMAlertButton ()
{
    AlertViewDismissBlock m_dismissBlock;
}
@end

@implementation CMAlertButton

-(void)setDismissBlock:(void (^)(void)) dimissblock
{
    m_dismissBlock = dimissblock;
}

-(void)sendAction:(SEL)action to:(id)target forEvent:(UIEvent *)event
{
    [super sendAction:action to:target forEvent:event];
    if(nil != m_dismissBlock)
    {
        m_dismissBlock();
    }
}

@end
