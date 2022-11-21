//
//  MJCacheModel.m
//  KVOController
//
//  Created by 张天龙 on 2022/11/21.
//

#import "MJCacheModel.h"

@implementation MJCacheModel
- (instancetype)init
{
    self = [super init];
    if (self) {
        _blocks = [NSMutableArray array];
        _haveNotifyKeyPaths = [NSMutableDictionary dictionary];
    }
    return self;
}



@end
