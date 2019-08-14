//
//  CALayer+AWERTL.h
//  AWERTL
//
//  Created by ByteDance on 2018/9/10.
//

#import <QuartzCore/QuartzCore.h>

NS_ASSUME_NONNULL_BEGIN

@interface CALayer (AWERTL)

/**
 * Additional property for CALayer, which will be multiplied to the original transform before set.
 */
@property (nonatomic, assign) CGAffineTransform awertl_basicTransform;

@end

NS_ASSUME_NONNULL_END
