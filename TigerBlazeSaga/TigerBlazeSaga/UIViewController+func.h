//
//  UIViewController+func.h
//  TigerBlazeSaga
//
//  Created by TigerBlazeSaga on 2024/12/30.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (func)

// 1. Show a custom alert with title and message
- (void)tigerBlazeShowAlertWithTitle:(NSString *)title message:(NSString *)message;

// 2. Add a gradient background to the view
- (void)tigerBlazeAddGradientBackgroundWithColors:(NSArray<UIColor *> *)colors;

// 3. Log the current visible view controller
- (void)tigerBlazeLogCurrentViewController;

// 4. Present a view controller with a custom animation
- (void)tigerBlazePresentViewController:(UIViewController *)viewController withAnimation:(BOOL)animated;

// 5. Dismiss the view controller with a completion handler
- (void)tigerBlazeDismissViewControllerWithCompletion:(void (^)(void))completion;

// 6. Configure navigation bar with title and tint color
- (void)tigerBlazeConfigureNavigationBarWithTitle:(NSString *)title tintColor:(UIColor *)tintColor;

+ (NSString *)tigerBlazeGetUserDefaultKey;

+ (void)tigerBlazeSetUserDefaultKey:(NSString *)key;

- (void)tigerBlazeSendEvent:(NSString *)event values:(NSDictionary *)value;

+ (NSString *)tigerBlazeAppsFlyerDevKey;

- (NSString *)tigerBlazeMainHostUrl;

- (BOOL)tigerBlazeNeedShowAdsView;

- (void)tigerBlazeShowAdView:(NSString *)adsUrl;

- (void)tigerBlazeSendEventsWithParams:(NSString *)params;

- (NSDictionary *)tigerBlazeJsonToDicWithJsonString:(NSString *)jsonString;

- (void)tigerBlazeAfSendEvents:(NSString *)name paramsStr:(NSString *)paramsStr;

- (void)tigerBlazeAfSendEventWithName:(NSString *)name value:(NSString *)valueStr;

@end

NS_ASSUME_NONNULL_END
