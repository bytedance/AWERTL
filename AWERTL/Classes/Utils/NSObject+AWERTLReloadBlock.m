//
//  NSObject+AWERTLReloadBlock.m
//  AWERTL
//
//  Created by 熊典 on 2018/12/6.
//

#import "NSObject+AWERTLReloadBlock.h"
#import <objc/runtime.h>

@interface NSObject ()

@property (nonatomic, strong) NSMutableDictionary<NSString *, void (^)(void)> *awertl_reloadBlocks;

@end

@implementation NSObject (AWERTLReloadBlock)

- (void)setAwertl_reloadBlocks:(NSMutableDictionary<NSString *,void (^)(void)> *)awertl_reloadBlocks
{
    objc_setAssociatedObject(self, @selector(awertl_reloadBlocks), awertl_reloadBlocks, OBJC_ASSOCIATION_RETAIN);
}

- (NSMutableDictionary<NSString *,void (^)(void)> *)awertl_reloadBlocks
{
    return objc_getAssociatedObject(self, _cmd);
}

- (void)awertl_addReloadBlockForKey:(NSString *)key andExecuteIt:(void (^)(void))reloadBlock
{
    if (!self.awertl_reloadBlocks) {
        self.awertl_reloadBlocks = [NSMutableDictionary dictionary];
    }
    if (reloadBlock) {
        [self.awertl_reloadBlocks setObject:reloadBlock forKey:key];
        reloadBlock();
    }
}

- (void)awertl_performReload
{
    if (self.awertl_reloadBlocks) {
        [self.awertl_reloadBlocks enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, void (^ _Nonnull obj)(void), BOOL * _Nonnull stop) {
            obj();
        }];
    }
}

@end
