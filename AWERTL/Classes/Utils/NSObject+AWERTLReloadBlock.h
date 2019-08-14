//
//  NSObject+AWERTLReloadBlock.h
//  AWERTL
//
//  Created by 熊典 on 2018/12/6.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (AWERTLReloadBlock)

- (void)awertl_performReload;
- (void)awertl_addReloadBlockForKey:(NSString *)key andExecuteIt:(void (^)(void))reloadBlock;

@end

NS_ASSUME_NONNULL_END
