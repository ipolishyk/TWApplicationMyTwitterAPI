//
//  WeriteTweetViewController.m
//  TWApplicationMyTwitterAPI
//
//  Created by Maksim Polishyk on 08.10.14.
//  Copyright (c) 2014 Maksim Polishyk. All rights reserved.
//

#import "WriteTweetViewController.h"
#import <QuartzCore/QuartzCore.h>


@interface WriteTweetViewController ()

@end

@implementation WriteTweetViewController

@synthesize tweetTextField,twitterViewController;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];

    [tweetTextField.layer setBorderWidth:0.5];
    tweetTextField.layer.cornerRadius = 5;
    tweetTextField.clipsToBounds = YES;
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

- (IBAction)sendTweet:(id)sender {
    
    [twitterViewController sendTweet:tweetTextField.text];
    [twitterViewController closeWriteTweetFrom];
    tweetTextField.text=@"";
}

- (IBAction)cancelTweet:(id)sender {
    
       [twitterViewController closeWriteTweetFrom];
        tweetTextField.text=@"";
}
@end
