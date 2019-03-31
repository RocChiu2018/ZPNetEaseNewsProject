//
//  ZPViewController.m
//  网易新闻首页
//
//  Created by apple on 2016/12/21.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "ZPViewController.h"
#import "ZPTableViewController.h"
#import "ZPLabel.h"
#import "ZPConst.h"

@interface ZPViewController () <UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *titleScrollView;
@property (weak, nonatomic) IBOutlet UIScrollView *contentScrollView;

@end

@implementation ZPViewController

#pragma mark ————— 生命周期 —————
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //只需引用ZPConst类的头文件即可使用它里面定义的全局常量
    NSLog(@"kYellow = %f", kYellow);
    
    //添加子视图控制器
    [self setChildViewController];
    
    //设置标题
    [self setTitle];
    
    //默认显示第0个子控制器
    [self scrollViewDidEndScrollingAnimation:self.contentScrollView];
}

#pragma mark ————— 添加子视图控制器 —————
//这个方法只是创建子视图控制器并把它们加入到本父视图控制器中，并没有把相应的子view加入到父view上。子view应该使用懒加载的方式进行加载，即将要显示这个子view的时候才把它加入到父view中了。
- (void)setChildViewController
{
    ZPTableViewController *vc = [[ZPTableViewController alloc] init];
    vc.title = @"国际";
    [self addChildViewController:vc];
    
    ZPTableViewController *vc1 = [[ZPTableViewController alloc] init];
    vc1.title = @"军事";
    [self addChildViewController:vc1];
    
    ZPTableViewController *vc2 = [[ZPTableViewController alloc] init];
    vc2.title = @"政治";
    [self addChildViewController:vc2];
    
    ZPTableViewController *vc3 = [[ZPTableViewController alloc] init];
    vc3.title = @"艺术";
    [self addChildViewController:vc3];
    
    ZPTableViewController *vc4 = [[ZPTableViewController alloc] init];
    vc4.title = @"国内";
    [self addChildViewController:vc4];
    
    ZPTableViewController *vc5 = [[ZPTableViewController alloc] init];
    vc5.title = @"创业";
    [self addChildViewController:vc5];
    
    ZPTableViewController *vc6 = [[ZPTableViewController alloc] init];
    vc6.title = @"选举";
    [self addChildViewController:vc6];
}

#pragma mark ————— 设置标题 —————
- (void)setTitle
{
    /**
     设值临时变量：
     对于那些固定值的临时变量而言，没必要放在循环中每次都进行取值，那样的话会比较多地耗费系统的资源，应该在循环之前给这些临时变量设值。
     */
    CGFloat labelY = 0;
    CGFloat labelW = 100;
    CGFloat labelH = self.titleScrollView.frame.size.height;
    
    for (int i = 0; i < 7; i++)
    {
        ZPLabel *label = [[ZPLabel alloc] init];
        label.text = [[self.childViewControllers objectAtIndex:i] title];
        
        CGFloat labelX = i * labelW;
        label.frame = CGRectMake(labelX, labelY, labelW, labelH);
        
        [label addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(labelClick:)]];
        
        label.tag = i;
        
        [self.titleScrollView addSubview:label];
        
        //一开始默认选中第0个label
        if (i == 0)
        {
            label.scale = 1.0;
        }
    }
    
    //设置scrollView的contentSize
    self.titleScrollView.contentSize = CGSizeMake(7 * labelW, 0);
    self.contentScrollView.contentSize = CGSizeMake(7 * [UIScreen mainScreen].bounds.size.width, 0);
}

#pragma mark ————— 点击标题label触发的方法 —————
//利用此方法来实现点击titleScrollView上的label，让contentScrollView做相应的移动，从而让对应的内容视图显示出来的目的。
- (void)labelClick:(UITapGestureRecognizer *)tap
{
    NSInteger index = tap.view.tag;  //获取点击到的label的索引
    
    CGPoint offset = self.contentScrollView.contentOffset;
    offset.x = index * self.contentScrollView.frame.size.width;
    
    [self.contentScrollView setContentOffset:offset animated:YES];
}

#pragma mark ————— UIScrollViewDelegate —————
/**
 当scrollView控件滚动动画结束的时候会自动调用此方法；
 利用此方法来实现当contentScrollView移动的时候，titleScrollView也跟着做相应地移动，并且最终显示的内容视图所对应的标题label要显示在titleScrollView的中间位置。
 */
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    CGFloat width = scrollView.frame.size.width;
    CGFloat height = scrollView.frame.size.height;
    CGFloat offsetX = scrollView.contentOffset.x;
    
    //最终显示的视图控制器的索引
    NSInteger index = offsetX / width;
    
    //让最终显示的视图控制器所对应的label位于titleScrollView的中间位置
    ZPLabel *label = [self.titleScrollView.subviews objectAtIndex:index];
    CGPoint titleOffset = self.titleScrollView.contentOffset;
    titleOffset.x = label.center.x - width * 0.5;
    
    //在屏幕内不能让titleScrollView的左边留有空白，即titleScrollView.x的值不能为负。
    if (titleOffset.x < 0)
    {
        titleOffset.x = 0;
    }
    
    //在屏幕内不能让titleScrollView的右边留有空白，即titleScrollView.x的值不能超过最大偏移量
    CGFloat maxTitleOffsetX = self.titleScrollView.contentSize.width - width;
    if (titleOffset.x > maxTitleOffsetX)
    {
        titleOffset.x = maxTitleOffsetX;
    }
    
    //让titleScrollView进行移动
    [self.titleScrollView setContentOffset:titleOffset animated:YES];
    
    /**
     当contentScrollView中显示第0个视图的时候，点击titleScrollView中的最后一个label，这个时候contentScrollView中的视图会由第0个一次性地切换到最后一个，这期间不会显示其他的视图。而在titleScrollView中会从第0个label逐个地进行切换，最终会显示最后一个label。在label逐个切换的过程中有的label的颜色会出现问题，撰写下面的代码可以消除上述的bug。
     */
    for (ZPLabel *otherLabel in self.titleScrollView.subviews)
    {
        if (otherLabel != label)
        {
            otherLabel.scale = 0.0;
        }
    }
    
    //取出需要显示的视图控制器
    UIViewController *willShowVC = [self.childViewControllers objectAtIndex:index];
    
    //如果将要显示的视图控制器已经显示过了的话，就没必要再算一次坐标、再加一次view了
    if ([willShowVC isViewLoaded])
    {
        return;
    }
    
    //设置将要显示的视图控制器的view的尺寸
    willShowVC.view.frame = CGRectMake(offsetX, 0, width, height);
    
    //把将要显示的视图控制器的view加到contentScrollView上
    [self.contentScrollView addSubview:willShowVC.view];
}

/**
 当scrollView控件滚动减速结束的时候会自动调用此方法；
 用户手指开始拖动scrollView控件而使它发生滚动，然后用户的手指脱离它，这个时候它的滚动速度会逐渐地变慢，直至最后减速到0从而停下来，这个时候系统就会自动调用此方法；
 此方法只能在用户用手指拖动scrollView控件的条件下触发，其他的情况则不能触发此方法。相反用户用手指拖动scrollView控件的时候只能触发此方法，而不能触发"scrollViewDidEndScrollingAnimation: "及其他的代理方法；
 利用此方法来实现当用户用手指拖动contentScrollView的时候，titleScrollView也跟着做相应地移动，并且最终显示的内容视图所对应的标题label要显示在titleScrollView的中间位置。
 */
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self scrollViewDidEndScrollingAnimation:scrollView];
}

/**
 scrollView控件在滚动的过程中会一直调用此方法，所以一般用此方法来监控scrollView控件的滚动；
 当contentScrollView滚动的时候，利用此方法来监控左边内容视图和右边内容视图占据屏幕的比例。
 */
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //获取滑动的比例
    CGFloat scale = scrollView.contentOffset.x / scrollView.frame.size.width;
    
    //当用户在最左边再往右滑或者在最右边再往左滑的时候，让用户不能再继续滑动了，否则会出现崩溃的现象。
    if (scale < 0 || scale > self.titleScrollView.subviews.count - 1)
    {
        return;
    }
    
    //获得需要操作的左边label
    NSInteger leftIndex = scale;  //取整数
    ZPLabel *leftLabel = [self.titleScrollView.subviews objectAtIndex:leftIndex];
    
    //防止数组越界
    if (leftIndex == self.titleScrollView.subviews.count - 1)
    {
        return;
    }
    
    //获得需要操作的右边label
    NSInteger rightIndex = leftIndex + 1;
    ZPLabel *rightlabel = [self.titleScrollView.subviews objectAtIndex:rightIndex];
    
    //获取右边的比例
    CGFloat rightScale = scale - leftIndex;
    
    //获取左边的比例
    CGFloat leftScale = 1 - rightScale;
    
    //设置左边和右边label的比例
    leftLabel.scale = leftScale;
    rightlabel.scale = rightScale;
    
    NSLog(@"%ld, %ld", (long)leftIndex, (long)rightIndex);
}

@end
