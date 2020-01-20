//
//  HikVideoEditTool.h
//  AWKitProduct
//
//  Created by winnie on 2019/12/11.
//  Copyright © 2019 winnie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

@protocol HikVideoEditToolDelegate <NSObject>

//获取视频合成进度
- (void)videoEditTool:(NSObject *)videoEditTool outProgress:(CGFloat)progress;

//获取视频输出结果
- (NSURL *)videoEditToolOutVideoPath:(NSURL *)outVideoPath;


@end

@interface HikVideoEditTool : NSObject


/// 根据视频URL和水印图片输出编辑后视频
/// @param videoPath 原始视频
/// @param waterImage 水印图片
/// @param frame 水印图片位置大小

- (void)achieveEditVideoPathWithOriginalVideoPath:(NSURL *)videoPath
                                   withWaterImage:(UIImage *)waterImage
                              withWaterImageFrame:(CGRect )frame;



@property (nonatomic, weak)id<HikVideoEditToolDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
