//
//  HikVideoEditTool.m
//  AWKitProduct
//
//  Created by winnie on 2019/12/11.
//  Copyright © 2019 winnie. All rights reserved.
//

#import "HikVideoEditTool.h"
#import <AVFoundation/AVFoundation.h>
@implementation HikVideoEditTool
{
//视频媒体文件
    AVURLAsset *videoAsset;
//CADisplayLink是一个定时器对象，它可以让你与屏幕刷新频率相同的速率来刷新你的视图。就说CADisplayLink是用于同步屏幕刷新频率的计时器
    CADisplayLink *dlink;
//AVAssetExportSession可以以指定导出预设所描述的形式从现有AVAsset的内容创建新的定时媒体资源。
    AVAssetExportSession *exporter;
    
}
- (void)achieveEditVideoPathWithOriginalVideoPath:(NSURL *)videoPath
                                      withWaterImage:(UIImage *)waterImage
                                 withWaterImageFrame:(CGRect )frame{
    if (!videoPath) {
        return;
    }
    //1 创建AVAsset实例 AVAsset包含了video的所有信息 self.videoUrl输入视频的路径
    
    //封面图片
    NSDictionary *opts = [NSDictionary dictionaryWithObject:@(YES) forKey:AVURLAssetPreferPreciseDurationAndTimingKey];
    videoAsset = [AVURLAsset URLAssetWithURL:videoPath options:opts];     //初始化视频媒体文件
    
    CMTime startTime = CMTimeMakeWithSeconds(0.2, 600);
    CMTime endTime = CMTimeMakeWithSeconds(videoAsset.duration.value/videoAsset.duration.timescale-0.2, videoAsset.duration.timescale);
    
    //声音采集
    AVURLAsset * audioAsset = [[AVURLAsset alloc] initWithURL:videoPath options:opts];
    
    //2 创建AVMutableComposition实例. 该类的作用可以在现有的资源中添加和移除轨迹，也可以添加、移除和缩放时间范围
    AVMutableComposition *mixComposition = [[AVMutableComposition alloc] init];
    
    //3 视频通道  工程文件中的轨道，有音频轨、视频轨等，里面可以插入各种对应的素材
    AVMutableCompositionTrack *videoTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeVideo
                                                                        preferredTrackID:kCMPersistentTrackID_Invalid];
    //把视频轨道数据加入到可变轨道中 这部分可以做视频裁剪TimeRange
    [videoTrack insertTimeRange:CMTimeRangeMake(startTime, endTime)
                        ofTrack:[[videoAsset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0]
                         atTime:kCMTimeZero error:nil];
    //音频通道
    AVMutableCompositionTrack * audioTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
    //音频采集通道
    AVAssetTrack * audioAssetTrack = [[audioAsset tracksWithMediaType:AVMediaTypeAudio] firstObject];
    [audioTrack insertTimeRange:CMTimeRangeMake(startTime, endTime) ofTrack:audioAssetTrack atTime:kCMTimeZero error:nil];
    
    //3.1 AVMutableVideoCompositionInstruction 视频轨道中的一个视频，可以缩放、旋转等
    AVMutableVideoCompositionInstruction *mainInstruction = [AVMutableVideoCompositionInstruction videoCompositionInstruction];
    mainInstruction.timeRange = CMTimeRangeMake(kCMTimeZero, videoTrack.timeRange.duration);
    
    // 3.2 AVMutableVideoCompositionLayerInstruction 一个视频轨道，包含了这个轨道上的所有视频素材
    AVMutableVideoCompositionLayerInstruction *videolayerInstruction = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:videoTrack];
    AVAssetTrack *videoAssetTrack = [[videoAsset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0];
    BOOL isVideoAssetPortrait_  = NO;
    CGAffineTransform videoTransform = videoAssetTrack.preferredTransform;
    if (videoTransform.a == 0 && videoTransform.b == 1.0 && videoTransform.c == -1.0 && videoTransform.d == 0) {
        isVideoAssetPortrait_ = YES;
    }
    if (videoTransform.a == 0 && videoTransform.b == -1.0 && videoTransform.c == 1.0 && videoTransform.d == 0) {
        isVideoAssetPortrait_ = YES;
    }
    [videolayerInstruction setTransform:videoAssetTrack.preferredTransform atTime:kCMTimeZero];
    [videolayerInstruction setOpacity:0.0 atTime:endTime];
    // 3.3 - Add instructions
    mainInstruction.layerInstructions = [NSArray arrayWithObjects:videolayerInstruction,nil];
    //AVMutableVideoComposition：管理所有视频轨道，可以决定最终视频的尺寸，裁剪需要在这里进行
    AVMutableVideoComposition *mainCompositionInst = [AVMutableVideoComposition videoComposition];
    
    CGSize naturalSize;
    if(isVideoAssetPortrait_){
        naturalSize = CGSizeMake(videoAssetTrack.naturalSize.height, videoAssetTrack.naturalSize.width);
    } else {
        naturalSize = videoAssetTrack.naturalSize;
    }
    
    float renderWidth, renderHeight;
    renderWidth = naturalSize.width;
    renderHeight = naturalSize.height;
    mainCompositionInst.renderSize = CGSizeMake(renderWidth, renderHeight);
    mainCompositionInst.instructions = [NSArray arrayWithObject:mainInstruction];
    mainCompositionInst.frameDuration = CMTimeMake(1, 25);
    
    [self applyVideoEffectsToComposition:mainCompositionInst WithWaterImg:waterImage withImageFrame:frame size:CGSizeMake(renderWidth, renderHeight)];
    
    // 4 - 输出路径
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSDate *dateNow = [NSDate date];
    NSString *timePath = [NSString stringWithFormat:@"%ld", (long)([dateNow timeIntervalSince1970] * 1000)];
    NSString *myPathDocs =  [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.mp4",timePath]];  // 用时间戳做路径，保证同一个视频可以多次保存
    unlink([myPathDocs UTF8String]);
    NSURL* videoUrl = [NSURL fileURLWithPath:myPathDocs];
    
    dlink = [CADisplayLink displayLinkWithTarget:self selector:@selector(updateProgress)];
    [dlink setPreferredFramesPerSecond:15];
    [dlink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    [dlink setPaused:NO];
    // 5 - 视频文件输出
    
    exporter = [[AVAssetExportSession alloc] initWithAsset:mixComposition
                                                presetName:AVAssetExportPresetHighestQuality];
    exporter.outputURL=videoUrl;
    exporter.outputFileType = AVFileTypeQuickTimeMovie;
    exporter.shouldOptimizeForNetworkUse = YES;
    exporter.videoComposition = mainCompositionInst;
    [exporter exportAsynchronouslyWithCompletionHandler:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            //这里是输出视频之后的操作，做你想做的
            if ([self.delegate respondsToSelector:@selector(videoEditToolOutVideoPath:)]) {
                [self.delegate videoEditToolOutVideoPath:videoUrl];
            }
        });
    }];
}

- (void)applyVideoEffectsToComposition:(AVMutableVideoComposition *)composition WithWaterImg:(UIImage*)waterImage withImageFrame:(CGRect)imageFrame size:(CGSize)size {
    //水印
    CALayer *imgLayer = [CALayer layer];
    imgLayer.contents = (id)waterImage.CGImage;
    imgLayer.bounds = CGRectMake(0, 0, imageFrame.size.width, imageFrame.size.height);
    imgLayer.position = CGPointMake(imageFrame.size.width / 2, size.height - (imageFrame.size.height / 2) );

    //将视频layer和水印layer添加到parentlayer
    CALayer *parentLayer = [CALayer layer];
    CALayer *videoLayer = [CALayer layer];
    parentLayer.frame = CGRectMake(0, 0, size.width, size.height);
    videoLayer.frame = CGRectMake(0, 0, size.width, size.height);
    [parentLayer addSublayer:videoLayer];
    [parentLayer addSublayer:imgLayer];
    
    //通过AVVideoCompositionCoreAnimationTool，将视频与静态图像混合
    composition.animationTool = [AVVideoCompositionCoreAnimationTool
                                 videoCompositionCoreAnimationToolWithPostProcessingAsVideoLayer:videoLayer inLayer:parentLayer];
    
}
 
//更新生成进度
- (void)updateProgress {
    
    if ([self.delegate respondsToSelector:@selector(videoEditTool:outProgress:)]) {
        [self.delegate videoEditTool:self outProgress:exporter.progress];
    }
    if (exporter.progress>=1.0) {
        [dlink setPaused:true];
        [dlink invalidate];
       
    }
}

@end
