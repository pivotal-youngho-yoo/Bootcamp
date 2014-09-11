//
//  AllTeamNamesService.m
//  FootballSchedule
//
//  Created by Youngho Yoo on 2014-09-10.
//
//

#import "AllTeamNamesService.h"
#import "AllTeamNamesServiceParser.h"

#define ALL_TEAM_NAMES_REQUEST_STRING @"http://api.sportsdatallc.org/ncaafb-t1/teams/FBS/hierarchy.json?api_key=jmtzp6kchp9n9vka5s7e6hje"

@interface AllTeamNamesService ()

@property (nonatomic, strong) AllTeamNamesServiceParser *parser;

@end

@implementation AllTeamNamesService

- (instancetype)init {
    self = [super init];
    if (self) {
        _parser = [[AllTeamNamesServiceParser alloc] init];
    }
    return self;
}

- (void)requestAllTeamNamesWithSuccessBlock:(void (^)(NSDictionary *))success failureBlock:(void (^)(NSError *))failure {
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLRequest *topTeamRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:ALL_TEAM_NAMES_REQUEST_STRING] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    NSURLSessionDataTask *topTeamsDataTask = [session dataTaskWithRequest:topTeamRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (!error) {
                success([self.parser parseAllTeamNamesResponse:data]);
            } else {
                NSLog(@"fail!");
                failure([[NSError alloc] init]);
            }
        });
    }];
    
    [topTeamsDataTask resume];
}

@end
