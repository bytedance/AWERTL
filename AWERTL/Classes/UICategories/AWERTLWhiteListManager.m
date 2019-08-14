//
//  AWERTLWhiteListManager.m
//  AWERTL
//
//  Created by ByteDanceon 2018/12/6.
//

#import "AWERTLWhiteListManager.h"
#import "UIView+AWERTL.h"
#import <objc/runtime.h>
#import "AWERTLManager.h"
#import "UIView+AWERTL.h"
#import "NSObject+AWERTLReloadBlock.h"
#import "AWERTLDefinitions.h"

@implementation AWERTLWhiteListManager

+ (void)load
{
    NSArray<NSString *> *noFlipWhiteListClasses = @[@"UILabel", @"UITextView", @"UITextField", @"UIWebView", @"WKWebView", @"UIImageView", @"UISearchBar", @"PUPhotosSectionHeaderContentView", @"UITableViewIndex", @"YYLabel", @"LOTAnimationView", ALPBase64Decode(@"X1VJUmVtb3RlVmlldw==") /* _UIRemoteView */ , ALPBase64Decode(@"VUlBdXRvY29ycmVjdFRleHRWaWV3") /* UIAutocorrectTextView */ ];
    [noFlipWhiteListClasses enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        BOOL shouldFlip = NO;
        BOOL shouldInherit = NO;
        if ([obj hasPrefix:@"!"]) {
            shouldFlip = YES;
            obj = [obj substringFromIndex:1];
        }
        if ([obj hasSuffix:@"!"]) {
            shouldInherit = YES;
            obj = [obj substringToIndex:obj.length - 1];
        }
        Class class = NSClassFromString(obj);
        SEL sel = NSSelectorFromString(@"awertl_automaticViewType");
        if (!class) {
            return;
        }
        IMP implementation = imp_implementationWithBlock(^(NSObject *self) {
            if (shouldInherit) {
                return shouldFlip ? AWERTLViewTypeFlipWithAllDescendants : AWERTLViewTypeNormalWithAllDescendants;
            } else {
                return shouldFlip ? AWERTLViewTypeFlip : AWERTLViewTypeNormal;
            }
        });
        if (!class_addMethod(class, sel, implementation, method_getTypeEncoding(class_getInstanceMethod([UIView class], @selector(awertl_automaticViewType))))) {
            Method method = class_getInstanceMethod(class, sel);
            if (!method) {
                return;
            }
            
            method_setImplementation(method, implementation);
        }
    }];
}

@end
