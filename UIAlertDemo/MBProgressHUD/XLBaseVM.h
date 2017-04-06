//
//  XLBaseVM.h
//  zzss
//
//  Created by 许谢良 on 2017/4/6.
//  Copyright © 2017年 龙 程. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XLBaseVM : NSObject

typedef void (^xl_successCompletionHandler)(id result);
typedef void (^xl_failureCompletionHandler)(NSString *fault, NSError *error);
typedef void (^xl_NetworkCompletionHandler)(id result,NSError *error);


@end
