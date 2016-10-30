//
//  Base64w3DES.h
//  Base64DES
//
//  Created by benjenq on 2016/10/27.
//  Copyright 2016 benjenq . All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonCryptor.h>
@interface Base64w3DES : NSObject {
    
}

+(NSString *)TripleDES:(NSString *)plainText encryptOrDecrypt:(CCOperation)encryptOrDecrypt key:(NSString *)key;
+(NSData *)TripleDESData:(NSData *)plainData encryptOrDecrypt:(CCOperation)encryptOrDecrypt key:(NSString *)key;

@end


