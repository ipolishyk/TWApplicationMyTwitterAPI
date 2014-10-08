//
//  StartViewController.m
//  TWApplicationMyTwitterAPI
//
//  Created by Maksim Polishyk on 07.10.14.
//  Copyright (c) 2014 Maksim Polishyk. All rights reserved.
//

#import "StartViewController.h"
#import "AppDelegate.h"
#import "TwitterWebAuthViewController.h"
#import "TwitterViewController.h"

@interface StartViewController (){
    
    STTwitterAPI *twitter;
}
@end

@implementation StartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


//Авторизация через IOS

- (IBAction)signInActionIOS:(id)sender {
    
    if([self checkInternetAccess]){
        
        twitter = [STTwitterAPI twitterAPIOSWithFirstAccount];
        
        [twitter verifyCredentialsWithSuccessBlock:^(NSString *username) {
         
        //Переходим к просмотру твитов
        [self viewTwitterListScreen];
            
        } errorBlock:^(NSError *error) {
            NSLog(@"%@",error);
            [self showError:error.localizedDescription];
        }];
        
    }
    
}
//Авторизация через API Twitter
- (IBAction)signInActionWeb:(id)sender {
    
    if([self checkInternetAccess]){
        
        
        //Заносим наши ключи полученные на сайте Твитера
        twitter = [STTwitterAPI twitterAPIWithOAuthConsumerKey:@"LM0FCCRvmhQgB3vEJgfWfilvF"
                                                     consumerSecret:@"BVaIfPOhH9klC1uSPlMl2rFXzD6103vlggB5PipFyAxXGXNQZN"];
        //Вызываем вэб форму для ввода логина и пароля
        [twitter postTokenRequest:^(NSURL *url, NSString *oauthToken) {
            
                TwitterWebAuthViewController *twitterWebController = [[TwitterWebAuthViewController alloc] initWithNibName:@"TwitterWebAuthViewController" bundle:nil];
           
                [self presentViewController:twitterWebController animated:YES completion:^{
                    NSURLRequest *request = [NSURLRequest requestWithURL:url];
                    [twitterWebController.webView loadRequest:request];
                    
                    /*
                    если все ок в синглтоне  AppDelegate вызывается метод (BOOL)application:(UIApplication *)application openURL:(NSURL *)url
                      sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
                    */
                }];
            
            
        } authenticateInsteadOfAuthorize:NO
                        forceLogin:@(YES)
                        screenName:nil
                     oauthCallback:@"myapp://twitter_access_tokens/"
                        errorBlock:^(NSError *error) {
                          
                            NSLog(@"%@",error);
                            
                        }];
    }
}


-(BOOL) checkInternetAccess{
    
    //Вызываем синглтон AppDelegate и проверяем сатус подключения к Интернету
    AppDelegate * appDelegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    
    if (appDelegate.netStatus == NotReachable) {
        
        [self showError:@"Check your Internet connection and try again."];
        return NO;
        
    } else{
        
        return YES;
        
    }
    
}

-(void) showError:(NSString *) error{
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                    message:error
                                                   delegate:self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
}


- (void)setOAuthToken:(NSString *)token oauthVerifier:(NSString *)verifier {
    
    [self dismissViewControllerAnimated:YES completion:^{
        
        //С этого момента можно работать с Твитером
        //Переходим к просмотру твитов, вызываем метод viewTwitterListScreen(который вызывает TwitterViewController)
        [self viewTwitterListScreen];
        
    }];
    
    [twitter postAccessTokenRequestWithPIN:verifier successBlock:^(NSString *oauthToken, NSString *oauthTokenSecret, NSString *userID, NSString *screenName) {
       
        
    } errorBlock:^(NSError *error) {
        
    }];
}

-(void) viewTwitterListScreen{
    
    TwitterViewController *viewController = [[TwitterViewController alloc] initWithNibName:@"TwitterViewController" bundle:nil];
    [viewController setTwitter:twitter];
    
    UINavigationController *start=[[UINavigationController alloc] initWithRootViewController:viewController];
    
    [self presentModalViewController:start animated:YES];
}


@end
