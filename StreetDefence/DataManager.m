//
//  DataManager.m
//  StreetDefence
//
//  Created by Freddie on 30/05/2013.
//  Copyright (c) 2013 Freddie. All rights reserved.
//

#import "DataManager.h"

#import "Kid.h"

@implementation DataManager

+ (void) RemoveDeadKids:(NSMutableArray*)_deadKids {
    
    NSMutableArray *characters = [[NSMutableArray alloc] init];
    NSString *applicationDocumentsDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *filesPath = [applicationDocumentsDir stringByAppendingPathComponent:@"characters.plist"];
    NSMutableDictionary *charactersDict = [NSMutableDictionary dictionaryWithContentsOfFile:filesPath];
    characters = [charactersDict objectForKey:@"Characters"];
    
    for ( Kid *k in _deadKids ) {
    
        NSDictionary *removeChar;
    
        for ( NSDictionary *kidDic in characters ) {
            if ( [k.name isEqualToString:[kidDic objectForKey:@"name"]] ) {
                removeChar = kidDic;
            }
        }
        if ( removeChar ) { [characters removeObject:removeChar]; }
        
    }
    
    [charactersDict setObject:characters forKey:@"Characters"];
    [charactersDict writeToFile:filesPath atomically:YES];
    
}

@end
