//
//  ScheduleServiceParser.h
//  FootballSchedule
//
//  Created by Youngho Yoo on 2014-09-10.
//
//

#import <Foundation/Foundation.h>

@interface ScheduleServiceParser : NSObject

- (NSArray *)parseScheduleResponse:(NSData *)response;

@end
