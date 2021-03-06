//
//  UICollectionView+cellSelectedSignal.m
//  RACDemo
//
//  Created by ww on 16/7/25.
//  Copyright © 2016年 ww. All rights reserved.
//

#import "UICollectionView+cellSelectedSignal.h"
#import <objc/runtime.h>
#import "RACDelegateProxy.h"
#import "RACSignal+Operations.h"
#import "NSObject+RACDeallocating.h"
#import "NSObject+RACDescription.h"
@implementation UICollectionView (cellSelectedSignal)


static void RACUseDelegateProxy( UICollectionView *self) {
    if (self.delegate == self.rac_delegateProxy) return;
    
    self.rac_delegateProxy.rac_proxiedDelegate = self.delegate;
    self.delegate = (id)self.rac_delegateProxy;
}

- (RACDelegateProxy *)rac_delegateProxy {
    RACDelegateProxy *proxy = objc_getAssociatedObject(self, _cmd);
    if (proxy == nil) {
        proxy = [[RACDelegateProxy alloc] initWithProtocol:@protocol(UICollectionViewDelegate)];
        objc_setAssociatedObject(self, _cmd, proxy, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    
    return proxy;
}

- (RACSignal *)cellSelectedSignal {
    RACSignal *signal = [[[[self.rac_delegateProxy
                            signalForSelector:@selector(collectionView:didSelectItemAtIndexPath:)]
                           map:^(RACTuple *tuple) {
                               return  tuple;
                           }]
                          takeUntil:self.rac_willDeallocSignal]
                         setNameWithFormat:@"%@ -rac_buttonClickedSignal", RACDescription(self)];
    
    RACUseDelegateProxy(self);
    
    return signal;
}




@end
