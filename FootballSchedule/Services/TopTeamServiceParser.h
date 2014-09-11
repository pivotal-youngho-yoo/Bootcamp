//
//  TopTeamServiceParser.h
//  FootballSchedule
//
//  Created by Youngho Yoo on 2014-09-10.
//
//

#import <Foundation/Foundation.h>

@interface TopTeamServiceParser : NSObject

- (NSDictionary *)parseTopTeamsResponse:(NSData *)response;

@end
