//
//  MJObserver.m
//  KVOController
//
//  Created by 张天龙 on 2022/11/20.
//

#import "MJObserver.h"
#import <objc/runtime.h>

@implementation MJObserver

- (void)dealloc{
    
//    NSLog(@"%@-dealloc",self.name);
    
    if (self.deallocBlock) {
        self.deallocBlock(self.object,self.cacheKey,self.keyPath,self.combine);
        self.object = nil;
    }
    
}
@end
