//
//  AWERTLDefinitions.h
//  Pods
//
//  Created by 熊典 on 2018/10/9.
//

#ifndef AWERTLDefinitions_h
#define AWERTLDefinitions_h

#import <objc/runtime.h>

#ifndef btd_keywordify
#if DEBUG
#define btd_keywordify autoreleasepool {}
#else
#define btd_keywordify try {} @catch (...) {}
#endif
#endif

#ifndef weakify
#if __has_feature(objc_arc)
#define weakify(object) btd_keywordify __weak __typeof__(object) weak##_##object = object;
#else
#define weakify(object) btd_keywordify __block __typeof__(object) block##_##object = object;
#endif
#endif

#ifndef strongify
#if __has_feature(objc_arc)
#define strongify(object) btd_keywordify __typeof__(object) object = weak##_##object;
#else
#define strongify(object) btd_keywordify __typeof__(object) object = block##_##object;
#endif
#endif

#define ALPSwizzle(class, oriMethod, newMethod) {Method originalMethod = class_getInstanceMethod(class, @selector(oriMethod));\
Method swizzledMethod = class_getInstanceMethod(class, @selector(newMethod));\
if (class_addMethod(class, @selector(oriMethod), method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod))) {\
class_replaceMethod(class, @selector(newMethod), method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));\
} else {\
method_exchangeImplementations(originalMethod, swizzledMethod);\
}}

#define ALPSwizzleClass(class, oriMethod, newMethod) {Method originalMethod = class_getClassMethod(class, @selector(oriMethod));\
Method swizzledMethod = class_getClassMethod(class, @selector(newMethod));\
method_exchangeImplementations(originalMethod, swizzledMethod);\
}

#define ALPBase64Decode(str) [[NSString alloc] initWithData:[[NSData alloc] initWithBase64EncodedString:str options:0] encoding:NSUTF8StringEncoding]

#endif /* AWERTLDefinitions_h */
