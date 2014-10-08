//
//  AppDelegate.m
//  TWApplicationMyTwitterAPI
//
//  Created by Maksim Polishyk on 07.10.14.
//  Copyright (c) 2014 Maksim Polishyk. All rights reserved.
//

#import "AppDelegate.h"
#import "StartViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


@synthesize netStatus;
@synthesize hostReach;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reachabilityChanged:)
                                                 name:kReachabilityChangedNotification
                                               object:nil];
    self.hostReach = [Reachability reachabilityWithHostName:@"www.apple.com"];
    [hostReach startNotifier];
    [self updateInterfaceWithReachability: hostReach];
    
    //netStatus - Хранит состояние сети(есть или нету доступ к Интернету)
    //hostReach - Следит за состоянием сети
    
    StartViewController *startViewController = [[StartViewController alloc] initWithNibName:@"StartViewController" bundle:nil];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.rootViewController =startViewController;

    [self.window makeKeyAndVisible];

    return YES;
}



- (void) updateInterfaceWithReachability: (Reachability*) curReach {
    self.netStatus = [curReach currentReachabilityStatus];
}

- (void) reachabilityChanged: (NSNotification* )note {
    Reachability* curReach = [note object];
    NSParameterAssert([curReach isKindOfClass: [Reachability class]]);
    [self updateInterfaceWithReachability: curReach];
}


- (NSDictionary *)parametersDictionaryFromQueryString:(NSString *)queryString {
    
    NSMutableDictionary *md = [NSMutableDictionary dictionary];
    
    NSArray *queryComponents = [queryString componentsSeparatedByString:@"&"];
    
    for(NSString *s in queryComponents) {
        NSArray *pair = [s componentsSeparatedByString:@"="];
        if([pair count] != 2) continue;
        
        NSString *key = pair[0];
        NSString *value = pair[1];
        
        md[key] = value;
    }
    
    return md;
}



// Вызываем если авторизация прошла успешно
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    
    
    if ([[url scheme] isEqualToString:@"myapp"] == NO) return NO;
    
    NSDictionary *d = [self parametersDictionaryFromQueryString:[url query]];
    
    NSString *token = d[@"oauth_token"];
    NSString *verifier = d[@"oauth_verifier"];
  
    StartViewController *vc = (StartViewController *)[[self window] rootViewController];
    
    //Передаем токен методу setOAuthToken в нашем StartViewController
    [vc setOAuthToken:token oauthVerifier:verifier];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
