//
//  NSTimer+Addition.h
//  QNApp
//
//  Created by weiheng on 15/11/14.
//  Copyright © 2015年 Bacai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSTimer (Addition)

- (void)pauseTimer;
- (void)resumeTimer;
- (void)resumeTimerAfterTimeInterval:(NSTimeInterval)interval;

@end
