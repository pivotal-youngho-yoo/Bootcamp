//
//  ScheduledGame.h
//  FootballSchedule
//
//  Created by Youngho Yoo on 2014-08-27.
//
//

#import <Foundation/Foundation.h>
#import "Team.h"

@interface ScheduledGame : NSObject

@property Team * homeTeam;
@property Team * awayTeam;
@property NSDate *date;
@property NSString *network;
@property NSString *city;
@property NSString *state;


-(id) initWithHomeTeam:(Team *)home AwayTeam:(Team *)away Date:(NSDate *)date Network:(NSString *)network City:(NSString *)city State:(NSString *)state;

@end
