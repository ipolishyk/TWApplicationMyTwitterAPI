//
//  TweetTableCell.m
//  TWApplicationMyTwitterAPI
//
//  Created by Maksim Polishyk on 07.10.14.
//  Copyright (c) 2014 Maksim Polishyk. All rights reserved.
//

#import "TweetTableCell.h"


@implementation TweetTableCell

@synthesize tweetText;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        
    }
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
    [super setSelected:selected animated:animated];
    
}

@end
