//
//  ZPLabel.m
//  网易新闻首页
//
//  Created by apple on 2017/1/6.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZPLabel.h"

/**
 定义宏：在本类中用到这个宏的地方就会创建一个临时的存储空间，用来存储这个宏的值，当用完的时候再销毁之前创建的这个临时的存储空间。所以宏的弊端就是会在类中到处创建临时的存储空间。
 */
//#define kRed 0.4
//#define kGreen 0.6
//#define kBlue 0.7

/**
 定义全局变量：在本类中访问该全局变量的时候只会访问到唯一的一个内存空间，而不会像宏似的，在用到宏的时候就会创建一个临时的存储空间。
 
 全局变量的缺陷：
 1、在其他类中用extern关键字引用本类的全局变量之后可以在其他类中随意地更改它的值，这样使用不安全；
 2、如果在另外的类中也定义了相同名称的全局变量的话，则在编译的时候会报重复定义的错误；
 如果想要克服上述的缺陷的话就要在全局变量的前面加上static关键字进行修饰，这样全局变量就变成了私有变量了，即只能在本类中使用，其他类是引用不到的。
 */
//CGFloat kRed = 0.4;
//CGFloat kGreen = 0.6;
//CGFloat kBlue = 0.7;

/**
 定义全局常量：用const关键字来修饰全局变量，则原来的全局变量就变为了全局常量了。在其他类中可以用extern关键字来引用本类的全局常量，但是不能更改它的值；
 跟访问全局变量一样，在本类中访问全局常量的时候只会访问唯一的一个内存空间，而不会像宏似的，在用到宏的时候就会创建一个临时的存储空间，所以苹果更建议使用全局常量的做法来定义一个常量的值；
 定义带星号的全局常量的时候要在星号的后面加const关键字，因为const关键字后面的变量才受到保护。所以在其他类中用extern关键字来引用这个全局常量的时候只能引用而不能修改它的值。如果const关键字写在了星号前面的话，则保护的是*name不能更改，而name是能够更改的。原则如上述的原则，但是经实验以后得知，在其他类中用extern关键字引用已经受到保护的全局常量name的时候，发现name不仅能够被引用，还能够被修改，只有当在其他类中用extern关键字引用全局常量name并且在name之前写上const关键字时，才能够保证name的值不被修改了；
 如果在const关键字前面加上static关键字，则代表着这个全局常量只能在本类中访问，在其他类中不能再使用extern关键字来引用它了。
 */
const CGFloat kRed = 0.4;
const CGFloat kGreen = 0.6;
const CGFloat kBlue = 0.7;
NSString * const name = @"Jack";
static const int age = 16;


@implementation ZPLabel

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        self.font = [UIFont systemFontOfSize:15];
        self.textAlignment = NSTextAlignmentCenter;
        self.backgroundColor = [UIColor clearColor];
        self.userInteractionEnabled = YES;
    }
    
    return self;
}

- (void)setScale:(double)scale
{
    _scale = scale;
    
    /**
     label中的文字由默认的颜色（R, G, B: 0.4, 0.6, 0.7）会随着它对应的contentScrollView中的内容视图显示在屏幕上的比例慢慢地会变为红色（R, G, B: 1, 0, 0）
     */
    CGFloat red = kRed + (1 - kRed) * scale;
    CGFloat green = kGreen + (0 - kGreen) *scale;
    CGFloat blue = kBlue + (0 - kBlue) * scale;
    
    self.textColor = [UIColor colorWithRed:red green:green blue:blue alpha:1.0];
    
    /**
     label中的文字的大小会随着它所对应的contentScrollView中的内容视图显示在屏幕上的比例慢慢地由1倍大小放大到1.3倍大小。
     */
    CGFloat transformScale = 1 + scale * 0.3;  //字体比例在1-1.3倍之间进行缩放
    self.transform = CGAffineTransformMakeScale(transformScale, transformScale);
}

@end
