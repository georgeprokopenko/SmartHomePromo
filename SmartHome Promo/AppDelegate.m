//
//  AppDelegate.m
//  SmartHome Promo
//
//  Created by George Prokopenko on 02/07/2018.
//  Copyright © 2018 George Prokopenko. All rights reserved.
//

#import "AppDelegate.h"
#import "Mapper.h"
#import "MainViewController.h"
#import "AccountManager.h"

@import UserNotifications;
//@import FirebaseCore;
//@import FirebaseInstanceID;
//@import FirebaseMessaging;

@interface AppDelegate () <UNUserNotificationCenterDelegate> //FIRMessagingDelegate

@property (strong, nonatomic) MainViewController* mainVC;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [self initMainPage];
    [self checkAuth];
    [self setupPushNotificationsInApp:application];
    return YES;
}

- (void) initMainPage {
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [self.window makeKeyAndVisible];
    self.mainVC = [[MainViewController alloc] init];
    self.window.rootViewController = self.mainVC;
}

- (void) checkAuth {
    if (![AccountManager shared].userAccount.authToken) [self.mainVC authNeeded];
    else [self.mainVC authDone];
}



#pragma mark Push Notifs

- (void) setupPushNotificationsInApp:(UIApplication *)application {
    /*
    FIROptions* options = [FIROptions defaultOptions];
    options.APIKey = @"";
    options.clientID = @"";
    options.projectID = @"";
    options.googleAppID = @"";
    [FIRApp configureWithOptions:options];
    [FIRMessaging messaging].delegate = self;
    UIUserNotificationType allNotificationTypes =
    (UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge);
    UIUserNotificationSettings *settings =
    [UIUserNotificationSettings settingsForTypes:allNotificationTypes categories:nil];
    [application registerUserNotificationSettings:settings];
    [application registerForRemoteNotifications];
    if ([UIApplication instancesRespondToSelector:@selector(registerUserNotificationSettings:)]){
        [application registerUserNotificationSettings: [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert|UIUserNotificationTypeBadge|UIUserNotificationTypeSound categories:nil]];
    }
     */
}

/*
- (void)messaging:(FIRMessaging *)messaging didReceiveRegistrationToken:(NSString *)fcmToken {
    NSLog(@"FCM registration token: %@", fcmToken);
}
- (void) application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    FIRMessaging.messaging.APNSToken = deviceToken;
    [self subscribeToPushTopics];
}

- (void) subscribeToPushTopics {
    if ([AccountManager shared].userAccount.accountID) {
        NSString* topic = [NSString stringWithFormat:@"account_%@", [AccountManager shared].userAccount.accountID];
        [[FIRMessaging messaging] subscribeToTopic:topic];
    }
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    NSLog(@"Message: %@", userInfo);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    NSLog(@"Message: %@", userInfo);
    NSData *notificationData = [userInfo[@"payload"] dataUsingEncoding:NSUTF8StringEncoding];
    
    NSError *error;
    NSDictionary *notifDict = [NSJSONSerialization JSONObjectWithData:notificationData options:0 error:&error];
    NSLog(@"notification DIct: %@", notifDict);
    
    completionHandler(UIBackgroundFetchResultNewData);
}


*/



#pragma mark Appplication Lifecycle

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    NSLog(@"%@", NSStringFromSelector(_cmd));
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end

