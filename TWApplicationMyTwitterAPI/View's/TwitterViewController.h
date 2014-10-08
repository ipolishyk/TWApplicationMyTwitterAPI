//
//  TwitterViewController.h
//  TWApplicationMyTwitterAPI
//
//  Created by Maksim Polishyk on 07.10.14.
//  Copyright (c) 2014 Maksim Polishyk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "STTwitter.h"

@interface TwitterViewController : UIViewController<UIPopoverPresentationControllerDelegate>

@property (assign, nonatomic) STTwitterAPI *twitter;

@property (nonatomic, weak) IBOutlet UITableView *tweetTableView;

-(void) sendTweet:(NSString *) tweetText;
-(void) closeWriteTweetFrom;

@end
