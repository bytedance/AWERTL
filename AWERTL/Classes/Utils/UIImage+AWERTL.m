//
//  UIImage+AWERTL.m
//  AWERTL
//
//  Created by 熊典 on 2018/12/6.
//

#import "UIImage+AWERTL.h"
#import "AWERTLDefinitions.h"

@implementation UIImage (AWERTL)

+ (void)load
{
    ALPSwizzleClass(self, imageNamed:, awertl_imageNamed:);
    ALPSwizzleClass(self, imageNamed:inBundle:compatibleWithTraitCollection:, awertl_imageNamed:inBundle:compatibleWithTraitCollection:);
}

+ (UIImage *)awertl_imageNamed:(NSString *)name
{
    UIImage *image = [self awertl_imageNamed:name];
    image.awertl_imageName = name;
    return image;
}

+ (UIImage *)awertl_imageNamed:(NSString *)name inBundle:(NSBundle *)bundle compatibleWithTraitCollection:(UITraitCollection *)traitCollection
{
    UIImage *image = [self awertl_imageNamed:name inBundle:bundle compatibleWithTraitCollection:traitCollection];
    image.awertl_imageName = name;
    return image;
}

- (NSString *)awertl_imageName
{
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setAwertl_imageName:(NSString *)awertl_imageName
{
    objc_setAssociatedObject(self, @selector(awertl_imageName), awertl_imageName, OBJC_ASSOCIATION_RETAIN);
}

@end
