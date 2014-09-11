//
//  TopTeamServiceParser.m
//  FootballSchedule
//
//  Created by Youngho Yoo on 2014-09-10.
//
//

#import "TopTeamServiceParser.h"
#import "Team.h"

@implementation TopTeamServiceParser

- (NSDictionary *)parseTopTeamsResponse:(NSData *)response {
    NSError *error = nil;
    NSDictionary *parsedResponse = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableContainers error:&error];
    NSMutableDictionary *teamsDictionary;
    
    if (!error) {
        teamsDictionary = [NSMutableDictionary dictionary];
        NSMutableArray *jsonTeams = [parsedResponse valueForKey:@"rankings"];
        for(NSDictionary *teamdict in jsonTeams) {
            NSString *name = [teamdict valueForKey:@"name"];
            NSString *market = [teamdict valueForKey:@"market"];
            NSString *teamid = [teamdict valueForKey:@"id"];
            NSNumber *rank = [teamdict valueForKey:@"rank"];
            
            Team *teamInList = [[Team alloc] initWithTeamId:teamid teamName:name teamMarket:market rank:rank];
            
            [teamsDictionary setObject:teamInList forKey:teamid];
        }
    }
    
    return teamsDictionary;
}

@end
