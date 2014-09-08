//
//  Team.h
//  FootballSchedule
//
//  Created by DX088-XL on 2014-09-03.
//
//

#import <Foundation/Foundation.h>

@interface Team : NSObject

@property NSString *teamId;
@property NSString *teamName;
@property NSString *teamMarket;
@property NSNumber *rank;

- (id) initWithTeamId:(NSString *)teamId teamName:(NSString *)teamName teamMarket:(NSString*)teamMarket rank:(NSNumber *)rank;
- (id) initWithJustId: (NSString *)teamId;

@end
