//
//  AWERTLManager.h
//  AWERTL
//
//  Created by ByteDance on 2018/9/10.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AWERTLManager : NSObject

/**
 * Turn on / off AWERTL via this property.
 */
@property (nonatomic, assign) BOOL enableRTL;

/**
 * Set a list of image names that should be flipped when enableRTL is true (e.g. directional images)
 */
@property (nonatomic, strong) NSArray<NSString *> *flipImageNames;

+ (instancetype)sharedInstance;

- (void)registerUIElement:(UIView *)element;

@end

NS_ASSUME_NONNULL_END
