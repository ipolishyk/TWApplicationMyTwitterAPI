//
//  TWEngine.h
//  TWApplicationMyTwitterAPI
//
//  Created by Maksim Polishyk on 08.10.14.
//  Copyright (c) 2014 Maksim Polishyk. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface TWEngine : NSObject

+(void) upadeLastTweetID:(NSDictionary *) tweetDictionary;
+(void) saveLastTweetIDtoDB:(NSString *) lastID;
+(NSString *) getLastTweetID;

@end
