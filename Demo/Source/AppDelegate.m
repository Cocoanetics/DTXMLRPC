//
//  AppDelegate.m
//  WordpressDemo
//
//  Created by Oliver Drobnik on 22.03.13.
//  Copyright (c) 2013 Drobnik KG. All rights reserved.
//

#import "AppDelegate.h"

#import "ViewController.h"

#import "DTXMLRPC.h"
#import "DTWordpress.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    DTWordpress *service = [[DTWordpress alloc] initWithEndpointURL:[NSURL URLWithString:@"http://www.domain.com/xmlrpc.php"]];
    service.userName = @"bla";
    service.password = @"pass";
    
    [service getCategoriesWithCompletion:^(NSArray *categories, NSError *error) {
        if (!categories)
        {
            NSLog(@"error: %@", error);
        }
        else
        {
            NSLog(@"%@", categories);
        }
    }];
    
    /*
    
     [service getUsersBlogsWithCompletion:^(NSArray *blogs, NSError *error) {
     if (!blogs)
     {
     NSLog(@"error: %@", error);
     }
     else
     {
     NSLog(@"%@", blogs);
     }
     }];
    */
     
    /*
    [service getPostWithIdentifier:1 completion:^(NSDictionary *content, NSError *error) {
        if (!content)
        {
            NSLog(@"error: %@", error);
        }
        else
        {
            NSLog(@"%@", content);
        }
     }];
    */
    
    /*
    NSDictionary *content = @{@"title":@"Test Post", @"description":@"Description", @"post_type":@"post1"};
    
    [service newPostWithContent:content shouldPublish:NO completion:^(NSInteger postID, NSError *error) {
        if (error)
        {
            NSLog(@"error: %@", error);
        }
        else
        {
            NSLog(@"new post id %d", postID);
        }
    }];
    */
    
    /*
     NSArray *parameters = @[@(1), @"drops", @"Magic1234!"];
     
     DTXMLRPCRequest *request = [[DTXMLRPCRequest alloc] initWithMethodName:@"metaWeblog.getRecentPosts" parameters:parameters];
     
     [service sendRequest:request completion:^(DTXMLRPCResponse *response) {
     
     if (response.error)
     {
     NSLog(@"%@", response.error);
     }
     
     NSLog(@"done");
     }];
     
     */
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.viewController = [[ViewController alloc] initWithNibName:@"ViewController" bundle:nil];
    self.window.rootViewController = self.viewController;
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
