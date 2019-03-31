//
//  ZPLabel.h
//  网易新闻首页
//
//  Created by apple on 2017/1/6.
//  Copyright © 2017年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZPLabel : UILabel

@property (nonatomic, assign) double scale;  //contentScrollView中即将滚出屏幕的内容视图所对应的titleScrollView上的label和即将滚入屏幕的内容视图所对应的label的比例。

@end
