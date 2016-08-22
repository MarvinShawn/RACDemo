//
//  Created by ww on 16/7/7.
//  Copyright © 2016年 ww. All rights reserved.
//
#import "BTSingleDetailVC.h"
#import "BTComplexionCell.h"
#import "ToolBarView.h"
#import "SingleDetailViewModel.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "UICollectionView+cellSelectedSignal.h"
#import "PurchaseViewController.h"
#define ScreenW [UIScreen mainScreen].bounds.size.width
#define ScreenH [UIScreen mainScreen].bounds.size.height

@interface BTSingleDetailVC ()<UICollectionViewDataSource,UICollectionViewDelegate>

@property (nonatomic,strong) SingleDetailViewModel *singleViewModel;

@property (nonatomic,strong) UICollectionViewFlowLayout *layout;

@property (nonatomic,strong) UICollectionView *goodsView;

///  底部的toolBarView
@property (nonatomic,strong) ToolBarView *toolBarView;

///  遮盖提示View
@property (nonatomic,strong) UIView *coverView;

///  搜索框
@property (nonatomic,strong) UITextField *searchTextField;

///  偏移量
@property (nonatomic,assign) CGFloat offsetY;

@end

@implementation BTSingleDetailVC

static NSString * const reuseIdentifier = @"Cell";
/*
 需求:
 
 
 
 */

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.edgesForExtendedLayout =  UIRectEdgeNone;
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];


    [self.view addSubview:self.goodsView];
    [self.view addSubview:self.toolBarView];
    [self.view addSubview:self.coverView];
    

    [self bindViewModel];
    [self changeToolBarState];
    [self collectionViewCellAction];
    
 
}

///   toolBarView的显示和隐藏
- (void)changeToolBarState {

    /*================ toolBarView的显示和隐藏 ==================*/
    
    //  用这种方式好像不能加动画了...
    { /*    RAC(self.toolBarView,transform) = [[self rac_signalForSelector:@selector(scrollViewDidScroll:) fromProtocol:@protocol(UICollectionViewDelegate)] map:^id(RACTuple *tuple) {
       
       [self.searchTextField resignFirstResponder];
       //        NSLog(@"%@",tuple.first);
       UICollectionView *collectionView = tuple.first;
       if (collectionView.contentOffset.y > self.offsetY && collectionView.contentOffset.y >0 ) {
       return  [NSValue valueWithCGAffineTransform:CGAffineTransformMakeTranslation(0, (ScreenH - 64) * 0.07)];
       }else {
       return  [NSValue valueWithCGAffineTransform:CGAffineTransformIdentity];
       }
       }];*/}
    //这种可以加动画
    [RACObserve(self.goodsView, contentOffset) subscribeNext:^(id x) {
        
        [self.searchTextField resignFirstResponder];
        
        CGPoint newContentOffset = [x CGPointValue];
        
        if (newContentOffset.y > self.offsetY && newContentOffset.y >0) {
            
            [UIView animateWithDuration:0.3 animations:^{
                
                self.toolBarView.transform = CGAffineTransformMakeTranslation(0, (ScreenH - 64) * 0.07);
            }];
            
        }else {
            
            [UIView animateWithDuration:0.3 animations:^{
                
                self.toolBarView.transform = CGAffineTransformIdentity;
            }];
        }
    }];

}


///  绑定模型视图
- (void)bindViewModel {
    /*=========输入文字或者点击按钮后,请求数据,然后,更新UI ===========*/
    /*
     在ToolBarView 里 暴露了一个rac_clickButton信号,默认会传出0,如果点击ToolBarView上的Button的话,就会传出对应的tag值,然后配合文本框里的内容,包装成一个元组发送出去,viewModel拿到元组里的内容作为参数来请求数据,viewModel请求数据后发送一个信号(其值是YES/NO,表示是否请求成功),collectionView根据其值来确定是否刷新UI
     */
    //请求数据信号
    RACSignal *requestDataSignal = [[[[self.searchTextField.rac_textSignal filter:^BOOL(NSString *value) {
        
        //当文本框的内容为空时,显示coverView,否则不显示
        self.coverView.alpha = value.length == 0 ? 1 : 0;
        
        return value.length > 0;
    }] distinctUntilChanged] combineLatestWith:[self.toolBarView.rac_clickButton distinctUntilChanged]] reduceEach:^id(NSString *value, NSNumber *tag){
        //distinctUntilChanged 是保证信号里的值不是重复的
        
        //RACTuplePack：把数据包装成RACTuple（元组类
        return RACTuplePack(tag,value);
        
    }];
    
    [[requestDataSignal throttle:0.85] subscribeNext:^(id x) {
        // throttle节流:当某个信号发送比较频繁时，可以使用节流，在某一段时间不发送信号内容，过了一段时间获取信号的最新内容发出。
        
        //这里的x 就是上面包装过的RACTuple
        [self.singleViewModel.requestCommand execute:x];
        
    }];
    
    /*==========在ViewModel返回信号后,刷新collectionView============*/
    /*
     executionSignals是signal of signals(信号的信号)，如果直接subscribe的话会得到一个signal，而不是value,所以一般会配合switchToLatest转换为value。
     */
    [[self.singleViewModel.requestCommand.executionSignals switchToLatest] subscribeNext:^(NSNumber *x) {
        
        if (x.boolValue == YES) {
            [self.goodsView reloadData];
            [self.searchTextField resignFirstResponder];
            self.toolBarView.transform = CGAffineTransformIdentity;;
        }
    }];
    
}


///  cell的点击
- (void)collectionViewCellAction {

    @weakify(self)
    [self.goodsView.cellSelectedSignal subscribeNext:^(RACTuple *tuple) {
        @strongify(self)


        NSIndexPath *indexPath = (NSIndexPath *)tuple.second;
        
         BTangSingleModel *singleModel =  self.singleViewModel.goodsStatus[indexPath.row];
        

        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        PurchaseViewController *purchaseVc = [sb instantiateViewControllerWithIdentifier:@"purchaseVC"];
        purchaseVc.singleModel = singleModel;
        

        [RACObserve(purchaseVc, isPurchased) subscribeNext:^(NSNumber *x) {
            
            singleModel.isPurchased = x.boolValue;
            [self.goodsView reloadItemsAtIndexPaths:@[indexPath]];
            
        }];
        
        [self.navigationController pushViewController:purchaseVc animated:YES];
        
    }];

}


#pragma mark - UICollectionViewDataSourceDelegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return self.singleViewModel.goodsStatus.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{

    BTComplexionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"complexionCell" forIndexPath:indexPath];
    
    BTangSingleModel *singleModel = self.singleViewModel.goodsStatus[indexPath.item];
    cell.singleModel = singleModel;
    
    //修改对应model的值
    [cell setClickButton:^(NSString *result,BOOL isLike) {
        singleModel.likes = result;
        singleModel.isLike = isLike;
    }];

    return cell;
}

#pragma mark -  methods of UICollectionViewDelegate 

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    
    self.offsetY = scrollView.contentOffset.y;

}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView  {

    self.offsetY = scrollView.contentOffset.y;
}

#pragma mark -  methods of lazyLoad

- (UICollectionView *)goodsView {

    if (_goodsView == nil) {
        _goodsView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.layout];
        _goodsView.frame = CGRectMake(0, 0, ScreenW, ScreenH - 64);
        [_goodsView registerNib:[UINib nibWithNibName:@"BTComplexionCell" bundle:nil] forCellWithReuseIdentifier:@"complexionCell"];
        _goodsView.backgroundColor = [UIColor colorWithRed:231 / 255.0 green:231 / 255.0 blue:231 / 255.0 alpha:1.0];
        _goodsView.delegate = self;
        _goodsView.dataSource = self;
    }
    return _goodsView;
}

- (UITextField *)searchTextField {
    
    if (_searchTextField == nil) {
        _searchTextField = [[UITextField alloc] init];
        _searchTextField.placeholder = @"请输入搜索内容";
        _searchTextField.backgroundColor = [UIColor lightGrayColor];
        _searchTextField.frame = CGRectMake(0, 0, 120, 25);
        
        self.navigationItem.titleView = _searchTextField;
    }
    return _searchTextField;

}

- (UICollectionViewFlowLayout *)layout {

    if (_layout == nil) {
        
        _layout = [[UICollectionViewFlowLayout alloc] init];

        int itemNumCol = 2;

        _layout.minimumInteritemSpacing = 10;
        CGFloat maginItmeX = self.layout.minimumInteritemSpacing;

        _layout.minimumLineSpacing = 10;
        _layout.sectionInset = UIEdgeInsetsMake(maginItmeX, maginItmeX, 0, maginItmeX);

        CGFloat itemSizeW = (ScreenW - (itemNumCol + 1) * maginItmeX) / itemNumCol;
        CGFloat itemSizeH = itemSizeW * 1.5;

        _layout.itemSize = CGSizeMake(itemSizeW, itemSizeH);
    }
    return _layout;

}

- (ToolBarView *)toolBarView {


    if (_toolBarView == nil) {
        _toolBarView = [[ToolBarView alloc] init];
        _toolBarView.frame = CGRectMake(10, (ScreenH - 64) * 0.93, ScreenW - 20, 30);
        _toolBarView.transform = CGAffineTransformMakeTranslation(0, (ScreenH - 64) * 0.07);
    }
    return _toolBarView;

}

- (SingleDetailViewModel *)singleViewModel {

    if (_singleViewModel == nil) {
        _singleViewModel = [[SingleDetailViewModel alloc] init];
    }
    return _singleViewModel;

}

- (UIView *)coverView {

    if (_coverView == nil) {
        _coverView = [[UIView alloc] initWithFrame:self.view.bounds];
        _coverView.backgroundColor = [UIColor whiteColor];
        UILabel *tipLabel = [[UILabel alloc] init];
        tipLabel.textAlignment = NSTextAlignmentCenter;
        tipLabel.textColor = [UIColor blackColor];
        tipLabel.text = @"😂啥都没有哦,请输入搜索内容";
        tipLabel.frame = CGRectMake(0, ScreenH *0.5, ScreenW, 25);
        [_coverView addSubview:tipLabel];
        
    }
    return _coverView;


}

@end
