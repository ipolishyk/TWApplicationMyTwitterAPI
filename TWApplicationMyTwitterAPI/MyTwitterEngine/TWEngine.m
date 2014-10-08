//
//  TWEngine.m
//  TWApplicationMyTwitterAPI
//
//  Created by Maksim Polishyk on 08.10.14.
//  Copyright (c) 2014 Maksim Polishyk. All rights reserved.
//

#import "TWEngine.h"
#import "SQLiteAccess.h"


@implementation TWEngine

+(void) upadeLastTweetID:(NSDictionary *) tweetDictionary{
    
    
    NSString *lastID =[tweetDictionary valueForKey:@"id_str"];
    [self saveLastTweetIDtoDB:lastID];
}

+(void) saveLastTweetIDtoDB:(NSString *) lastID{
    
    NSString *sql=@"update twitter set lastID =";
    sql=[sql stringByAppendingString:lastID];
    [SQLiteAccess updateWithSQL:sql];
}


+(NSString *) getLastTweetID{
    
    NSString* sql=@"select * from twitter";
    NSDictionary *DBDictionary=[SQLiteAccess selectOneRowWithSQL:sql];
    
    NSString *lasttweetID=[DBDictionary objectForKey:@"lastID"];
    
    
    return lasttweetID;
}



@end
