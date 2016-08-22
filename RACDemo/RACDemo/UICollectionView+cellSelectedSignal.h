//
//  UICollectionView+cellSelectedSignal.h
//  RACDemo
//
//  Created by ww on 16/7/25.
//  Copyright © 2016年 ww. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RACDelegateProxy;
@class RACSignal;
@interface UICollectionView (cellSelectedSignal)

@property (nonatomic, strong, readonly) RACDelegateProxy *rac_delegateProxy;

///这个分类其实并没有什么卵用,还不如直接调用UICollectionView的点击cell的代理方法,这个分类是我看着RAC的分类仿着写的(或者说直接拖过来的),意在说明,当我们有某种需求的时候,我们其实可以自己自定义某些信号
- (RACSignal *)cellSelectedSignal;
@end
