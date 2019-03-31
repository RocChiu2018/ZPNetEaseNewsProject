#import <UIKit/UIKit.h>

/**
 如果在项目中定义的全局常量很多的话，如果要在其他类中引用的话就会写很多的代码，那样很麻烦，所以对于这种情况应该把所有的全局常量定义在单独的一个文件里，.h文件专门用来引用，.m文件专门用来定义，这样想在其他类中引用这些全局常量的话就直接引用本类的头文件即可；
 UIKIT_EXTERN其实和extern作用是一样的，但是UIKIT_EXTERN只能在UIKit框架中使用，苹果更推荐使用UIKIT_EXTERN关键字。
 */

UIKIT_EXTERN const CGFloat kPink;
UIKIT_EXTERN const CGFloat kBrown;
UIKIT_EXTERN const CGFloat kYellow;
UIKIT_EXTERN NSString * const bookName;
