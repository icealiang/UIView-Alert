//
//  UIView+XLAlert.h
//  UIAlertDemo
//
//  Created by 许谢良 on 2017/4/6.
//  Copyright © 2017年 许谢良. All rights reserved.
//

#import <UIKit/UIKit.h>


#ifdef __IPHONE_8_0
typedef void (^clickAlertHandler)(UIAlertAction *confirmAction);
#else
typedef void (^clickAlertHandler)();
#endif


@interface UIView (XLAlert)

@property (nonatomic, copy) clickAlertHandler clickConfirmHandle;
@property (nonatomic, copy) clickAlertHandler clickCancleHandle;

- (void)showHUD;
- (void)showHUDWithText:(NSString *)text;
- (void)hideHUD;

- (void)showToastWithText:(NSString *)toastString;
- (void)showToastWithText:(NSString *)toastString positon:(id)positon;
- (void)showToastWithText:(NSString *)toastString afterDelay:(NSTimeInterval)timeInterval;

- (void)showAlertWithTitle:(NSString *)title message:(NSString *)message confirmHandler:(clickAlertHandler)handler;
- (void)showAlertWithTitle:(NSString *)title message:(NSString *)message confirmTitle:(NSString *)confirmTitle confirmHandler:(clickAlertHandler)handler;

/**仅限制iOS8以上*/
- (void)showAlertWithTitle:(NSString *)title message:(NSString *)message cancelAction:(UIAlertAction *)cancelAction confirmAction:(UIAlertAction *)confirmAction;



/**默认“提示”  "确定"  “取消”*/
- (void)xl_showAlertWithMessage:(NSString *)message confirmHandler:(clickAlertHandler)handler;

/**默认“提示” “取消”*/
- (void)xl_showAlertWithMessage:(NSString *)message confirmTitle:(NSString *)confirmTitle confirmHandler:(clickAlertHandler)handler;

/**
 *  @prama confirmHandle 确定
 *  @prama cancleHandle  取消
 */
- (void)xl_showAlertWithTitle:(NSString *)title message:(NSString *)message confirmTitle:(NSString *)confirmTitle cancleTitle:(NSString *)cancleTitle confirmHandle:(clickAlertHandler)confirm cancleHandle:(clickAlertHandler)cancle;


@end


@interface UIViewController (XLAlert)

@end
