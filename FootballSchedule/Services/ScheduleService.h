//
//  ScheduleService.h
//  FootballSchedule
//
//  Created by Youngho Yoo on 2014-09-10.
//
//

#import <Foundation/Foundation.h>

@interface ScheduleService : NSObject

- (void)requestScheduleWithSuccessBlock:(void (^)(NSArray *))success failureBlock:(void (^)(NSError *))failure;

@end
