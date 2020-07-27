//
//  UIButton+ZXCTool.h
//  ZLHJ
//
//  Created by 周希财 on 2018/3/28.
//  Copyright © 2018年 VIC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (ZXCTool)

/*********设置button 倒计时********/
- (void)ZXC_CountdownWithInterval:(NSInteger)interval title:(NSString *_Nonnull)text;

/********* 设置button title （ ZXC_setXXX(title) ） ********/
- (UIButton *_Nonnull(^_Nonnull)(NSString * _Nonnull title))ZXC_setButtonTitle;

/********* 设置button 选中 title （ ZXC_setXXX(title) ） ********/
- (UIButton *_Nonnull(^_Nonnull)(NSString *_Nonnull title))ZXC_setButtonTitleSelected;

/********* 设置button title 字号 （ ZXC_setXXX(fontSize) ） ********/
- (UIButton *_Nonnull(^_Nonnull)(CGFloat fontSize))ZXC_setButtonTitleFontSize;

/********* 设置button title 字体和字号 （ ZXC_setXXX(fontName, fontSize) ） fontName为 nil 时为默认 ********/
- (UIButton *_Nonnull(^_Nonnull)(NSString * _Nullable fontName, CGFloat fontSize))ZXC_setButtonTitleFont;

/********* 设置button title颜色 （ ZXC_setXXX(color) ） ********/
- (UIButton *_Nonnull(^_Nonnull)(UIColor * _Nonnull color))ZXC_setTitleColorNormal;

/********* 设置button 高亮 title颜色 （ ZXC_setXXX(color) ） ********/
- (UIButton *_Nonnull(^_Nonnull)(UIColor * _Nonnull color))ZXC_setTitleColorHightlighted;

/********* 设置button normal 背景颜色（颜色转图片） （ ZXC_setXXX(color) ） ********/
- (UIButton *_Nonnull(^_Nonnull)(UIColor * _Nonnull color))ZXC_setButtonBgColorNormal;

/********* 设置button hightlighted 背景颜色（颜色转图片） （ ZXC_setXXX(color) ） ********/
- (UIButton *_Nonnull(^_Nonnull)(UIColor * _Nonnull color))ZXC_setButtonBgColorHightlighted;

/********* 设置button normal 背景图片（颜色转图片） （ ZXC_setXXX(image) ） ********/
- (UIButton *_Nonnull(^_Nonnull)(UIImage * _Nonnull image))ZXC_setButtonBgImageNormal;

/********* 设置button hightlighted 背景图片（颜色转图片） （ ZXC_setXXX(image) ） ********/
- (UIButton *_Nonnull(^_Nonnull)(UIImage * _Nonnull image))ZXC_setButtonBgImageHightlighted;


/********* 设置button normal 图片 （ ZXC_setXXX(image) ） ********/
- (UIButton *_Nonnull(^_Nonnull)(UIImage * _Nonnull image))ZXC_setButtonImageNormal;

/********* 设置button UIControlState 图片（颜色转图片） （ ZXC_setXXX(image) ） ********/
- (UIButton *_Nonnull(^_Nonnull)(UIImage * _Nonnull image, UIControlState state))ZXC_setButtonImageControlState;

/********* 设置button 图片偏移量（颜色转图片） （ ZXC_setXXX(image) ） ********/
- (UIButton *_Nonnull(^_Nonnull)(UIEdgeInsets edge))ZXC_setImageEdge;

/********* 设置button 图片圆角 （ ZXC_setXXX(cornerRadius, color, borderWidth) ） ********/
- (UIButton *_Nonnull(^_Nonnull)(CGFloat cornerRadius, UIColor * _Nullable color, CGFloat borderWidth))ZXC_setRadius;

@end
