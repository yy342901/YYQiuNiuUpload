
#import "MyUploadManager.h"

@implementation MyUploadManager
+(MyUploadManager *)shareInsance
{

    static MyUploadManager *manager;
    static dispatch_once_t token;
    dispatch_once(&token, ^{
       
        manager = [[MyUploadManager alloc]init];
        
    });
    return manager;
    
}

-(void)uploadImageArray:(NSMutableArray *)imageArr withToken:(NSString *)token success:(successBlock)success failure:(failureBlock)failure 
{

    NSMutableArray *fileArray  =  [NSMutableArray array];//文件名数组 上传成功后的文件数组
    NSMutableArray *errorArray =  [NSMutableArray array];//错误数组   上传失败的文件数组
    
    dispatch_group_t group = dispatch_group_create();
    dispatch_queue_t globalQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_group_async(group, globalQueue, ^{
        for (int i = 0; i<imageArr.count; i++)
        {
            UIImage *newImage = imageArr[i];
            NSString *fileName = [NSString stringWithFormat:@"pic_%d",i];//这里是文件名，一般按照后台需要拼接
           
            NSData *data;
            //处理图片
            if (UIImagePNGRepresentation(newImage) == nil)
            {
                data = UIImageJPEGRepresentation(newImage, 0.9);
            }else
            {
                data = UIImagePNGRepresentation(newImage);
            }
            __block CGFloat currentPresent =0;//当前进度
            QNUploadOption *opt = [[QNUploadOption alloc] initWithProgessHandler:^(NSString *key, float percent)
            {
                currentPresent +=percent;
            }];
            dispatch_group_enter(group);
            [[MyUploadManager shareInsance] putData:data key:fileName token:token complete:^(QNResponseInfo *info, NSString *key, NSDictionary *resp)
            {
                if(info.error!=nil)
                {
                    [errorArray addObject:info.error];
                    return;
                }else{
                    [fileArray addObject:fileName];
                }
                dispatch_group_leave(group);
            } option:opt];
        }
        //全部上传完再执行这里的操作
        dispatch_group_notify(group, dispatch_get_main_queue(), ^{
            success(fileArray);
            failure(errorArray);
        });
    });
}

@end
