//
//  AWERTLYYTextAdaption.m
//  Pods
//
//  Created by ByteDance on 2018/12/9.
//

#import "YYLabel+AWERTL.h"
#import "AWERTLDefinitions.h"
#import "AWERTLManager.h"
#import "NSObject+AWERTLReloadBlock.h"
#import "RSSwizzle.h"

@implementation AWERTLYYTextAdaption

+ (void)load
{
    Class class = NSClassFromString(@"YYLabel");
    if (!class) {
        return;
    }
    RSSwizzleInstanceMethod(class, NSSelectorFromString(@"setTextAlignment:"), RSSWReturnType(void), RSSWArguments(NSTextAlignment textAlignment), RSSWReplacement({
        [self awertl_addReloadBlockForKey:@"alignment" andExecuteIt:^{
            if ([AWERTLManager sharedInstance].enableRTL) {
                if (textAlignment == NSTextAlignmentCenter) {
                    RSSWCallOriginal(textAlignment);
                } else if (textAlignment == NSTextAlignmentRight) {
                    RSSWCallOriginal(NSTextAlignmentLeft);
                } else {
                    RSSWCallOriginal(NSTextAlignmentRight);
                }
            } else {
                RSSWCallOriginal(textAlignment);
            }
        }];
    }), 0, NULL);
    
    RSSwizzleInstanceMethod(class, NSSelectorFromString(@"initWithFrame:"), RSSWReturnType(id), RSSWArguments(CGRect frame), RSSWReplacement({
        RSSWCallOriginal(frame);
        [(id)self setTextAlignment:NSTextAlignmentLeft];
        return self;
    }), 0, NULL);
    
    RSSwizzleInstanceMethod(class, NSSelectorFromString(@"sizeThatFits:"), RSSWReturnType(CGSize), RSSWArguments(CGSize size), RSSWReplacement({
        if ([AWERTLManager sharedInstance].enableRTL) {
            [(id)self setTextAlignment:[(id)self textAlignment]];
            CGSize finalSize = RSSWCallOriginal(size);
            [(id)self setTextAlignment:[(id)self textAlignment]];
            return finalSize;
        } else {
            return RSSWCallOriginal(size);
        }
    }), 0, NULL);
    
    RSSwizzleInstanceMethod(class, NSSelectorFromString(@"setTextLayout:"), RSSWReturnType(void), RSSWArguments(id textLayout), RSSWReplacement({
        RSSWCallOriginal(textLayout);
        if ([(id)self textAlignment] == NSTextAlignmentNatural) {
            [(id)self setTextAlignment:NSTextAlignmentLeft];
        } else {
            [(id)self setTextAlignment:[(id)self textAlignment]];
        }
    }), 0, NULL);
    
    RSSwizzleInstanceMethod(class, NSSelectorFromString(@"setAttributedText:"), RSSWReturnType(void), RSSWArguments(NSAttributedString *attributedString), RSSWReplacement({
        RSSWCallOriginal(attributedString);
        if ([(id)self textAlignment] == NSTextAlignmentNatural) {
            [(id)self setTextAlignment:NSTextAlignmentLeft];
        }
    }), 0, NULL);
}

@end
