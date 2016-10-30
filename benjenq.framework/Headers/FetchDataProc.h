//
//  FetchDataProc.h
//  PokeRecords
//
//  Created by benjenq on 2016/10/27.
//  Copyright 2016 benjenq . All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FetchDataProc : NSObject

+ (void) fetchPKMRecordArray:(NSMutableArray *)oriArray keyword:(NSString *)inkeyWord completion:(void(^)(BOOL success,NSMutableArray *resultArray))completion;

+ (void) fetchPlaceNamesArray:(NSMutableArray *)oriArray completion:(void(^)(BOOL success,NSMutableArray *resultArray))completion;

+ (void)toPasteboard:(NSMutableArray *)oriArray keyword:(NSString *)keyWords completion:(void(^)(BOOL success,NSMutableArray *resultArray))completion;

@end
