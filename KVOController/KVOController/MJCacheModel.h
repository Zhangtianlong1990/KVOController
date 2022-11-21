//
//  MJCacheModel.h
//  KVOController
//
//  Created by 张天龙 on 2022/11/21.
//

#import <Foundation/Foundation.h>

@interface MJCacheModel : NSObject
@property (nonatomic,strong) NSMutableArray *blocks;
@property (nonatomic,copy) NSString *keyPath;
@property (nonatomic,strong) NSArray *keyPathArray;
@property (nonatomic,strong) NSMutableDictionary *haveNotifyKeyPaths;
@property (nonatomic,assign) BOOL combine;
@end

