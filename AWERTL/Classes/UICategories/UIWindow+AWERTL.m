//
//  UIWindow+AWERTL.m
//  AWERTL
//
//  Created by ByteDance on 2018/9/10.
//

#import "UIWindow+AWERTL.h"
#import "UIView+AWERTL.h"
#import "AWERTLDefinitions.h"
#import "AWERTLManager.h"

@implementation UIWindow (AWERTL)

+ (void)load
{
    ALPSwizzle(self, initWithFrame:, alp_initWithFrame:);
}

- (instancetype)alp_initWithFrame:(CGRect)frame
{
    [self alp_initWithFrame:frame];
    if (self) {
        [self awertl_renewLayerTransformForceRecursively:NO];
        [[AWERTLManager sharedInstance] registerUIElement:self];
    }
    return self;
}

- (AWERTLViewType)awertl_automaticViewType
{
    if ([self isKindOfClass:NSClassFromString(@"UIRemoteKeyboardWindow")]) {
        return AWERTLViewTypeNormal;
    }
    if ([self isKindOfClass:NSClassFromString(@"UIStatusBarWindow")]) {
        return AWERTLViewTypeNormal;
    }
    if ([self isKindOfClass:NSClassFromString(@"UITextEffectsWindow")]) {
        return AWERTLViewTypeNormal;
    }
    return AWERTLViewTypeFlip;
}

@end
