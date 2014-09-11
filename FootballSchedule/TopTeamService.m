//
//  TopTeamService.m
//  FootballSchedule
//
//  Created by Youngho Yoo on 2014-09-10.
//
//

#import "TopTeamService.h"
#import "TopTeamServiceParser.h"

#define TOP_TEAM_REQUEST_STRING @"http://api.sportsdatallc.org/ncaafb-t1/polls/AP25/2013/2/rankings.json?api_key=jmtzp6kchp9n9vka5s7e6hje"

@interface TopTeamService ()

@property (nonatomic, strong) TopTeamServiceParser *parser;

@end

@implementation TopTeamService

- (instancetype)init {
    self = [super init];
    if (self) {
        _parser = [[TopTeamServiceParser alloc] init];
    }
    return self;
}

- (void)requestTopTeamsWithSuccessBlock:(void (^)(NSDictionary *))success failureBlock:(void (^)(NSError *))failure {
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLRequest *topTeamRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:TOP_TEAM_REQUEST_STRING] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    NSURLSessionDataTask *topTeamsDataTask = [session dataTaskWithRequest:topTeamRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (!error) {
                success([self.parser parseTopTeamsResponse:data]);
            } else {
                NSLog(@"fail!");
                failure([[NSError alloc] init]);
            }
        });
    }];
    
    [topTeamsDataTask resume];
}

@end
