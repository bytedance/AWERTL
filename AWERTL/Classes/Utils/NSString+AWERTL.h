//
//  NSString+AWERTL.h
//  Pods
//
//  Created by 唐健 on 2019/5/23.
//



NS_ASSUME_NONNULL_BEGIN

@interface NSString (AWERTL)

- (BOOL)isRTLString;
- (BOOL)isLTRString;
- (NSString *)RTLString;
- (NSString *)LTRString;

@end

NS_ASSUME_NONNULL_END
