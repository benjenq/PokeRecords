//
//  PKMRecord.h
//  PokeRecords
//
//  Created by benjenq on 2016/10/27.
//  Copyright 2016 benjenq . All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
@interface PKMRecord : NSObject

@property (nonatomic,retain) NSString *identifier;
@property (nonatomic,retain) NSString *pkID; //Pokemon 編號
@property (nonatomic,retain) NSString *YYYY;
@property (nonatomic,retain) NSString *MM;
@property (nonatomic,retain) NSString *DD;

@property (nonatomic,retain) NSString *HH;
@property (nonatomic,retain) NSString *mi;
@property (nonatomic,retain,readonly,getter=dateTime) NSString *dateTime; //時間字串，不含秒，如 2016-10-01 09:41
@property (nonatomic,retain,readonly,getter=weekDay) NSString *weekDay; //星期[幾]
@property (nonatomic,retain,readonly,getter=weekDayType) NSString *weekDayType; //週末填入 假日，非週末填入平日
@property (nonatomic,retain,readonly,getter=timePeriod) NSString *timePeriod; //時段：
// 00:00~07:59 -> PERIOD_A, 08:00~12:59 -> PERIOD_B, 13:00~19:59 PERIOD_C, 20:00~23:59 PERIOD_D，參考 Localizable.strings 內說明

@property (nonatomic,retain) NSString *placeName; //地點名稱
@property (nonatomic,retain) NSString *note; //地點備註
@property (nonatomic,retain) NSString *remark; //野生/重生/櫻花怪
@property (nonatomic,retain) NSString *iv;

@property (nonatomic) CLLocationCoordinate2D coordinate;


@property (nonatomic,retain) NSString *pkName;
@property (nonatomic,retain) NSString *pkEngName;
@property (nonatomic,retain) NSString *pkIconName;

@property (nonatomic,retain) NSString *intervalString ; //兩次間隔







- (instancetype)initWithIdentifier:(NSString *)inIdentifier;

- (BOOL)writetoDB;

- (BOOL)deleteRec;

@end
