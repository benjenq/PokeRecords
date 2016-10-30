//
//  appHelper.m
//  PokeRecords
//
//  Created by benjenq on 2016/10/27.
//  Copyright 2016 benjenq . All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Reachability.h" //需手動加入 SystemConfiguration.framewrok
#import <UIKit/UIKit.h>

@interface appHelper : NSObject

+ (BOOL)fileisExist:(NSString *)filePath;
+ (BOOL)copyfile:(NSString *)source toPath:(NSString *)destination;

+ (void)createDirectory:(NSString *)path;
+ (void)removeDirectory:(NSString *)path;

#pragma mark - 數字文字轉換
+ (NSString *)numberToString:(NSNumber *)val;
+ (NSNumber *)stringToNumber:(NSString *)valStr;

#pragma mark - 日期文字轉換
+ (NSString *)dateToString:(NSDate *)inDate;
+ (NSDate *)stringToDate:(NSString *)dtStr;
+ (NSString *)dateToWeekDay:(NSDate *)inDate;
+ (NSString *)intervalStringFromStartDate:(NSDate *)startDate toDate:(NSDate *)toDate;

//空字串處理
+ (NSString *)nullString:(id)inStr;
+ (NSInteger)nullValue:(id)inVal;
+ (BOOL)nullBOOL:(id)inBool;
+ (char *)nullChar:(char *)inChar;

+ (NSDictionary *)jsonDataToDictionary:(NSData *)jsonData;
+ (NSArray *)jsonDataToArray:(NSData *)jsonData;

+ (NSString *)newUUID;

@end

@interface UIApplication (beExtensions)
+ (NSString *)GetBundlePath;
+ (NSString *)GetDocumentPath;
+ (NSString *)GetCachePath;
+ (NSString *)GettmpPath;

@end

@interface UIDevice (beExtensions)

typedef NS_ENUM(NSUInteger,DeviceType)
{
    DeviceTypeIsUnknow = 0,
    DeviceTypeIsiPhone35 = 11,
    DeviceTypeIsiPhone35R = 12,
    DeviceTypeIsiPhone4in = 13,
    DeviceTypeIsiPhone47in = 14,
    DeviceTypeIsiPhone55in = 15,
    DeviceTypeIsiPad = 21,
    DeviceTypeIsiPadR = 22,
    DeviceTypeIsiPad12R = 23
};

+ (BOOL)isAboveiOS6;

+ (BOOL)isAboveiOS7;

+ (BOOL)isAboveiOS8;

+ (BOOL)isAboveiOS9;

+ (BOOL)isAboveiOS10;

+ (BOOL)deviceIsiPad;

+ (DeviceType)currentDeviceType;

+ (NetworkStatus)netWorStatus;

+(NSString *)UDID;

@end

@interface NSString (Base64TriDES)

- (NSString *)EncryptString;

- (NSString *)DecryptString;

@end

@interface NSData (Base64TriDES)

- (NSData *)EncryptData;

- (NSData *)DecryptData;

@end

@interface UIColor (extension)

+ (UIColor *)iOS7tintColor;

+ (UIColor *)lifeViewBorderColor;

+ (UIColor *)darkRedColor;
+ (UIColor *)darkGreenColor;
+ (UIColor *)darkBlueColor;

+ (UIColor *)cellLightColor:(CGFloat)alpha;
+ (UIColor *)cellDarkColor:(CGFloat)alpha;

@end

@interface UIImage (extension)

+ (UIImage *)imageFromColor:(UIColor *)color ;

@end;

