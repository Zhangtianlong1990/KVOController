//
//  MJObserver.h
//  KVOController
//
//  Created by 张天龙 on 2022/11/20.
//

#import <Foundation/Foundation.h>

typedef void(^DeallocBlock)(NSObject *removeObj, NSString *cacheKey, NSString *keyPath, BOOL combine);

@interface MJObserver : NSObject
@property (nonatomic,copy) DeallocBlock deallocBlock;
//这个必须是assign,weak的话，回调的时候object已经为nil了，无法删除KVO监听
@property (nonatomic,assign) NSObject *object;
@property (nonatomic,copy) NSString *keyPath;
@property (nonatomic,copy) NSString *cacheKey;
@property (nonatomic,assign) BOOL combine;
@end
