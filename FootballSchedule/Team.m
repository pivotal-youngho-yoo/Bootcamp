//
//  Team.m
//  FootballSchedule
//
//  Created by DX088-XL on 2014-09-03.
//
//

#import "Team.h"

@implementation Team

- (id) initWithTeamId:(NSString *)teamId teamName:(NSString *)teamName teamMarket:(NSString*)teamMarket rank:(NSNumber *)rank
{
    self = [super init];
    if (self) {
        _teamId = teamId;
        _teamName = teamName;
        _teamMarket = teamMarket;
        _rank = rank;
    }
    return self;
}

- (id) initWithJustId: (NSString *)teamId
{
    self = [super init];
    if (self) {
        _teamId = teamId;
    }
    return self;
}

@end
