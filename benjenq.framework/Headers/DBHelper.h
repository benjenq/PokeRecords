//
//  DBHelper.h
//  PokeRecords
//
//  Created by benjenq on 2016/10/27.
//  Copyright 2016 benjenq . All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
@interface DBHelper : NSObject{
    sqlite3 *_database;
}
@property(nonatomic,readonly) sqlite3 *database;

// 取得資料庫輔助物件的 singleton
+ (DBHelper *) shareInstance;

// 開啓資料庫
- (sqlite3 *) openDatabase;


+ (void)BEGINTRANSACTION;
+ (void)ENDTRANSACTION;

// 關閉資料庫
- (void) closeDatabase;

// 資料總數
+ (NSUInteger) intForSQL:(const char *) sql;

+ (NSString *) stringFromSQL:(const char *) sql;


+ (BOOL) executeSQL:(const char *)sql;

@end
