//
//  TTConsole.m
//  Pods
//
//  Created by 王家强 on 2019/4/30.
//

#import "TTConsole.h"
#import "TTConsoleController.h"
#import "TTConsoleWindow.h"
#import "TTLogHelper.h"
#import "TTHttpHelper.h"
#import "TTCrashHelper.h"

NSString * const TTEnvironmentKey = @"AppEnvironment";

@interface TTConsole ()

@property (nonatomic,strong) TTConsoleWindow *consoleWindow;
@property (nonatomic,strong) UINavigationController *consoleVC;

@end

@implementation TTConsole

- (TTConsoleWindow *)consoleWindow
{
    if (!_consoleWindow) {
        _consoleWindow = [[TTConsoleWindow alloc] init];
    }
    return _consoleWindow;
}

+ (instancetype)console {
    static TTConsole *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[super allocWithZone:NULL] init];
    });
    return instance;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    return [TTConsole console];
}

- (void)enableDebugMode
{
    [[TTCrashHelper helper] start];
    [[TTLogHelper helper] start];
    [[TTHttpHelper helper] start];
    
    typeof(self) __weak weakSelf = self;
    self.consoleWindow.onClick = ^{
        [weakSelf showConsoleVC];
    };
}

- (void)showConsoleVC
{
    
    if (self.consoleVC.isViewLoaded && self.consoleVC.view.window && self.consoleVC) {
        [self.consoleVC popToRootViewControllerAnimated:NO];
        [self.consoleVC dismissViewControllerAnimated:YES completion:nil];
        self.consoleVC = nil;
    } else {
        self.consoleVC = [[UINavigationController alloc] initWithRootViewController:[[TTConsoleController alloc] init]];
        [self.consoleVC.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:14],NSForegroundColorAttributeName:[UIColor colorWithRed:255/255.0 green:184/255.0 blue:108/255.0 alpha:1]}];
        self.consoleVC.navigationBar.tintColor = [UIColor colorWithRed:255/255.0 green:184/255.0 blue:108/255.0 alpha:1];
        UIViewController* vc = [[[UIApplication sharedApplication].delegate window] rootViewController];
        [vc.presentedViewController?:vc presentViewController:self.consoleVC animated:YES completion:nil];
    }
}

#pragma mark - env
- (TTEnvironmentType)currentEnvironment
{
    return [[NSUserDefaults standardUserDefaults] integerForKey:TTEnvironmentKey];
}

@end
