//
//  IBTopLabel.m
//  QNApp
//
//  Created by Baicai on 2017/4/8.
//  Copyright © 2017年 BaiCai. All rights reserved.
//

/*
 使用方法
 
 IBTopLabel * tempLab = [[IBTopLabel alloc] initWithFrame:CGRectMake(xpos, ypos, labWith, KLabH)];
 tempLab.textColor = [IBSkinColor getFontColor:IBFontColorTypeTextWeak];
 tempLab.font = [UIFont systemFontOfSize:KLabFontSize];
 tempLab.text =@"经营业务";
 tempLab.lineBreakMode = NSLineBreakByWordWrapping;
 tempLab.numberOfLines = 0;
 [tempLab setVerticalAlignment:VerticalAlignmentTop];
 [_viewTwo addSubview:tempLab];
 */

#import "IBTopLabel.h"

@interface IBTopLabel ()

@end

@implementation IBTopLabel

 - (id)initWithFrame:(CGRect)frame {
     if (self = [super initWithFrame:frame])
     {
        self.verticalAlignment = VerticalAlignmentMiddle; //默认顶部对齐
        
     }
    return self;
}




- (CGRect)textRectForBounds:(CGRect)bounds limitedToNumberOfLines:(NSInteger)numberOfLines {
       CGRect textRect = [super textRectForBounds:bounds limitedToNumberOfLines:numberOfLines];
        switch (self.verticalAlignment) {
                   case VerticalAlignmentTop:
                         textRect.origin.y = bounds.origin.y;
                        break;
                   case VerticalAlignmentBottom:
                       textRect.origin.y = bounds.origin.y + bounds.size.height - textRect.size.height;
                        break;
                   case VerticalAlignmentMiddle:
                      // Fall through.
                  default:
                       textRect.origin.y = bounds.origin.y + (bounds.size.height - textRect.size.height) / 2.0;
           }
     
        return textRect;
     
}



-(void)drawTextInRect:(CGRect)requestedRect {
      CGRect actualRect = [self textRectForBounds:requestedRect limitedToNumberOfLines:self.numberOfLines];
        [super drawTextInRect:actualRect];
  }


@end
