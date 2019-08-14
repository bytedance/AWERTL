//
//  UIWebView+AWERTL.m
//  AWERTL
//
//  Created by ByteDance on 2018/10/9.
//

#import "AWERTLRemoteViewControllerAdaptor.h"
#import "UIView+AWERTL.h"
#import "AWERTLDefinitions.h"
#import "AWERTLManager.h"

@implementation SFSafariViewController (AWERTL)

+ (void)load
{
    ALPSwizzle(self, viewDidLoad, alpweb_viewDidLoad);
}

- (void)alpweb_viewDidLoad
{
    [self alpweb_viewDidLoad];
    self.view.awertl_viewType = AWERTLViewTypeNormalWithAllDescendants;
}

@end

@implementation SKCloudServiceSetupViewController (AWERTL)

+ (void)load
{
    ALPSwizzle(self, viewDidLoad, alpsk_viewDidLoad);
}

- (void)alpsk_viewDidLoad
{
    [self alpsk_viewDidLoad];
    self.view.awertl_viewType = AWERTLViewTypeNormalWithAllDescendants;
}

@end

@implementation UIActivityViewController (AWERTL)

+ (void)load
{
    ALPSwizzle(self, viewDidLoad, alp_act_viewDidLoad);
}

- (void)alp_act_viewDidLoad
{
    [self alp_act_viewDidLoad];
    self.view.awertl_viewType = AWERTLViewTypeNormalWithAllDescendants;
}

@end

@implementation UIImagePickerController (AWERTL)

+ (void)load
{
    ALPSwizzle(self, loadView, alp_act_loadView);
}

- (void)alp_act_loadView
{
    [self alp_act_loadView];
    self.view.awertl_viewType = AWERTLViewTypeNormalWithAllDescendants;
}

@end

@implementation SKStoreProductViewController (AWERTL)

+ (void)load
{
    ALPSwizzle(self, loadView, alp_act_loadView);
}

- (void)alp_act_loadView
{
    [self alp_act_loadView];
    self.view.awertl_viewType = AWERTLViewTypeNormalWithAllDescendants;
}

@end
