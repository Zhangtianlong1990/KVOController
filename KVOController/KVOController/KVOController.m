//
//  KVOController.m
//  KVOController
//
//  Created by 张天龙 on 2022/11/20.
//

#import "KVOController.h"
#import <objc/runtime.h>
#import "MJObserver.h"
#import "NSObject+OBExtention.h"
#import "MJCacheModel.h"

@interface KVOController ()

@property (nonatomic,strong) NSMutableDictionary *cache;
@property (nonatomic,strong) dispatch_semaphore_t sema;
@end

@implementation KVOController

//单例初始化
+ (instancetype)shareInstance{
    static KVOController *controller = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        controller = [KVOController new];
        controller.cache = [NSMutableDictionary dictionary];
        controller.sema = dispatch_semaphore_create(1);
    });
    return controller;
}

- (void)mj_observeObject:(NSObject *)object forKeyPath:(NSString *)keyPath observerKeyPathDidChange:(ObserverKeyPathDidChange)observerKeyPathDidChange{
    
    dispatch_semaphore_wait(_sema, DISPATCH_TIME_FOREVER);
    
    NSAssert(keyPath != nil, @"keyPath参数不能为nil");
    NSAssert(![keyPath isEqualToString:@""], @"keyPath参数不能为空字符串");
    NSAssert(observerKeyPathDidChange != nil, @"observerKeyPathDidChange参数不能为nil");
    NSAssert(object != nil, @"object不能为nil");
    
    //cacheKey为description-keyPath
    NSString *cacheKey = [NSString stringWithFormat:@"%@-%@",[object description],keyPath];
    
    MJCacheModel *cacheModel = [self.cache objectForKey:cacheKey];
    
    if (!cacheModel) {
        
        [object addObserver:self forKeyPath:keyPath options:NSKeyValueObservingOptionNew context:NULL];
        
        cacheModel = [[MJCacheModel alloc] init];
        cacheModel.keyPath = keyPath;
        
        MJObserver *observer = [[MJObserver alloc] init];
        observer.object = object;
        observer.cacheKey = cacheKey;
        observer.keyPath = keyPath;
        __weak KVOController *weakSelf = self;
        observer.deallocBlock = ^(NSObject *removeObj, NSString *cacheKey, NSString *keyPath, BOOL combine) {
            [weakSelf mj_removeObserver:removeObj cacheKey:cacheKey keyPath:keyPath combine:combine];
        };
        [object.getObservers addObject:observer];
    }

    
    [cacheModel.blocks addObject:[observerKeyPathDidChange copy]];
    [self.cache setObject:cacheModel forKey:cacheKey];
    
    dispatch_semaphore_signal(_sema);
    
}

- (void)mj_observeObject:(NSObject *)object forKeyPaths:(NSString *)keyPaths observerKeyPathDidChange:(ObserverKeyPathDidChange)observerKeyPathDidChange{
    
    dispatch_semaphore_wait(_sema, DISPATCH_TIME_FOREVER);
    
    NSAssert(keyPaths != nil, @"keyPath参数不能为nil");
    NSAssert(![keyPaths isEqualToString:@""], @"keyPath参数不能为空字符串");
    NSAssert(observerKeyPathDidChange != nil, @"observerKeyPathDidChange参数不能为nil");
    NSAssert(object != nil, @"object不能为nil");
    
    NSString *cacheKey = [NSString stringWithFormat:@"%@-%@",[object description],keyPaths];
    
    MJCacheModel *cacheModel = [self.cache objectForKey:cacheKey];
    
    if (!cacheModel) {
        
        NSArray *keyPathArray = [keyPaths componentsSeparatedByString:@"-"];
        for (NSString *aKeyPath in keyPathArray) {
            NSAssert(![aKeyPath isEqualToString:@""], @"keyPath参数不能为空字符串,请按照格式填写");
        }
        cacheModel = [[MJCacheModel alloc] init];
        cacheModel.combine = YES;
        cacheModel.keyPath = keyPaths;
        cacheModel.keyPathArray = keyPathArray;
        for (NSString *keyPath in keyPathArray) {
            [object addObserver:self forKeyPath:keyPath options:NSKeyValueObservingOptionNew context:NULL];
        }
        
        MJObserver *observer = [[MJObserver alloc] init];
        observer.object = object;
        observer.cacheKey = cacheKey;
        observer.keyPath = keyPaths;
        observer.combine = YES;
        __weak KVOController *weakSelf = self;
        observer.deallocBlock = ^(NSObject *removeObj, NSString *cacheKey, NSString *keyPath, BOOL combine) {
            [weakSelf mj_removeObserver:removeObj cacheKey:cacheKey keyPath:keyPath combine:combine];
        };
        [object.getObservers addObject:observer];
    }

    [cacheModel.blocks addObject:[observerKeyPathDidChange copy]];
    [self.cache setObject:cacheModel forKey:cacheKey];
    
    dispatch_semaphore_signal(_sema);
    
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    
    dispatch_semaphore_wait(_sema, DISPATCH_TIME_FOREVER);
    
    NSLog(@"observeValueForKeyPath=%@,%@--%@",[NSThread currentThread],object,keyPath);
    
    if (!change[@"new"]) {
        return;
    }
    
    [self.cache enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        MJCacheModel *cacheModel = obj;
        NSString *cacheKey = key;
        //前缀区分不同对象的keyPath
        if ([cacheKey hasPrefix:[object description]]) {
            if (cacheModel.combine) {
                //是否属于combine的一个keyPath
                if ([cacheModel.keyPathArray containsObject:keyPath]) {
                    //保存已经监听的keyPath对应的change
                    cacheModel.haveNotifyKeyPaths[keyPath] = change[@"new"];
                    
                    //检查是否所有的keyPath监听到，都监听到就可以回调
                    BOOL isCanNotify = NO;
                    for (NSString *aKeyPath in cacheModel.keyPathArray) {
                        isCanNotify = [cacheModel.haveNotifyKeyPaths.allKeys containsObject:aKeyPath];
                        if (!isCanNotify) {
                            break;
                        }
                    }
                    
                    if (isCanNotify) {
                        for (ObserverKeyPathDidChange cacheblock in cacheModel.blocks) {
                            ObserverKeyPathDidChange block = [cacheblock copy];
                            //{keyPath:value, keyPath:value}这样格式回调数据
                            NSDictionary *changes = [cacheModel.haveNotifyKeyPaths copy];
                            dispatch_async(dispatch_get_main_queue(), ^{
                                block(changes);
                            });
                        }
                    }
                    
                }
            }else{
                if ([cacheModel.keyPath isEqualToString:keyPath]) {
                    for (ObserverKeyPathDidChange cacheblock in cacheModel.blocks) {
                        ObserverKeyPathDidChange block = [cacheblock copy];
                        dispatch_async(dispatch_get_main_queue(), ^{
                            block(change[@"new"]);
                        });
                    }
                }
            }
        }
    }];
    
    dispatch_semaphore_signal(_sema);
    
}

- (void)mj_removeObserver:(NSObject *)removeObj cacheKey:(NSString *)cacheKey keyPath:(NSString *)keyPath combine:(BOOL)combine{
    dispatch_semaphore_wait(_sema, DISPATCH_TIME_FOREVER);
    if (combine) {
        NSArray *keyPathArray = [keyPath componentsSeparatedByString:@"-"];
        for (NSString *mKeyPath in keyPathArray) {
            [removeObj addObserver:self forKeyPath:mKeyPath options:NSKeyValueObservingOptionNew context:NULL];
        }
    }else{
        [removeObj removeObserver:self forKeyPath:keyPath context:NULL];
    }
    
    [self.cache removeObjectForKey:cacheKey];
    NSLog(@"removeObserver:thread: %@, object=%@--keyPath=%@, cache %@ ",[NSThread currentThread],removeObj.description,keyPath,self.cache.allKeys);
    dispatch_semaphore_signal(_sema);
    
}

@end
