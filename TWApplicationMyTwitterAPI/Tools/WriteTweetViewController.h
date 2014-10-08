//
//  WeriteTweetViewController.h
//  TWApplicationMyTwitterAPI
//
//  Created by Maksim Polishyk on 08.10.14.
//  Copyright (c) 2014 Maksim Polishyk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TwitterViewController.h"

@interface WriteTweetViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextView *tweetTextField;
- (IBAction)sendTweet:(id)sender;
- (IBAction)cancelTweet:(id)sender;

@property (nonatomic,weak) TwitterViewController *twitterViewController;

@end
