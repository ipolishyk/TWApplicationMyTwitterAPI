//
//  StartViewController.h
//  TWApplicationMyTwitterAPI
//
//  Created by Maksim Polishyk on 07.10.14.
//  Copyright (c) 2014 Maksim Polishyk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StartViewController : UIViewController

- (IBAction)signInActionIOS:(id)sender;
- (IBAction)signInActionWeb:(id)sender;

- (void)setOAuthToken:(NSString *)token oauthVerifier:(NSString *)verfier;

@end
