

#import <Foundation/Foundation.h>
typedef void (^successBlock)(id responseBody);
typedef void (^failureBlock)(NSError * error);
@interface BTangSingleModel : NSObject
@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *desc;
@property (nonatomic, copy) NSString *price;
@property (nonatomic, copy) NSString *product_type;
@property (nonatomic, copy) NSString *platform;
@property (nonatomic, copy) NSString *item_id;
@property (nonatomic, copy) NSString *url;
@property (nonatomic, copy) NSString *pic;
@property (nonatomic,strong) NSArray *pics;
@property (nonatomic, copy) NSString *likes;
@property (nonatomic,assign) BOOL isLike;

@property (nonatomic,assign) BOOL isPurchased;
+ (instancetype)getSingleModelWithDict:(NSDictionary *)dict;

+(void)getSingleModelWtihUrlstr:(NSString*)url Paramer:(id)paramer Success:(successBlock)successBlock Failure:(failureBlock)failureBlock;
@end
