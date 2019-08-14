//
//  AWERTLManager.m
//  AWERTL
//
//  Created by ByteDance on 2018/9/10.
//

#import "AWERTLManager.h"
#import "UIView+AWERTL.h"
#import "NSObject+AWERTLReloadBlock.h"
#import "AWERTLDefinitions.h"

@interface AWERTLManager ()

@property (nonatomic, strong) NSPointerArray *registeredUIElements;

@end

@implementation AWERTLManager

+ (instancetype)sharedInstance
{
    static AWERTLManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[AWERTLManager alloc] init];
        manager.registeredUIElements = [NSPointerArray pointerArrayWithOptions:NSPointerFunctionsWeakMemory];
    });
    return manager;
}

- (void)registerUIElement:(UIView *)element
{
    [self.registeredUIElements addPointer:(__bridge void * _Nullable)(element)];
}

- (void)setEnableRTL:(BOOL)enableRTL
{
    if (enableRTL == _enableRTL) {
        return;
    }
    _enableRTL = enableRTL;
    NSInteger count = self.registeredUIElements.count;
    NSMutableSet<UIView *> *rootViews = [NSMutableSet set];
    for (NSInteger i = 0; i < count; i++) {
        UIView *element = (UIView *)[self.registeredUIElements pointerAtIndex:i];
        [element awertl_performReload];
        if (!element) {
            continue;
        }
        if (element.window && element.window != element) {
            continue;
        }
        
        [rootViews addObject:[self rootViewForView:element]];
    }
    
    [rootViews enumerateObjectsUsingBlock:^(UIView * _Nonnull obj, BOOL * _Nonnull stop) {
        [obj awertl_renewLayerTransformForceRecursively:YES];
    }];
    
    if (@available(iOS 9_0, *)) {
        UISemanticContentAttribute attr = enableRTL ? UISemanticContentAttributeForceRightToLeft : UISemanticContentAttributeForceLeftToRight;
        [UIView appearance].semanticContentAttribute = UISemanticContentAttributeForceLeftToRight;
        [UISearchBar appearance].semanticContentAttribute = UISemanticContentAttributeForceLeftToRight;
        [UILabel appearance].semanticContentAttribute = attr;
        [UITextField appearance].semanticContentAttribute = attr;
        [UITextView appearance].semanticContentAttribute = attr;
        [UIDatePicker appearance].semanticContentAttribute = attr;
        [UIView appearanceWhenContainedIn:[UIDatePicker class], nil].semanticContentAttribute = attr;
    }
}

- (UIView *)rootViewForView:(UIView *)view
{
    if (view.window) {
        return view.window;
    }
    UIView *rootView = view;
    while (rootView.superview) {
        rootView = rootView.superview;
    }
    return rootView;
}

@end
