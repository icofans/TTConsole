#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "TTConsole.h"
#import "TTConsoleController.h"
#import "TTConsoleWindow.h"
#import "TTLogViewController.h"

FOUNDATION_EXPORT double TTConsoleVersionNumber;
FOUNDATION_EXPORT const unsigned char TTConsoleVersionString[];

