//
//  TwitterViewController.m
//  TWApplicationMyTwitterAPI
//
//  Created by Maksim Polishyk on 07.10.14.
//  Copyright (c) 2014 Maksim Polishyk. All rights reserved.
//

#import "TwitterViewController.h"
#import "TweetTableCell.h"
#import "TWEngine.h"
#import "WriteTweetViewController.h"

@interface TwitterViewController (){
    
    UIButton *updateTweetButton;
    UIButton *careateTweetButton;
    
    UIBarButtonItem *updateTweetItem;
    UIBarButtonItem *createTweetItem;
    
    NSMutableArray *tweetTableArray;
    
    UIPopoverController *tweetPopover;
    WriteTweetViewController *writeTweetViewController;
}

@end

@implementation TwitterViewController

@synthesize twitter,tweetTableView;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    tweetTableArray=[[NSMutableArray alloc] init];
    
    updateTweetButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [updateTweetButton setFrame:CGRectMake(0.0f, 0.0f, 30.0f, 30.0f)];
    [updateTweetButton addTarget:self action:@selector(updateTweet) forControlEvents:UIControlEventTouchUpInside];
    [updateTweetButton setImage:[UIImage imageNamed:@"updateTwittButton.png"] forState:UIControlStateNormal];
    updateTweetItem=[[UIBarButtonItem alloc] initWithCustomView:updateTweetButton];
    
    careateTweetButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [careateTweetButton setFrame:CGRectMake(0.0f, 0.0f, 103.0f, 30.0f)];
    [careateTweetButton addTarget:self action:@selector(createTweet:) forControlEvents:UIControlEventTouchUpInside];
    [careateTweetButton setImage:[UIImage imageNamed:@"newTweetButton.png"] forState:UIControlStateNormal];
    createTweetItem=[[UIBarButtonItem alloc] initWithCustomView:careateTweetButton];
    
    self.navigationItem.rightBarButtonItems =
    [NSArray arrayWithObjects:updateTweetItem, nil];
    
    self.navigationItem.leftBarButtonItems =
    [NSArray arrayWithObjects:createTweetItem, nil];

    
    //Загружаем последние 10 твитов
    [self firstTweetLoad];
}

-(void)updateTweet{
    //Обновляемм ленту - грузим еще последние десять твитов начиная с ID последнего твита который был сохранен в БД с предыдущей загрузки

    
    if([[TWEngine getLastTweetID] doubleValue]==0){
        
        [self firstTweetLoad];
    }else{
    
        [twitter getHomeTimelineSinceID:[TWEngine getLastTweetID]
                              count:5
                       successBlock:^(NSArray *tweetArray) {
        tweetTableArray = [[tweetArray arrayByAddingObjectsFromArray:tweetTableArray] mutableCopy];
                           if([tweetTableArray count]==0){
                               [self firstTweetLoad];
                           }else{
        
        [TWEngine upadeLastTweetID:[tweetTableArray objectAtIndex:0]];
        [tweetTableView reloadData];
                           }
        
    } errorBlock:^(NSError *error) {
        NSLog(@"%@",error);
        [self showErrorConnection:error.localizedDescription];
    }];
    }
}

-(void)updateOldTweet{
    //Обновляемм ленту - грузим последние старые десять твитов начиная с ID последнего твита в таблице
    
    NSString *lastID;
    if([tweetTableArray count]>0){
    lastID =[[tweetTableArray objectAtIndex:[tweetTableArray count]-1] valueForKey:@"id_str"];
        
       
        
    [tweetTableArray removeObjectAtIndex:[tweetTableArray count]-1];
        

    }else{
        
       lastID=nil;
    }
    [twitter getHomeTimelineSinceIDmaxID:nil count:10 maxID:lastID successBlock:^(NSArray *tweetArray) {
        
        //Добавляем в таблицу старые 10 твитов если скролл достиг конца таблицы
        //(ловим этим методом -(void)scrollViewDidScroll:(UIScrollView *)scrollView)
        
        [tweetTableArray addObjectsFromArray:tweetArray];
        [tweetTableView reloadData];
        if([tweetTableArray count]>4){
        [tweetTableView setBounces:YES];
        }
        
    } errorBlock:^(NSError *error) {
        NSLog(@"%@",error);
        
        [self showErrorConnection:error.localizedDescription];
    }];
   
}

-(void)firstTweetLoad{
    
    [twitter getHomeTimelineSinceID:nil
                               count:5
                        successBlock:^(NSArray *tweetArray) {
        
        //Заполняем масив таблицы, обновляем таблицу, сохраняем ID последнего
        //твита(нужно чтобы при обновлении заново не грузить все твиты, а начиная с последнего загруженого)
        
        [tweetTableArray addObjectsFromArray:tweetArray];
        [tweetTableView reloadData];
        if([tweetTableArray count]>0){
        [TWEngine upadeLastTweetID:[tweetTableArray objectAtIndex:0]];
        }
        
    } errorBlock:^(NSError *error) {
        NSLog(@"%@",error);
        [self showErrorConnection:error.localizedDescription];
    }];
}

-(void) sendTweet:(NSString *) tweetText{
    //Отправляем твит, обновляем ленту
    
    [twitter postStatusUpdate:tweetText
            inReplyToStatusID:nil
                     latitude:nil
                    longitude:nil
                      placeID:nil
           displayCoordinates:nil
                     trimUser:nil
                 successBlock:^(NSDictionary *status) {
                     
                     [self updateTweet];
                 } errorBlock:^(NSError *error) {
                     [self showErrorConnection:error.localizedDescription];
                 }];
}

-(void) createTweet:(UIButton *) sender{
    
    //Создаем форму для ввода текста и отправки твита
    
     writeTweetViewController =[[WriteTweetViewController alloc] initWithNibName:@"WriteTweetViewController" bundle:nil];
    [writeTweetViewController setTwitterViewController:self];
    
    if([[[UIDevice currentDevice] systemVersion] integerValue]<8){
        
        if(tweetPopover==nil){
            tweetPopover = [[UIPopoverController alloc] initWithContentViewController:writeTweetViewController];
            [tweetPopover setPopoverContentSize:CGSizeMake(310, 145)];
            
            
        }
        if (![tweetPopover isPopoverVisible]) {
            [tweetPopover presentPopoverFromBarButtonItem:createTweetItem permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
            
            
        }else{
            
            [tweetPopover dismissPopoverAnimated:YES];
        }
        
    }else{
        
        writeTweetViewController.modalPresentationStyle=UIModalPresentationPopover;
        writeTweetViewController.preferredContentSize = CGSizeMake(310,145);
        
        if (writeTweetViewController.popoverPresentationController)
        {
            writeTweetViewController.popoverPresentationController.delegate=self;
            writeTweetViewController.popoverPresentationController.sourceView=sender;
            writeTweetViewController.popoverPresentationController.sourceRect=sender.bounds;
            writeTweetViewController.popoverPresentationController.permittedArrowDirections = UIPopoverArrowDirectionUp;
            
            [self presentViewController:writeTweetViewController animated:NO completion:nil];
            
            
        }
    
}
}

-(UIModalPresentationStyle)adaptivePresentationStyleForPresentationController:(UIPresentationController *)controller{
    
    return UIModalPresentationNone;
}

-(void) closeWriteTweetFrom{
    [tweetPopover dismissPopoverAnimated:YES];
     [writeTweetViewController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [tweetTableArray count];
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CustomCellIdentifier = @"TweetTableCell";
    TweetTableCell *cell = (TweetTableCell *)[tableView dequeueReusableCellWithIdentifier: CustomCellIdentifier];
    
    
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"TweetTableCell"
                                                owner:self options:nil];
        
        for (id oneObject in nib) if ([oneObject isKindOfClass:[TweetTableCell class]])
            cell = (TweetTableCell*)oneObject;
    }
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSDictionary *tweetDictionary = [tweetTableArray objectAtIndex:indexPath.row];
    cell.tweetText.text=[tweetDictionary valueForKey:@"text"];
    
    
    return cell;
}


-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat height = scrollView.frame.size.height;
    CGFloat contentYoffset = scrollView.contentOffset.y;
    CGFloat distanceFromBottom = scrollView.contentSize.height - contentYoffset;
    
    if(distanceFromBottom < height&& tweetTableView.bounces)
    {
       
        [tweetTableView setBounces:NO];
        [self updateOldTweet];
        
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) showErrorConnection:(NSString *) error{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error, try again later."
                                                    message:error
                                                   delegate:self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
