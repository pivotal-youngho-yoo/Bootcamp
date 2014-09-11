//
//  AllTeamNamesServiceParser.m
//  FootballSchedule
//
//  Created by Youngho Yoo on 2014-09-10.
//
//

#import "AllTeamNamesServiceParser.h"
#import "Team.h"

@implementation AllTeamNamesServiceParser

- (NSDictionary *)parseAllTeamNamesResponse:(NSData *)response {
    NSError *error = nil;
    
    NSDictionary *parsedResponse = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableContainers error:&error];
    NSMutableDictionary *allTeamNames = [[NSMutableDictionary alloc] init];
    
    if(error) {
        NSLog(@"Failed: Getting team names");
    } else {
        NSMutableArray *jsonConferences = [parsedResponse valueForKey:@"conferences"];
        for(NSDictionary *conference in jsonConferences) {
            NSMutableArray *jsonSubdivisions = [conference valueForKey:@"subdivisions"];
            for(NSDictionary *subdivision in jsonSubdivisions)
            {
                //NSLog(@"subdivison");
                NSMutableArray *jsonteams = [subdivision valueForKey:@"teams"];
                for(NSDictionary *teamdict in jsonteams) {
                    NSString *name = [teamdict valueForKey:@"name"];
                    NSString *market = [teamdict valueForKey:@"market"];
                    NSString *teamid = [teamdict valueForKey:@"id"];
                    NSNumber *rank = [teamdict valueForKey:@"rank"];
                    
                    Team *teamInList = [[Team alloc] initWithTeamId:teamid teamName:name teamMarket:market rank:rank];
                    [allTeamNames setObject:teamInList forKey:teamid];
                }
            }
        }
    }
    return allTeamNames;
}

@end
