//
//  TTConsoleWindow.h
//  Pods-TTConsole_Example
//
//  Created by 打不死的强丿 on 2019/6/7.
//

#import <UIKit/UIKit.h>


@interface TTConsoleWindow : UIWindow

@property (nonatomic,copy) void(^onClick)(void);

@end
