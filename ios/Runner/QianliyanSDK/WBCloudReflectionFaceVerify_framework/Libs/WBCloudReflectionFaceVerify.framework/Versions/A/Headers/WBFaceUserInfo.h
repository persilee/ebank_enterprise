//
//  WBFaceUserInfo.h
//  WBCloudReflectionFaceVerify
//
//  Created by pp on 2017/11/17.
//

#import <Foundation/Foundation.h>

@interface WBFaceUserInfo : NSObject
@property (nonatomic,copy) NSString *name;    // 姓名
@property (nonatomic,copy) NSString *idType;  // 证件类型，暂时仅支持18位身份证， 默认请填写"01"
@property (nonatomic,copy) NSString *idNo;    // 证件号码，身份证请填写18位身份证号

@property (nonatomic,copy, readonly) NSString *encryptedName;  // 姓名
@property (nonatomic,copy, readonly) NSString *encryptedIdNo;  // 加密id
@property (nonatomic,copy, readonly) NSString *encryptedAESKey;// 加密 aes key


- (BOOL)isIDStringValid;

-(BOOL)isValid;
@end
