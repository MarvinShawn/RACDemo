


#import "BTComplexionCell.h"
#import "BTangSingleModel.h"
#import "UIImageView+WebCache.h"

@interface BTComplexionCell()

/**
 *  产品图片
 */
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
/**
 *  产品名称
 */
@property (weak, nonatomic) IBOutlet UILabel *productNameLabel;

/**
 *  产品描述
 */
@property (weak, nonatomic) IBOutlet UILabel *descLabel;
/**
 *  价格
 */
@property (weak, nonatomic) IBOutlet UIButton *priceBtn;
/**
 *  喜爱人数
 */
@property (weak, nonatomic) IBOutlet UIButton *likesBtn;


@property (nonatomic,assign) BOOL isLike;


@property (weak, nonatomic) IBOutlet UIImageView *newestProduct;

@end


@implementation BTComplexionCell

- (void)awakeFromNib {
    [super awakeFromNib];
      [self initBind];

}

- (void)initBind {
 
    
    /*================ 喜欢按钮的点击事件==================*/
    /*
     Tips:正真点击了喜欢按钮是需要做网络请求的,因为服务器需要记录你是否喜欢,下一次,搜索再到对应的商品时,应该根据你是否喜欢返回对应的数据,这里我没发请求,只是简单的改变了状态.
     */
    
    [[self.likesBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(UIButton *button) {
        
        self.isLike = !self.isLike;
        
        NSInteger result = -1;
        if (self.isLike) {
            result = 1;
             [button setImage:[UIImage imageNamed:@"home_item_like"] forState:UIControlStateNormal];
            
            //核心动画,组动画
            CAAnimationGroup *animation = [[CAAnimationGroup alloc] init];
            animation.duration = 0.5;
            
            CABasicAnimation *sAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
            sAnimation.toValue = @(2);
            
            CABasicAnimation *oAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
            oAnimation.toValue = @(0);
            animation.animations = @[sAnimation,oAnimation];
            
            [button.imageView.layer addAnimation:animation forKey:@"animationKey"];
            
        }else {
            
            [button setImage:[UIImage imageNamed:@"home_item_unlike"] forState:UIControlStateNormal];
        }
        
        //改变button上的字
        NSInteger sum = button.currentTitle.integerValue + result;
        NSString *likeStr = [NSString stringWithFormat:@"%zd",sum];
        [button setTitle:likeStr forState:UIControlStateNormal];
        
        //改变模型对应的值+1或者-1
//        !self.likeSignal ? : [self.likeSignal subscribeNext:@(result)];  这个可以代替代理传值,但是也不必要,直接用个block更方便.
        !self.clickButton ? : self.clickButton(likeStr,self.isLike);
    }];
    

    /*============= RAC观察singleModel(代替了下面的setter方法)==============*/
    @weakify(self) //解决循环引用
    [RACObserve(self, singleModel) subscribeNext:^(BTangSingleModel *singleModel) {
        @strongify(self)
        [self.imageView sd_setImageWithURL:[NSURL URLWithString:singleModel.pic]];
        self.productNameLabel.text = singleModel.title;
        self.descLabel.text = singleModel.desc;
        NSString *priceStr = [NSString stringWithFormat:@"¥%@",singleModel.price];
        [self.priceBtn setTitle:priceStr forState:UIControlStateNormal];
        
        
        [self.likesBtn setImage:[UIImage imageNamed:(singleModel.isLike ? @"home_item_like" : @"home_item_unlike")] forState:UIControlStateNormal];
        
        self.newestProduct.alpha = !singleModel.isPurchased;
        
        [self.likesBtn setTitle:singleModel.likes forState:UIControlStateNormal];
    }];
    

}


@end
