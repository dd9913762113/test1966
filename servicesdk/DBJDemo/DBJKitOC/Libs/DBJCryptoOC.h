

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonCryptor.h>

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    DBJCryptorNoPadding = 0,    // 无填充
    DBJCryptorPKCS7Padding = 1, // PKCS_7 | 每个字节填充字节序列的长度。 ***此填充模式使用系统方法。***
    DBJCryptorZeroPadding = 2,  // 0x00 填充 | 每个字节填充 0x00
    DBJCryptorANSIX923,         // 最后一个字节填充字节序列的长度，其余字节填充0x00。
    DBJCryptorISO10126          // 最后一个字节填充字节序列的长度，其余字节填充随机数据。
}DBJCryptorPadding;

typedef enum {
    DBJKeySizeAES128          = 16,
    DBJKeySizeAES192          = 24,
    DBJKeySizeAES256          = 32,
}DBJKeySizeAES;

typedef enum {
    DBJModeECB        = 1,
    DBJModeCBC        = 2,
    DBJModeCFB        = 3,
    DBJModeCTR        = 4,
    DBJModeOFB        = 7,
}DBJMode;

@interface DBJCryptoOC : NSObject

+ (NSString *)DBJAESEncrypt:(NSString *)originalStr
                      mode:(DBJMode)mode
                       key:(NSString *)key
                   keySize:(DBJKeySizeAES)keySize
                        iv:(NSString * _Nullable )iv
                   padding:(DBJCryptorPadding)padding;

+ (NSString *)DBJAESDecrypt:(NSString *)originalStr
                      mode:(DBJMode)mode
                       key:(NSString *)key
                   keySize:(DBJKeySizeAES)keySize
                        iv:(NSString * _Nullable )iv
                   padding:(DBJCryptorPadding)padding;

@end

NS_ASSUME_NONNULL_END
