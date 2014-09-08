//
//  ScheduledGame.m
//  FootballSchedule
//
//  Created by Youngho Yoo on 2014-08-27.
//
//

#import "ScheduledGame.h"

@implementation ScheduledGame

-(id) initWithHomeTeam:(Team *)home AwayTeam:(Team *)away Date:(NSDate *)date Network:(NSString *)network City:(NSString *)city State:(NSString *)state
{
    self = [super init];
    
    if(self) {
        _homeTeam = home;
        _awayTeam = away;
        _date = date;
        _network = network;
        _city = city;
        _state = state;
    }
    
    return self;
}

@end
