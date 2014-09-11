//
//  ScheduleServiceParser.m
//  FootballSchedule
//
//  Created by Youngho Yoo on 2014-09-10.
//
//

#import "ScheduleServiceParser.h"
#import "Team.h"
#import "ScheduledGame.h"

@implementation ScheduleServiceParser

- (NSArray *)parseScheduleResponse:(NSData *)response {
    NSError *error = nil;
    NSDictionary *parsedResponse = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableContainers error:&error];
    NSMutableArray *displayedGames = [[NSMutableArray alloc] init];
    
    if(error) {
        NSLog(@"Failed getting weekly schedule");
    } else {
        NSMutableArray *jsonGames = [parsedResponse valueForKey:@"games"];
        for(NSDictionary *gamedict in jsonGames) {
            NSString *home = [gamedict valueForKey:@"home"];
            NSString *away = [gamedict valueForKey:@"away"];
            NSString *dateString = [gamedict valueForKey:@"scheduled"];
            
            NSDictionary *venue = [gamedict valueForKey:@"venue"];
            NSString *city = [venue valueForKey:@"city"];
            NSString *state = [venue valueForKey:@"state"];
            
            NSDictionary *broadcast = [gamedict valueForKey:@"broadcast"];
            NSString *network = [broadcast valueForKey:@"network"];
            
            NSDate *date = [NSDate date];
            NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
            [dateFormat setDateFormat:@"yyyy-MM-dd'T'hh:mm:ss+hh:mm"];
            date = [dateFormat dateFromString:dateString];
            
            Team *homeTeam = [[Team alloc] initWithJustId:home];
            Team *awayTeam = [[Team alloc] initWithJustId:away];
            
            ScheduledGame *game = [[ScheduledGame alloc]initWithHomeTeam:homeTeam AwayTeam:awayTeam Date:date Network:network City:city State:state];
            [displayedGames addObject:game];
        }
    }
    return displayedGames;
}

@end
