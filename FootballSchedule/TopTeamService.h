//
//  TopTeamService.h
//  FootballSchedule
//
//  Created by Youngho Yoo on 2014-09-10.
//
//

#import <Foundation/Foundation.h>

@interface TopTeamService : NSObject

- (void)requestTopTeamsWithSuccessBlock:(void (^)(NSDictionary *))success failureBlock:(void (^)(NSError *))failure;

@end
