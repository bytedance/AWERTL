//
//  UIImageView+AWERTL.m
//  AWERTL
//
//  Created by ByteDance on 2018/12/6.
//

#import "UIImageView+AWERTL.h"
#import "UIView+AWERTL.h"
#import "UIImage+AWERTL.h"
#import "AWERTLManager.h"
#import "AWERTLDefinitions.h"

@implementation UIImageView (AWERTL)

+ (void)load
{
    ALPSwizzle(self, setImage:, awertl_setImage:);
}

- (void)awertl_setImage:(UIImage *)image
{
    self.awertl_viewType = [self shouldFlipImage:image] ? AWERTLViewTypeFlip : AWERTLViewTypeAuto;
    [self awertl_setImage:image];
}

- (BOOL)shouldFlipImage:(UIImage *)image
{
    if (image.awertl_imageName && [[AWERTLManager sharedInstance].flipImageNames containsObject:image.awertl_imageName]) {
        return YES;
    }
    BOOL isImageFilpBySystem;
    if (@available(iOS 9.0, *)) {
        isImageFilpBySystem = image.flipsForRightToLeftLayoutDirection;
    } else {
        isImageFilpBySystem = [self.superview isKindOfClass:NSClassFromString(@"_UIModernBarButton")];
    }
    if (isImageFilpBySystem) {
        return YES;
    }
    return NO;
}

@end
