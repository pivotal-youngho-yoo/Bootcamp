//
//  AllTeamNamesServiceParser.h
//  FootballSchedule
//
//  Created by Youngho Yoo on 2014-09-10.
//
//

#import <Foundation/Foundation.h>

@interface AllTeamNamesServiceParser : NSObject

- (NSDictionary *)parseAllTeamNamesResponse:(NSData *)response;

@end
