
//  ---------------注意导入AFNetworking------------------

#import "QNUploadManager.h"
#import "QiniuSDK.h"
#import <UIKit/UIKit.h>
@class QNUploadOption;
typedef void (^successBlock)(NSMutableArray* imageNameArray);
typedef void (^failureBlock)(NSMutableArray* failImageArray);
@interface MyUploadManager : QNUploadManager
+(MyUploadManager*)shareInsance;

/**
 *  上传图片数组
 *
 *  @param imageArr 图片数组
 *  @param token    后台返回的token
 *  @param success  成功回调block
 *  @param failure  失败回调block
 */
-(void)uploadImageArray:(NSMutableArray*)imageArr withToken:(NSString*)token success:(successBlock)success failure:(failureBlock)failure;

@end
