


#import <UIKit/UIKit.h>
#import <ReactiveCocoa/ReactiveCocoa.h>
@class BTangSingleModel;
@interface BTComplexionCell : UICollectionViewCell
@property (nonatomic, strong) BTangSingleModel *singleModel;

@property (nonatomic,strong) RACSubject *likeSignal;



@property(nonatomic,copy) void (^clickButton)(NSString *,BOOL);


@end
