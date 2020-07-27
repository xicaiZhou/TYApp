//
//  UIButton+ZXCTool.m
//  ZLHJ
//
//  Created by 周希财 on 2018/3/28.
//  Copyright © 2018年 VIC. All rights reserved.
//

#import "UIButton+ZXCTool.h"

#define ZXC_FontNameNormal @""//@"PingFangSC-Light"

@implementation UIButton (ZXCTool)
- (void)ZXC_CountdownWithInterval:(NSInteger)interval title:(NSString *)text{
    //改变按钮状态
    self.enabled = NO;
    __block NSInteger time = interval;
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    
    dispatch_source_set_event_handler(_timer, ^{
        
        if(time <= 0){ //倒计时结束，关闭
            
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                
                //设置按钮的样式
                [self setTitle:text forState:UIControlStateNormal];
                [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//                [self setBackgroundColor:systemColor];

                //按钮可以编辑
                self.enabled = YES;
            });
        }else{
            int seconds = time % 60;
            dispatch_async(dispatch_get_main_queue(), ^{
                
                //设置按钮显示读秒效果
                [self setTitle:[NSString stringWithFormat:@"%@(%.2d)", text,seconds == 0 ? 60 : seconds] forState:UIControlStateNormal];
//                [self setBackgroundColor:ZLHJ_SYSTEM_GRAY_COLOR];
//                [self setTitleColor:ZLHJ_SYSTEM_COLOR forState:UIControlStateNormal];
                self.enabled = NO;
            });
            time--;
        }
    });
    dispatch_resume(_timer);
}

- (UIButton *_Nonnull(^_Nonnull)(NSString * _Nonnull title))ZXC_setButtonTitle{
    return ^(NSString *title) {
        [self setTitle:title forState:UIControlStateNormal];
        return self;
    };
}

- (UIButton *_Nonnull(^_Nonnull)(NSString *_Nonnull title))ZXC_setButtonTitleSelected{
    return ^(NSString *title) {
        [self setTitle:title forState:UIControlStateSelected];
        return self;
    };
}

- (UIButton *_Nonnull(^_Nonnull)(UIImage * _Nonnull image))ZXC_setButtonImageNormal{
    return ^(UIImage *image){
        [self setImage:image forState:UIControlStateNormal];
        return self;
    };
}

- (UIButton *_Nonnull(^_Nonnull)(UIImage * _Nonnull image, UIControlState state))ZXC_setButtonImageControlState{
    return ^(UIImage *image, UIControlState state){
        [self setImage:image forState:state];
        return self;
    };
}
- (UIButton *_Nonnull(^_Nonnull)(CGFloat fontSize))ZXC_setButtonTitleFontSize{
    return ^(CGFloat fontSize) {
        self.titleLabel.font = [UIFont systemFontOfSize:fontSize];
        return self;
    };
}

- (UIButton *_Nonnull(^_Nonnull)(NSString * _Nullable fontName, CGFloat fontSize))ZXC_setButtonTitleFont{
    return ^(NSString *fontName, CGFloat fontSize) {
        if (fontName == nil) {
            self.titleLabel.font = [UIFont systemFontOfSize:fontSize];
        }
        else {
            self.titleLabel.font = [UIFont fontWithName:fontName size:fontSize];
        }
        return self;
    };
}

- (UIButton *_Nonnull(^_Nonnull)(UIColor * _Nonnull color))ZXC_setTitleColorNormal{
    return ^(UIColor *color) {
        [self setTitleColor:color forState:UIControlStateNormal];
        return self;
    };
}

- (UIButton *_Nonnull(^_Nonnull)(UIColor * _Nonnull color))ZXC_setTitleColorHightlighted{
    return ^(UIColor *color) {
        [self setTitleColor:color forState:UIControlStateHighlighted];
        return self;
    };
}

- (UIButton *_Nonnull(^_Nonnull)(UIColor * _Nonnull color))ZXC_setButtonBgColorNormal{
    return ^(UIColor *color) {
        CGRect frame = self.frame;
        CGFloat width = frame.size.width > 1 ? frame.size.width : 1;
        CGFloat height = frame.size.height > 1 ? frame.size.height : 1;
        
        UIImage *image = [self getImageWith:color width:width height:height];
        
        [self setBackgroundImage:image forState:UIControlStateNormal];
        return self;
    };
}


- (UIButton *_Nonnull(^_Nonnull)(UIColor * _Nonnull color))ZXC_setButtonBgColorHightlighted{
    return ^(UIColor *color) {
        CGRect frame = self.frame;
        CGFloat width = frame.size.width > 1 ? frame.size.width : 1;
        CGFloat height = frame.size.height > 1 ? frame.size.height : 1;
        
        UIImage *image = [self getImageWith:color width:width height:height];
        
        [self setBackgroundImage:image forState:UIControlStateHighlighted];
        return self;
    };
}

- (UIButton *_Nonnull(^_Nonnull)(UIImage * _Nonnull image))ZXC_setButtonBgImageNormal{
    return ^(UIImage *image) {
        [self setBackgroundImage:image forState:UIControlStateNormal];
        return self;
    };
}

- (UIButton *_Nonnull(^_Nonnull)(UIImage * _Nonnull image))ZXC_setButtonBgImageHightlighted{
    return ^(UIImage *image) {
        [self setBackgroundImage:image forState:UIControlStateHighlighted];
        return self;
    };
}

- (UIImage *)getImageWith:(UIColor *)color width:(CGFloat)width height:(CGFloat)height{
    CGRect rect = CGRectMake(0.0f, 0.0f, width, height);
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}
- (UIButton *_Nonnull(^_Nonnull)(UIEdgeInsets edge))ZXC_setImageEdge{
    
    return ^(UIEdgeInsets edge){
        self.imageEdgeInsets = edge;
        return self;
    };
}
- (UIButton *_Nonnull(^_Nonnull)(CGFloat cornerRadius, UIColor * _Nullable color, CGFloat borderWidth))ZXC_setRadius{
    return ^(CGFloat cornerRadius, UIColor * _Nullable color, CGFloat borderWidth){
        self.layer.cornerRadius = cornerRadius;
        self.layer.borderColor = color.CGColor;
        self.layer.borderWidth = borderWidth;

        return self;
    };
}
@end
