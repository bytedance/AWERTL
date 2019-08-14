//
//  UIView+AWERTL.h
//  AWERTL
//
//  Created by ByteDance on 2018/9/10.
//

#import <UIKit/UIKit.h>

/**
 * The view's behavior in RTL environment
 * - AWERTLViewTypeAuto: The view's behavior will be automatically judged according to its class.
 * - AWERTLViewTypeInherit: The view's behavior will depend on its superview.
 * - AWERTLViewTypeNormal: The view itself will always be normal in any conditions.
 * - AWERTLViewTypeFlip: The view itself will always be flipped in any conditions.
 * - AWERTLViewTypeNormalWithAllDescendants: The view and all its descendants will always be normal in any conditions.
 * - AWERTLViewTypeFlipWithAllDescendants: The view and all its descendants will always be flipped in any conditions.
 */
typedef enum : NSUInteger {
    AWERTLViewTypeAuto,
    AWERTLViewTypeInherit,
    AWERTLViewTypeNormal,
    AWERTLViewTypeFlip,
    AWERTLViewTypeNormalWithAllDescendants,
    AWERTLViewTypeFlipWithAllDescendants,
} AWERTLViewType;

NS_ASSUME_NONNULL_BEGIN

@interface UIView (AWERTL)

/**
 * Set the view's behavior via this property
 */
@property (nonatomic, assign) AWERTLViewType awertl_viewType;

/**
 * The view's calculated behavior considering its view type and its view hierarchy
 */
@property (nonatomic, assign, readonly) AWERTLViewType awertl_calculatedViewType;

/**
 * Force renewing the view's RTL behavior w/wo its descendants
 */
- (void)awertl_renewLayerTransformForceRecursively:(BOOL)forceRecursively;

/**
 * [For Overriding] The view's actual behavior when it's set to AWERTLViewTypeAuto
 */
- (AWERTLViewType)awertl_automaticViewType;

@end

NS_ASSUME_NONNULL_END
