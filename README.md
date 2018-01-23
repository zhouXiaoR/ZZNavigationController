### ZZNavigationController

#### 运行效果
![运行效果图](运行效果图.gif)

#### 功能简介：

- 支持全屏手势返回
- 滑动返回的比例可配置
- 过渡动画，切换速度可自行设置
- 与系统导航无冲突

#### 原理介绍：

- 继承UINavigationController
- 添加全屏手势：UIPanGestureRecognizer
- 重写以下系统方法，根据手势截屏完成整个过程。

- (void)pushViewController:(UIViewController*)viewController animated:(BOOL)animated;
- (UIViewController *)popViewControllerAnimated:(BOOL)animated;

#### 结语

- 在这里只是实现了一下基本的功能，代码很简洁，有问题可以欢迎指出。

#### Git地址：
[点我传送门](https://github.com/zhouXiaoR/ZZNavigationController)

https://github.com/zhouXiaoR/ZZNavigationController



