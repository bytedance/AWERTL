//
//  UILabel+AWERTL.m
//  AWERTL
//
//  Created by ByteDance on 2018/12/6.
//

#import "UILabel+AWERTL.h"
#import "NSObject+AWERTLReloadBlock.h"
#import "AWERTLDefinitions.h"
#import "AWERTLManager.h"

@implementation UILabel (AWERTL)

+ (void)load
{
    ALPSwizzle(self, setTextAlignment:, awertl_setTextAlignment:);
    ALPSwizzle(self, setAttributedText:, awertl_setAttributedText:);
    ALPSwizzle(self, initWithFrame:, awertl_initWithFrame:);
    ALPSwizzle(self, initWithCoder:, awertl_initWithCoder:);
}

- (instancetype)awertl_initWithFrame:(CGRect)frame
{
    [self awertl_initWithFrame:frame];
    if (self) {
        self.textAlignment = NSTextAlignmentLeft;
    }
    return self;
}

- (instancetype)awertl_initWithCoder:(NSCoder *)aDecoder
{
    [self awertl_initWithCoder:aDecoder];
    if (self) {
        self.textAlignment = NSTextAlignmentLeft;
    }
    return self;
}

- (void)awertl_setTextAlignment:(NSTextAlignment)textAlignment
{
    @weakify(self);
    [self awertl_addReloadBlockForKey:@"alignment" andExecuteIt:^{
        @strongify(self);
        if ([AWERTLManager sharedInstance].enableRTL && [self shouldUseFlippedTextAlignment]) {
            if (textAlignment == NSTextAlignmentCenter) {
                [self awertl_setTextAlignment:textAlignment];
            } else if (textAlignment == NSTextAlignmentRight) {
                [self awertl_setTextAlignment:NSTextAlignmentLeft];
            } else {
                [self awertl_setTextAlignment:NSTextAlignmentRight];
            }
        } else {
            [self awertl_setTextAlignment:textAlignment];
        }
    }];
}

- (void)awertl_setAttributedText:(NSAttributedString *)attributedText
{
    [self awertl_setAttributedText:attributedText];
    if (self.textAlignment == NSTextAlignmentNatural) {
        self.textAlignment = NSTextAlignmentLeft;
    }
}

- (BOOL)shouldUseFlippedTextAlignment
{
    static dispatch_once_t onceToken;
    static NSArray<NSString *> *whiteListClasses;
    static NSArray<NSString *> *superviewWhiteListClasses;
    dispatch_once(&onceToken, ^{
        // UITextFieldLabel
        whiteListClasses = @[ALPBase64Decode(@"VUlUZXh0RmllbGRMYWJlbA==")];
        // UIDatePickerContentView
        superviewWhiteListClasses = @[ALPBase64Decode(@"VUlEYXRlUGlja2VyQ29udGVudFZpZXc=")];
    });
    for (NSString *className in whiteListClasses) {
        if ([self isKindOfClass:NSClassFromString(className)]) {
            return NO;
        }
    }
    for (NSString *className in superviewWhiteListClasses) {
        if ([self.superview isKindOfClass:NSClassFromString(className)]) {
            return NO;
        }
    }
    return YES;
}

@end
