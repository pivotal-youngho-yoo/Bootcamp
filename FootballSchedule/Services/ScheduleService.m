//
//  ScheduleService.m
//  FootballSchedule
//
//  Created by Youngho Yoo on 2014-09-10.
//
//

#import "ScheduleService.h"
#import "ScheduleServiceParser.h"

#define SCHEDULE_REQUEST_STRING @"http://api.sportsdatallc.org/ncaafb-t1/2014/REG/2/schedule.json?api_key=jmtzp6kchp9n9vka5s7e6hje"

@interface ScheduleService ()

@property (nonatomic, strong) ScheduleServiceParser *parser;

@end

@implementation ScheduleService

- (instancetype)init {
    self = [super init];
    if (self) {
        _parser = [[ScheduleServiceParser alloc] init];
    }
    return self;
}

- (void)requestScheduleWithSuccessBlock:(void (^)(NSArray *))success failureBlock:(void (^)(NSError *))failure {
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLRequest *topTeamRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:SCHEDULE_REQUEST_STRING] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    NSURLSessionDataTask *topTeamsDataTask = [session dataTaskWithRequest:topTeamRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (!error) {
                success([self.parser parseScheduleResponse:data]);
            } else {
                NSLog(@"fail!");
                failure([[NSError alloc] init]);
            }
        });
    }];
    
    [topTeamsDataTask resume];
}

@end
