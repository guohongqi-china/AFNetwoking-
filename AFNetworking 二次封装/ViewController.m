//
//  ViewController.m
//  AFNetworking 二次封装
//
//  Created by guohq on 2018/8/2.
//  Copyright © 2018年 guohq. All rights reserved.
//

#import "ViewController.h"
#import "VNHttpRequestManager.h"
#import <mach/mach.h>
#import "AFNetworking.h"
#import "VNRequestOperation.h"


@interface ViewController ()
{
    NSURLSessionDownloadTask *downTask;
    NSOperationQueue *queue;
}
@property (nonatomic, strong) NSMutableArray *itemArr;

- (void)afsdfadsfasfa;
@end

@implementation ViewController


char sortArray(char *cha){
    
    char result = '\0';
    int  array[256];
    for (int i = 0; i < 256; i++) {
        array[i] = 0;
    }
    char *p = cha;
    while (*p != '\0') {
        array[*(p++)]++;
    }
    
    p = cha;
    while (*p != '\0') {
        if (array[*p] == 1) {
            result = *p;
            break;
        }
        p++;
    }
    
    return result;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    char cha[] = "afdsfasd";
    char result = sortArray(cha);
    printf("%c", result);
    
    VNRequestOperation *operation = [[VNRequestOperation alloc]initOperationWithTask:^{
        downTask =  [VNHttpRequestManager downLoadRequest:@"http://dldir1.qq.com/qqfile/QQforMac/QQ_V5.4.0.dmg"  filePath:nil downProgress:^(double progress) {
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                NSLog(@"%f",progress);
            }];
        } complement:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
            
        }];
    }];
    operation.name = @"com.678";
    
    queue                               = [[NSOperationQueue alloc]init];
    queue.name                          = @"com.guohq";
    queue.maxConcurrentOperationCount   = 2;
    
    [queue addOperation:operation];
    
    
    
    
   
    
    
//    for(int i = 0; i < 1000000; i++) {
////        @autoreleasepool {
//        NSNumber *num = [NSNumber numberWithInt:i];
//        NSString *str = [NSString stringWithFormat:@"%d ", i];
//        NSString *result = [NSString stringWithFormat:@"%@%@", num, str];
//        NSLog(@"%@",result);
////        }
//    }
//    NSMutableData *reqData = [NSMutableData data];
//    [reqData appendData:[@"0147111008E00F82C60C183060C183060C183060C183060C183060C183060C183060C183060C183062C183060C183060C183272CF333678983964C31E36ECF330698B0E2C4C71E166D30B46EE59386189A636591AE26CCDAB363329CA82C9A5772C225372E583064C16DD8AFB0000000061A84040004465C4444924A48509DC48D159E26848D159E2680000004C0201008000000000008000000000051A1CF9B360CE88" dataUsingEncoding:NSISOLatin1StringEncoding]];
//    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
//    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] requestWithMethod:@"POST" URLString:@"http://10.78.251.31:8080/TAP.Web/ota.mp" parameters:nil error:nil];
//    request.timeoutInterval= 30.0f;
//    [request setValue:@"f33b0920cc73f04babb1ca34a479280b4c2d5b63" forHTTPHeaderField:@"key"];
//    // 设置body
//    [request setHTTPBody:reqData];
//    AFHTTPResponseSerializer *responseSerializer = [AFHTTPResponseSerializer serializer];
//    responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",
//                                                 @"text/html",
//                                                 @"text/json",
//                                                 @"text/javascript",
//                                                 @"text/plain",
//                                                 nil];
//    manager.responseSerializer = responseSerializer;
//    [manager dataTaskWithRequest:request uploadProgress:^(NSProgress * _Nonnull uploadProgress) {
//        NSLog(@"====");
//
//    } downloadProgress:^(NSProgress * _Nonnull downloadProgress) {
//        NSLog(@"====");
//
//    } completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
//        NSLog(@"====");
//    }];
//
}


double getMemoryUsage(void) {
    struct task_basic_info info;
    mach_msg_type_number_t size = sizeof(info);
    kern_return_t kerr = task_info(mach_task_self_, TASK_BASIC_INFO, (task_info_t)&info, &size);
    double memoryUsageInMB = kerr == KERN_SUCCESS ? (info.resident_size / 1024.0 / 1024.0) : 0.0;
    return memoryUsageInMB;
}



- (IBAction)getAction:(UIButton *)sender {
    
    __weak ViewController *weakself = self;
    [VNHttpRequestManager sendJSONRequestWithMethod:RequestMethod_Get pathUrl:@"https://westus.api.cognitive.microsoft.com/spid/v1.0/identificationProfiles" params:nil complement:^(ServerResponseInfo *serverInfo) {
        if (serverInfo.isSuccess) {
            weakself.itemArr = [serverInfo.response mutableCopy];
        }
    }];
    
//    [VNHttpRequestManager sendJSONRequestWithMethod:RequestMethod_Get pathUrl:@"https://westus.api.cognitive.microsoft.com/spid/v1.0/identificationProfiles" requestData:nil complement:^(ServerResponseInfo *serverInfo) {
//
//    }];
    
    
}
- (IBAction)cancleBtn:(UIButton *)sender {
    
    [VNHttpRequestManager cancleRequestWork];
    
}

- (IBAction)postAction:(UIButton *)sender {
    [VNHttpRequestManager sendJSONRequestWithMethod:RequestMethod_Post pathUrl:@"https://westus.api.cognitive.microsoft.com/spid/v1.0/identificationProfiles/" params:@{@"locale":@"en-us"} complement:^(ServerResponseInfo *serverInfo) {
        if (serverInfo.isSuccess) {
            
        }
    }];
}

- (IBAction)deleteAction:(UIButton *)sender {
    NSString *pathStr = [@"https://westus.api.cognitive.microsoft.com/spid/v1.0/identificationProfiles/" stringByAppendingString:self.itemArr.firstObject[@"identificationProfileId"]];
    [VNHttpRequestManager sendJSONRequestWithMethod:RequestMethod_Delete pathUrl:pathStr params:nil complement:^(ServerResponseInfo *serverInfo) {
        if (serverInfo.isSuccess) {
            [self.itemArr removeObjectAtIndex:0];
        }
    }];
    
}
- (IBAction)uploadAction:(UIButton *)sender {
    
    [VNHttpRequestManager uploadFileWithPath:@"https://westus.api.cognitive.microsoft.com/spid/v1.0/identificationProfiles/28277c34-9512-4b89-97af-3a3683172287/enroll?shortAudio=true" filePath:@[@"/Users/guohq/Desktop/guohq.wav"] parms:nil fileType:FileType_Video result:^(ServerResponseInfo *serverInfo) {
        if (serverInfo.isSuccess) {
            [self.itemArr removeObjectAtIndex:0];
        }
    }];
    
}

- (IBAction)downAction:(id)sender {
        [VNHttpRequestManager startResume:downTask];
    // 时间戳转时间
//    NSTimeInterval time = [[NSDate date] timeIntervalSince1970]*1000;
//
//
//    NSLog(@"时间戳转时间   = %f",time);
//
//    [VNHttpRequestManager sendJSONRequestWithMethod:RequestMethod_Post pathUrl:@"http://app.u17.com/v3/appV3_3/ios/phone/comic/boutiqueListNew" params:@{@"sexType":@"1",@"key":@"fabe6953ce6a1b8738bd2cabebf893a472d2b6274ef7ef6f6a5dc7171e5cafb14933ae65c70bceb97e0e9d47af6324d50394ba70c1bb462e0ed18b88b26095a82be87bc9eddf8e548a2a3859274b25bd0ecfce13e81f8317cfafa822d8ee486fe2c43e7acd93e9f19fdae5c628266dc4762060f6026c5ca83e865844fc6beea59822ed4a70f5288c25edb1367700ebf5c78a27f5cce53036f1dac4a776588cd890cd54f9e5a7adcaeec340c7a69cd986:::open",@"target":@"U17_3.0",@"version":@"3.3.3",@"v":@"3320101",@"model":@"Simulator",@"device_id":@"29B09615-E478-4320-8E6A-55B1DE48CB36",@"time":[NSNumber numberWithDouble:time]} complement:^(ServerResponseInfo *serverInfo) {
//        if (serverInfo.isSuccess) {
//
//        }
//    }];

}

- (IBAction)suapendAction:(id)sender {
    [VNHttpRequestManager suspend:downTask];
    [queue setSuspended:YES];
}

- (IBAction)continueAction:(id)sender {
    [VNHttpRequestManager startResume:downTask];
    [queue setSuspended:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
