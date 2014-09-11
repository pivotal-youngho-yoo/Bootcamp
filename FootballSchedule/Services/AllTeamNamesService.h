//
//  AllTeamNamesService.h
//  FootballSchedule
//
//  Created by Youngho Yoo on 2014-09-10.
//
//

#import <Foundation/Foundation.h>

@interface AllTeamNamesService : NSObject

- (void)requestAllTeamNamesWithSuccessBlock:(void (^)(NSDictionary *))success failureBlock:(void (^)(NSError *))failure;

@end
