//
//  UserDefaultsManager.m
//  InputSourceMonitor
//
//  Created by Nicolas Santangelo on 8/10/14.
//  Copyright (c) 2014 Nicolas Santangelo. All rights reserved.
//

#import "UserDefaultsManager.h"

#define kDefaultInputSource @"_InputSourceMonitor_defaultLayout"
#define kisOn @"_InputSourceMonitor_isOn"

@implementation UserDefaultsManager

+ (void)registerDefaults {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults registerDefaults:@{ kDefaultInputSource: @{@"language": @"com.apple.keylayout.USInternational-PC"} }];
    
    [[[AppFinder alloc] init] forEachInstalledApp:^(NSDictionary *app) {
        if ([app[@"name"] isEqualToString:@"Sublime Text"] || [app[@"name"] isEqualToString:@"Xcode"]) {
            [defaults setObject:@{@"name":app[@"name"], @"language": @"com.apple.keylayout.US", @"path":app[@"path"]} forKey:app[@"name"]];
        }
    }];
    
    [defaults setObject:@1 forKey:kisOn];
}

+ (NSDictionary *)objectForKey:(NSString *)key {
    return [[NSUserDefaults standardUserDefaults] objectForKey:[self exists:key] ? key : kDefaultInputSource];
}

+ (void)removeObjectForKey:(NSString *)key {
    if ([self exists:key]) {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:key];
    }
}

+ (BOOL)exists:(NSString *)key {
    return [[NSUserDefaults standardUserDefaults] objectForKey:key] != nil;
}

+ (NSArray *)allValues {
    NSDictionary *currentDefaults = [[NSUserDefaults standardUserDefaults] persistentDomainForName:(NSString *)[[NSBundle mainBundle] bundleIdentifier]];
    NSMutableDictionary *appsToReturn = [[NSMutableDictionary alloc] initWithDictionary:currentDefaults];
    [appsToReturn removeObjectsForKeys:@[kDefaultInputSource, kisOn, @"NSNavLastRootDirectory"]];
    return [appsToReturn allValues];
}

+ (void)toggleIsOn {
    NSNumber *newIsOnValue = [self isOn] ? @0 : @1;
    [[NSUserDefaults standardUserDefaults] setObject:newIsOnValue forKey:kisOn];
}

+ (BOOL)isOn {
    return [[[NSUserDefaults standardUserDefaults] objectForKey:kisOn] boolValue];
}

@end
