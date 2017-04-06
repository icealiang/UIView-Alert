//
//  UIView+XLAlert.m
//  UIAlertDemo
//
//  Created by 许谢良 on 2017/4/6.
//  Copyright © 2017年 许谢良. All rights reserved.
//

#import "UIView+XLAlert.h"
#import <objc/runtime.h>
#import "MBProgressHUD.h"
#import "UIView+Toast.h"

#define iOS8   [[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0
static NSString *XL_ALERT_TITLE = @"提示";
static NSString *XL_ALERT_CONFIRM = @"确定";
static NSString *XL_ALERT_CANCLE = @"取消";


@implementation UIView (XLAlert)

- (clickAlertHandler)clickConfirmHandle
{
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setClickConfirmHandle:(clickAlertHandler)block {
    objc_setAssociatedObject(self, @selector(clickConfirmHandle), block, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (clickAlertHandler)clickCancleHandle
{
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setClickCancleHandle:(clickAlertHandler)block {
    objc_setAssociatedObject(self, @selector(clickCancleHandle), block, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

#pragma mark - Alert

- (void)xl_showAlertWithMessage:(NSString *)message confirmHandler:(clickAlertHandler)handler {
    [self showAlertWithTitle:XL_ALERT_TITLE message:message confirmHandler:handler];
}

- (void)showAlertWithTitle:(NSString *)title message:(NSString *)message confirmHandler:(clickAlertHandler)handler {
    [self showAlertWithTitle:title message:message confirmTitle:XL_ALERT_CONFIRM confirmHandler:handler];
}


- (void)xl_showAlertWithMessage:(NSString *)message confirmTitle:(NSString *)confirmTitle confirmHandler:(clickAlertHandler)handler {
    [self showAlertWithTitle:XL_ALERT_TITLE message:message confirmTitle:confirmTitle confirmHandler:handler];
}



- (void)showAlertWithTitle:(NSString *)title message:(NSString *)message confirmTitle:(NSString *)confirmTitle confirmHandler:(clickAlertHandler)handler {
    if (iOS8) {
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:XL_ALERT_CANCLE style:UIAlertActionStyleCancel handler:nil];
        UIAlertAction *confirmlAction = [UIAlertAction actionWithTitle:confirmTitle style:UIAlertActionStyleDefault handler:handler];
        [self showAlertWithTitle:title message:message cancelAction:cancelAction confirmAction:confirmlAction];
    } else {
        self.clickConfirmHandle = handler;
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:XL_ALERT_CANCLE otherButtonTitles:confirmTitle, nil];
        [alert show];
    }
    
}


- (void)xl_showAlertWithTitle:(NSString *)title message:(NSString *)message confirmTitle:(NSString *)confirmTitle cancleTitle:(NSString *)cancleTitle confirmHandle:(clickAlertHandler)confirm cancleHandle:(clickAlertHandler)cancle {
    if (iOS8) {
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancleTitle style:UIAlertActionStyleCancel handler:cancle];
        UIAlertAction *confirmlAction = [UIAlertAction actionWithTitle:confirmTitle style:UIAlertActionStyleDefault handler:confirm];
        [self showAlertWithTitle:title message:message cancelAction:cancelAction confirmAction:confirmlAction];
    } else {
        self.clickConfirmHandle = confirm;
        self.clickCancleHandle = cancle;
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:cancleTitle otherButtonTitles:confirmTitle, nil];
        [alert show];
    }
}

- (void)showAlertWithTitle:(NSString *)title message:(NSString *)message cancelAction:(UIAlertAction *)cancelAction confirmAction:(UIAlertAction *)confirmAction {
    
    if (cancelAction == nil && confirmAction == nil) return;
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    cancelAction != nil ? [alertController addAction:cancelAction] : nil;
    confirmAction != nil ? [alertController addAction:confirmAction] : nil;
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alertController animated:YES completion:nil];
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex==1) {
        if (self.clickConfirmHandle) {
            self.clickConfirmHandle(nil);
        }
    } else {
        if (self.clickCancleHandle) {
            self.clickCancleHandle(nil);
        }
    }
}


#pragma mark - HUD

static void *HUDKEY = &HUDKEY;
- (MBProgressHUD *)HUD {
    return objc_getAssociatedObject(self, HUDKEY);
}

- (void)setHUD:(MBProgressHUD *)HUD {
    objc_setAssociatedObject(self, HUDKEY, HUD, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)showHUD {
    [self showHUDWithText:@""];
}

- (void)showHUDWithText:(NSString *)text {
    MBProgressHUD *HUD = [self HUD];
    if (!HUD) {
        HUD = [[MBProgressHUD alloc] initWithView:[UIApplication sharedApplication].keyWindow];
        HUD.dimBackground = NO;
        HUD.removeFromSuperViewOnHide = YES;
        [self setHUD:HUD];
    }
    [[UIApplication sharedApplication].keyWindow addSubview:HUD];
    HUD.labelText = text;
    [HUD show:YES];
}

- (void)hideHUD {
    [[self HUD] hide:YES];
}


#pragma mark - Toast

static void *ToastKEY = &ToastKEY;

- (UIView *)toastView {
    return objc_getAssociatedObject(self, ToastKEY);
}

- (void)setToastView:(UIView *)toastView {
    objc_setAssociatedObject(self, ToastKEY, toastView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)showToastWithText:(NSString *)toastString {
    [self showToastWithText:toastString positon:CSToastPositionBottom];
}

- (void)showToastWithText:(NSString *)toastString positon:(id)positon {
    
    if (toastString.length > 0) {
        
        if (![self toastView]) {
            [CSToastManager setQueueEnabled:NO];
            // xl-9.2.0自定义UI
            [CSToastManager sharedStyle].backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
            [CSToastManager sharedStyle].verticalPadding = 10;
            [CSToastManager sharedStyle].horizontalPadding = 10;
            [CSToastManager sharedStyle].titleFont = [UIFont systemFontOfSize:16.0];
            [CSToastManager sharedStyle].shadowOpacity = 0.8;
            [CSToastManager sharedStyle].shadowRadius = 6.0;
            [CSToastManager sharedStyle].shadowOffset = CGSizeMake(4, 4);
            [CSToastManager sharedStyle].displayShadow = YES;
            [CSToastManager sharedStyle].maxWidthPercentage = 0.8;
            [CSToastManager sharedStyle].maxHeightPercentage = 0.8;
            [CSToastManager sharedStyle].cornerRadius = 5.0;
            [CSToastManager sharedStyle].titleNumberOfLines = 0;
            [CSToastManager sharedStyle].messageNumberOfLines = 0;
            [CSToastManager sharedStyle].fadeDuration = 0.2;
        }
        
        UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
        UIView *toastView = [keyWindow toastViewForMessage:toastString title:nil image:nil style:nil];
        [UIView animateWithDuration:0.3 animations:^{
            [self toastView].alpha = 0 ;
        } completion:^(BOOL finished) {
            [[self toastView] removeFromSuperview];
            [self setToastView:toastView];
        }];
        [keyWindow showToast:toastView duration:1.5 position:positon completion:nil];
    }
}

- (void)showToastWithText:(NSString *)toastString afterDelay:(NSTimeInterval)timeInterval {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(timeInterval * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self showToastWithText:toastString];
    });
}


@end

@implementation UIViewController (XLAlert)

- (void)showHUD {
    [self.view showHUD];
}

- (void)showHUDWithText:(NSString *)text {
    [self.view showHUDWithText:text];
}

- (void)hideHUD {
    [self.view hideHUD];
}

- (void)showToastWithText:(NSString *)toastString {
    [self.view showToastWithText:toastString];
}

- (void)showToastWithText:(NSString *)toastString positon:(id)positon {
    [self.view showToastWithText:toastString positon:positon];
}

- (void)showToastWithText:(NSString *)toastString afterDelay:(NSTimeInterval)timeInterval {
    [self.view showToastWithText:toastString afterDelay:timeInterval];
}

- (void)showAlertWithTitle:(NSString *)title message:(NSString *)message confirmHandler:(void(^)(UIAlertAction *confirmAction))handler {
    [self.view showAlertWithTitle:title message:message confirmHandler:handler];
}

- (void)showAlertWithTitle:(NSString *)title message:(NSString *)message confirmTitle:(NSString *)confirmTitle confirmHandler:(void(^)(UIAlertAction *confirmAction))handler {
    [self.view showAlertWithTitle:title message:message confirmTitle:confirmTitle confirmHandler:handler];
}

- (void)showAlertWithTitle:(NSString *)title message:(NSString *)message cancelAction:(UIAlertAction *)cancelAction confirmAction:(UIAlertAction *)confirmAction {
    [self.view showAlertWithTitle:title message:message cancelAction:cancelAction confirmAction:confirmAction];
}

@end

