//
//  MPPanViewController.m 
//
//  Created by 周晓瑞 on 2017.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "MPPanViewController.h"

static CGFloat kNavigationBackgroundAlpha = 0.8f;

@interface MPPanViewController ()<UIGestureRecognizerDelegate>

@property(nonatomic,strong)NSMutableArray * screenSnapImgsArray;
@property(nonatomic,weak)UIImageView *screeenImgView;
@property(nonatomic,weak)UIView *screenCoverView;

@end

@implementation MPPanViewController

#pragma mark - LazyLoading
- (NSMutableArray *)screenSnapImgsArray{
    if (_screenSnapImgsArray == nil) {
        _screenSnapImgsArray = [NSMutableArray array];
    }
    return _screenSnapImgsArray;
}

- (UIImageView *)screeenImgView{
    if (_screeenImgView == nil) {
        UIImageView * imgView = [[UIImageView alloc]init];
        imgView.frame = self.view.bounds;
         [[UIApplication sharedApplication].keyWindow addSubview:imgView];
        [[UIApplication sharedApplication].keyWindow insertSubview:imgView atIndex:0];
        [[UIApplication sharedApplication].keyWindow insertSubview:self.screenCoverView atIndex:1];
        
        _screeenImgView = imgView;
    }
    return _screeenImgView;
}

- (UIView *)screenCoverView{
    if (_screenCoverView == nil) {
        UIView * view = [[UIView alloc]init];
        view.frame = self.view.bounds;
        view.backgroundColor = [UIColor blackColor];
        view.alpha = kNavigationBackgroundAlpha;
        [[UIApplication sharedApplication].keyWindow addSubview:view];
        _screenCoverView = view;
    }
    return _screenCoverView;
    
}
#pragma mark - 

- (void)viewDidLoad {
    [super viewDidLoad];

    self.interactivePopGestureRecognizer.enabled = NO;
    [self addPanScreenGesture];
}

- (void)addPanScreenGesture{
    UIPanGestureRecognizer * pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(pan:)];
    pan.delegate = self;
    [self.view addGestureRecognizer:pan];
}


- (void)pan:(UIPanGestureRecognizer*)pan{
    
   CGPoint transP = [pan translationInView:self.view];
    
    if (transP.x>0) {
        self.view.transform = CGAffineTransformMakeTranslation(transP.x,0);
        self.screeenImgView.image = [self.screenSnapImgsArray lastObject];
        self.screenCoverView.alpha = 1-kNavigationBackgroundAlpha *transP.x / (self.view.bounds.size.width/2.0);
        
        if (pan.state == UIGestureRecognizerStateEnded) {
            if (transP.x >= self.view.bounds.size.width/3.0) {
                [UIView animateWithDuration:0.35 animations:^{
                    self.screenCoverView.alpha = 0.0;
                    self.view.transform = CGAffineTransformMakeTranslation(self.view.bounds.size.width,0);
                } completion:^(BOOL finished) {
                    self.view.transform = CGAffineTransformIdentity;
                    [super popViewControllerAnimated:NO];
                    [self.screeenImgView removeFromSuperview];
                    [self.screenSnapImgsArray removeLastObject];
                    [self.screenCoverView removeFromSuperview];
                }];
            }else{
                [UIView animateWithDuration:0.35 animations:^{
                    self.screenCoverView.alpha = kNavigationBackgroundAlpha;
                    self.view.transform = CGAffineTransformIdentity;
                } completion:^(BOOL finished) {
                    [self.screeenImgView removeFromSuperview];
                    [self.screenCoverView removeFromSuperview];
                }];
            }
        }
    }
}


#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    if (self.childViewControllers.count<=1) {
        return NO ;
    }
    return YES;
}

#pragma mark - UINavigationController

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    [self makeScreenSnap];
    [super pushViewController:viewController animated:animated];
}

- (UIViewController *)popViewControllerAnimated:(BOOL)animated{
    [self.screenSnapImgsArray removeLastObject];
   return  [super popViewControllerAnimated:animated];
}

#pragma mark - 私有

- (void)makeScreenSnap{
    UIGraphicsBeginImageContextWithOptions(self.view.bounds.size,NO,0);
    [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage * newScreenSnapImg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    [self.screenSnapImgsArray addObject:newScreenSnapImg];
}


@end
