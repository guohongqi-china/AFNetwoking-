//
//  VNRequestOperation.m
//  CER_IKE_01
//
//  Created by guohq on 2019/8/6.
//  Copyright © 2019 saicmotor. All rights reserved.
//
typedef void(^OperationBlock)(void);


#import "VNRequestOperation.h"

@interface VNRequestOperation()

@property (nonatomic, readwrite, getter=isExecuting) BOOL executing;
@property (nonatomic, readwrite, getter=isFinished) BOOL finished;
@property (nonatomic, readwrite, getter=isCancelled) BOOL cancelled;
@property (nonatomic, readwrite, getter=isStarted) BOOL started;

@property (nonatomic, strong) NSRecursiveLock *lock;

@property (nonatomic, copy)    OperationBlock           taskBlock;

@end

@implementation VNRequestOperation
// 因为父类的属性是Readonly的，重载时如果需要setter的话则需要手动合成。
@synthesize executing = _executing;
@synthesize finished = _finished;
@synthesize cancelled = _cancelled;

- (nullable instancetype)initOperationWithTask:(void (^)(void))taskBlock{
    if (self = [super init]) {
        _taskBlock = taskBlock;
        _lock      = [NSRecursiveLock new];
    }
    return self;
}

- (void)start{
    
    @autoreleasepool {
//        [_lock lock];
        
        self.started = YES;
        if (self.cancelled) {
            NSLog(@"取消下载");
            return;
        }
        
        _taskBlock();
//        [_lock unlock];
        [self done];
    }
    
}

- (void)done{
    self.finished = YES;
    self.executing = NO;
}

/**
 取消操作的方法 --- 需要进行判断
 */
- (void)cancel{
    
    [_lock lock];
    if (![self isCancelled]) {
        [super cancel];
        self.cancelled = YES;
        if ([self isExecuting]) {
            self.executing = NO;
        }
        if (self.started) {
            self.finished = YES;
        }
    }
    [_lock unlock];
}

#pragma mark - setter -- getter

- (BOOL)isExecuting {
    [_lock lock];
    BOOL executing = _executing;
    [_lock unlock];
    return executing;
}

- (void)setFinished:(BOOL)finished {
    [_lock lock];
    if (_finished != finished) {
        [self willChangeValueForKey:@"isFinished"];
        _finished = finished;
        [self didChangeValueForKey:@"isFinished"];
    }
    [_lock unlock];
}

- (BOOL)isFinished {
    [_lock lock];
    BOOL finished = _finished;
    [_lock unlock];
    return finished;
}

- (void)setCancelled:(BOOL)cancelled {
    [_lock lock];
    if (_cancelled != cancelled) {
        [self willChangeValueForKey:@"isCancelled"];
        _cancelled = cancelled;
        [self didChangeValueForKey:@"isCancelled"];
    }
    [_lock unlock];
}

- (BOOL)isCancelled {
    [_lock lock];
    BOOL cancelled = _cancelled;
    [_lock unlock];
    return cancelled;
}
- (BOOL)isConcurrent {
    return YES;
}
- (BOOL)isAsynchronous {
    return YES;
}

+ (BOOL)automaticallyNotifiesObserversForKey:(NSString *)key {
    if ([key isEqualToString:@"isExecuting"] ||
        [key isEqualToString:@"isFinished"] ||
        [key isEqualToString:@"isCancelled"]) {
        return NO;
    }
    return [super automaticallyNotifiesObserversForKey:key];
}

- (void)dealloc{
    NSLog(@"销毁 %@",self.name);
}

@end
