//
//  CMRefreshControlSubClass.m
//  ViewTools
//
//  Created by bingo on 15/11/2.
//  Copyright © 2015年 CM. All rights reserved.
//

#import "CMRefreshControlSubClass.h"

@implementation CMRefreshControl(CMRefreshControlProtected)

-(nonnull instancetype)initWithHeight:(CGFloat)height
{
    self = [super init];
    if(nil != self)
    {
        [self setValue: [NSNumber numberWithDouble:height] forKey:@"viewHeight"];
        [self setValue: [NSNumber numberWithInteger:CMRefreshStateEndRefresh] forKey:@"refreshState"];
        [self setValue: [NSNumber numberWithBool:NO] forKey:@"bRefresh"];
        [self setValue: [NSNumber numberWithBool:YES] forKey:@"bEnableRefresh"];
        
        self.timeOutLimit = 30;
        self.backgroundColor = [UIColor clearColor];
        self.refreshDirction = CMRefreshDirectionPullDown;
    }
    return self;
}

-(void)updateFrame:(CGRect)frame
{
    
}

-(void)refreshStateChanged:(CMRefreshState)refreshState
{
    
}

-(void)setcanRefresh:(BOOL)canRefresh
{
    [self setValue: [NSNumber numberWithBool:canRefresh] forKey:@"bEnableRefresh"];
}

@end
