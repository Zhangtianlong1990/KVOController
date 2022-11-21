//
//  NSObject+OBExtention.m
//  KVOController
//
//  Created by 张天龙 on 2022/11/20.
//

#import "NSObject+OBExtention.h"
#import <objc/runtime.h>

@implementation NSObject (OBExtention)

static char kObserverArrayKey;

- (NSHashTable *)getObservers{
    
    NSHashTable *table = objc_getAssociatedObject(self,&kObserverArrayKey);
    
    if (!table) {
        table = [NSHashTable hashTableWithOptions:NSPointerFunctionsStrongMemory];
        objc_setAssociatedObject(self, &kObserverArrayKey, table, OBJC_ASSOCIATION_RETAIN);
    }
    
    return table;
    
}

@end
