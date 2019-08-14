//
//  CALayer+AWERTL.m
//  AWERTL
//
//  Created by ByteDance on 2018/9/10.
//

#import "CALayer+AWERTL.h"
#import "AWERTLDefinitions.h"
#import "AWERTLManager.h"

static BOOL shouldEnableRTL = NO;

@implementation CALayer (AWERTL)

+ (void)load
{
    ALPSwizzle(self, setAffineTransform:, awertl_setAffineTransform:);
    ALPSwizzle(self, affineTransform, awertl_affineTransform);
    ALPSwizzle(self, addAnimation:forKey:, awertl_addAnimation:forKey:);
    ALPSwizzle(self, renderInContext:, awertl_renderInContext:);
}

- (void)setAwertl_basicTransform:(CGAffineTransform)awertl_basicTransform
{
    if (!objc_getAssociatedObject(self, @selector(awertl_basicTransform)) && CGAffineTransformIsIdentity(awertl_basicTransform)) {
        return;
    }
    objc_setAssociatedObject(self, @selector(awertl_basicTransform), [NSValue valueWithCGAffineTransform:awertl_basicTransform], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    self.affineTransform = self.affineTransform;
}

- (CGAffineTransform)awertl_basicTransform
{
    NSValue *value = objc_getAssociatedObject(self, _cmd);
    return value ? [value CGAffineTransformValue] : CGAffineTransformIdentity;
}

- (void)setAwertl_isRenderStartLayer:(BOOL)awertl_isRenderStartLayer
{
    objc_setAssociatedObject(self, @selector(awertl_isRenderStartLayer), @(awertl_isRenderStartLayer), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)awertl_isRenderStartLayer
{
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

- (void)awertl_setAffineTransform:(CGAffineTransform)m
{
    if (!shouldEnableRTL && [AWERTLManager sharedInstance].enableRTL) {
        shouldEnableRTL = YES;
    }
    if (shouldEnableRTL) {
        objc_setAssociatedObject(self, @selector(awertl_affineTransform), [NSValue valueWithCGAffineTransform:m], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        [self awertl_setAffineTransform:CGAffineTransformConcat(self.awertl_basicTransform, m)];
    } else {
        [self awertl_setAffineTransform:m];
    }
}

- (CGAffineTransform)awertl_affineTransform
{
    if (!shouldEnableRTL && [AWERTLManager sharedInstance].enableRTL) {
        shouldEnableRTL = YES;
    }
    if (shouldEnableRTL) {
        NSValue *value = objc_getAssociatedObject(self, @selector(awertl_affineTransform));
        return value ? [value CGAffineTransformValue] : [self awertl_affineTransform];
    } else {
        return [self awertl_affineTransform];
    }
}

- (void)awertl_addAnimation:(CAAnimation *)anim forKey:(NSString *)key
{
    if ([anim isKindOfClass:[CABasicAnimation class]]) {
        CABasicAnimation *basicAnim = (CABasicAnimation *)anim;
        if ([basicAnim.keyPath hasPrefix:@"transform.scale"] && self.awertl_basicTransform.a == -1) {
            basicAnim.fromValue = @([basicAnim.fromValue floatValue] * -1);
            basicAnim.toValue = @([basicAnim.toValue floatValue] * -1);
        }
    }
    [self awertl_addAnimation:anim forKey:key];
}

- (void)awertl_renderInContext:(CGContextRef)ctx
{
    if (!shouldEnableRTL && [AWERTLManager sharedInstance].enableRTL) {
        shouldEnableRTL = YES;
    }
    if (shouldEnableRTL) {
        BOOL isRenderStartLayer = YES;
        CGAffineTransform allSuperLayerTransform = self.awertl_basicTransform;
        CALayer *layer = self;
        while (layer.superlayer) {
            layer = layer.superlayer;
            if ([layer awertl_isRenderStartLayer]) {
                isRenderStartLayer = NO;
                break;
            }
            allSuperLayerTransform = CGAffineTransformConcat(layer.awertl_basicTransform, allSuperLayerTransform);
        }
        if (isRenderStartLayer) {
            [self setAwertl_isRenderStartLayer:YES];
            if (allSuperLayerTransform.a == -1) {
                CGContextSaveGState(ctx);
                CGContextConcatCTM(ctx, CGAffineTransformMakeScale(-1, 1));
                CGContextTranslateCTM(ctx, -self.bounds.size.width, 0);
            }
        }
        [self awertl_renderInContext:ctx];
        if (isRenderStartLayer) {
            [self setAwertl_isRenderStartLayer:NO];
            if (allSuperLayerTransform.a == -1) {
                CGContextRestoreGState(ctx);
            }
        }
    } else {
        [self awertl_renderInContext:ctx];
    }
}

@end
