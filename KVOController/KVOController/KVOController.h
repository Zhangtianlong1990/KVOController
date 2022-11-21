//
//  KVOController.h
//  KVOController
//
//  Created by 张天龙 on 2022/11/20.
//

#import <Foundation/Foundation.h>

typedef void(^ObserverKeyPathDidChange)(id value);

@interface KVOController : NSObject
+ (instancetype)shareInstance;
//监听单个keyPath
- (void)mj_observeObject:(NSObject *)object forKeyPath:(NSString *)keyPath observerKeyPathDidChange:(ObserverKeyPathDidChange)observerKeyPathDidChange;
//combine多个keyPath,格式为keyPath-keyPath-keyPath
- (void)mj_observeObject:(NSObject *)object forKeyPaths:(NSString *)keyPaths observerKeyPathDidChange:(ObserverKeyPathDidChange)observerKeyPathDidChange;

@end
