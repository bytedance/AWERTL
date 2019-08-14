//
//  TTTAttributedLabel+LocalizationsPlus.m
//  AWELocalizations-iOS
//
//  Created by ByteDance on 2018/2/22.
//

#import "TTTAttributedLabel+LocalizationsPlus.h"
#import <objc/runtime.h>
#import "AWERTLManager.h"
#import "RSSwizzle.h"

@implementation AWERTLTTTAttributedLabel

+ (void)load
{
    Class class = NSClassFromString(@"TTTAttributedLabel");
    if (!class) {
        return;
    }
    
    RSSwizzleInstanceMethod(class, NSSelectorFromString(@"textAlignment"), RSSWReturnType(NSTextAlignment), RSSWArguments(), RSSWReplacement({
        NSTextAlignment alignment = RSSWCallOriginal();
        if (alignment == NSTextAlignmentNatural && [AWERTLManager sharedInstance].enableRTL) {
            return NSTextAlignmentRight;
        }
        return alignment;
    }), 0, NULL);
}

@end
