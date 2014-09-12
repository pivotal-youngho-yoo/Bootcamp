#import "ScheduleServiceParser.h"
#import "ScheduledGame.h"

using namespace Cedar::Matchers;
using namespace Cedar::Doubles;

SPEC_BEGIN(ScheduleServiceParserSpec)

describe(@"ScheduleServiceParser", ^{
    __block ScheduleServiceParser *subject;

    beforeEach(^{
        subject = [[ScheduleServiceParser alloc] init];
    });
    
    describe(@"parsing top team response", ^{
        __block NSArray *results;
        
        beforeEach(^{
            NSString *filePath = [[NSBundle mainBundle] pathForResource:@"ScheduleJSON" ofType:@"json"];
            NSLog(@"FILE PATH: %@",filePath);
            NSData *testResponse = [NSData dataWithContentsOfFile:filePath];
            results = [subject parseScheduleResponse:testResponse];
        });
        
        it(@"should create a array with the correct model objects from the response", ^{
            [results count] should equal(2);
            ScheduledGame *game1 = [results objectAtIndex:0];
            game1.homeTeam.teamId should equal(@"EW");
            game1.awayTeam.teamId should equal(@"SHS");
            ScheduledGame *game2 = [results objectAtIndex:1];
            game2.homeTeam.teamId should equal(@"GST");
            game2.awayTeam.teamId should equal(@"ACU");

        });
    });
});

SPEC_END
