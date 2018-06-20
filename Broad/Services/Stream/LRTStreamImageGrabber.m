//
//  LRTStreamImageGrabber.m
//  lrt
//
//  Created by Karolis Stasaitis on 26/05/2017.
//  Copyright © 2017 delanoir. All rights reserved.
//

#import "LRTStreamImageGrabber.h"
#import "FFmpeg/ffmpeg.h"

typedef struct {
    AVFrame *frame;
    void *buffer;
} LRTFrameBuffer;

LRTFrameBuffer *LRTFrameBufferCreate(AVFrame *frame, void *buffer) {
    LRTFrameBuffer *ptr = malloc(sizeof(LRTFrameBuffer));
    ptr->frame = frame;
    ptr->buffer = buffer;
    return ptr;
}

void LRTFrameBufferFreeBuffer(LRTFrameBuffer *info) {
    av_free(info->buffer);
    av_frame_unref(info->frame);
}

void *LRTFrameBufferGetByte(LRTFrameBuffer *info) {
    return info->frame->data[0];
}

void LRTFrameBufferFree(LRTFrameBuffer *info) {
    free(info);
}

@interface LRTStreamImageGrabber ()

@end

@implementation LRTStreamImageGrabber

- (instancetype)init
{
    self = [super init];
    if (self) {
        avformat_network_init();
        av_register_all();
    }
    return self;
}

- (nullable UIImage *)generateImageForUrl:(NSURL *)url size:(CGSize)size error:(NSError **)error
{
    CGFloat scale = UIScreen.mainScreen.scale;
    int width = (int)(size.width * scale),
        height = (int)(size.height * scale);
    const char *curl = [url.absoluteString cStringUsingEncoding: NSASCIIStringEncoding];
    int ret = 0;
    
    AVFormatContext *format_c = nil;
    AVStream *stream = nil;
    AVCodecParameters *codec_par = nil;
    AVCodec *codec = nil;
    AVCodecContext *codec_c = nil;
    AVFrame *frame = nil;
    AVFrame *frame_rgb = nil;
    int img_len = 0;
    uint8_t *buffer = nil;
    struct SwsContext *sws_c = nil;
    AVPacket packet;
    
    AVDictionary *stream_options = nil;
    av_dict_set(&stream_options, "analyzeduration", "1000000000", 0);
    av_dict_set(&stream_options, "probesize", "1000000000", 0);
    if ((ret = avformat_open_input(&format_c, curl, nil, &stream_options)) < 0) {
        *error = [self spewErrorForCode: ret];
        goto cleanup;
    }
    
    if ((ret = avformat_find_stream_info(format_c, nil)) < 0) {
        *error = [self spewErrorForCode: ret];
        goto cleanup;
    }
    
    for (int i = 0; i < format_c->nb_streams; i++) {
        AVStream *curr_stream = format_c->streams[i];
        if (curr_stream->codecpar->codec_type == AVMEDIA_TYPE_VIDEO && curr_stream->codecpar->width > 0) {
            stream = curr_stream;
            codec_par = stream->codecpar;
            //Just take the first one and break;
            break;
        }
    }
    
    if (stream == nil) {
        *error = [self spewErrorWithDescription: @"No video stream found"];
        goto cleanup;
    }
    
    if ((codec = avcodec_find_decoder(codec_par->codec_id)) == nil) {
        *error = [self spewErrorWithDescription: @"No suitable decoder found"];
        goto cleanup;
    }
    
    if (height == 0 && width == 0) {
        height = codec_par->height;
        width = codec_par->width;
    } else if (height == 0) {
        height = (int)((CGFloat)width / (CGFloat)codec_par->width * (CGFloat)codec_par->height);
    } else if (width == 0) {
        width = (int)((CGFloat)height / (CGFloat)codec_par->height * (CGFloat)codec_par->width);
    }
    
    if ((codec_c = avcodec_alloc_context3(codec)) == nil) {
        *error = [self spewErrorWithDescription: @"Couldn't allocated codec context"];
        goto cleanup;
    }
    
    if ((ret = avcodec_parameters_to_context(codec_c, codec_par)) < 0) {
        *error = [self spewErrorForCode: ret];
        goto cleanup;
    }
    
    if ((ret = avcodec_open2(codec_c, codec, nil)) < 0) {
        *error = [self spewErrorForCode: ret];
        goto cleanup;
    }
    
    frame = av_frame_alloc();
    frame_rgb = av_frame_alloc();
    if (frame == nil || frame_rgb == nil) {
        *error = [self spewErrorWithDescription: @"Failed to allocate frames"];
        goto cleanup;
    }
    
    img_len = av_image_get_buffer_size(AV_PIX_FMT_RGB24, width, height, 1);
//    img_len = avpicture_get_size(AV_PIX_FMT_RGB24, width, height);
    if ((buffer = av_malloc(img_len * sizeof(uint8_t))) == nil) {
        *error = [self spewErrorWithDescription: @"Failed to allocate buffer"];
        goto cleanup;
    }
    
    if ((ret = av_image_fill_arrays(frame_rgb->data, frame_rgb->linesize, buffer, AV_PIX_FMT_RGB24, width, height, 1)) < 0) {
//    if ((ret = avpicture_fill((AVPicture *)frame_rgb, buffer, AV_PIX_FMT_RGB24, width, height)) < 0) {
        *error = [self spewErrorForCode: ret];
        goto cleanup;
    }
    
    sws_c = sws_getContext(
        codec_c->width,
        codec_c->height,
        codec_c->pix_fmt,
        width,
        height,
        AV_PIX_FMT_RGB24,
        SWS_BILINEAR,
        nil,
        nil,
        nil
    );
    if (sws_c == nil) {
        *error = [self spewErrorWithDescription: @"Failed to get sws context"];
        goto cleanup;
    }
    
    while (av_read_frame(format_c, &packet) >= 0) {
        if (packet.stream_index == stream->index) {
            @synchronized (self) {
                avcodec_send_packet(codec_c, &packet);
//                avcodec_decode_video2(codec_c, frame, &frame_done, &packet);
            }
            if (!avcodec_receive_frame(codec_c, frame)) {
                sws_scale(
                    sws_c,
                    (uint8_t const * const *)frame->data,
                    frame->linesize,
                    0,
                    codec_c->height,
                    frame_rgb->data,
                    frame_rgb->linesize
                );
                
                CGBitmapInfo bitmapInfo = kCGBitmapByteOrderDefault;
                LRTFrameBuffer *bufferInfo = LRTFrameBufferCreate(frame_rgb, buffer);
                CGDataProviderDirectCallbacks callbacks = {
                    0, (void *)LRTFrameBufferGetByte, (void *)LRTFrameBufferFreeBuffer, NULL, (void *)LRTFrameBufferFree
                };
                CGDataProviderRef provider = CGDataProviderCreateDirect((void *)bufferInfo, frame_rgb->linesize[0] * height, &callbacks);
                CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
                CGImageRef cgImage = CGImageCreate(
                    width,
                    height,
                    8,
                    24,
                    frame_rgb->linesize[0],
                    colorSpace, 
                    bitmapInfo, 
                    provider, 
                    nil,
                    NO,
                    kCGRenderingIntentDefault
                );
                CGColorSpaceRelease(colorSpace);
                UIImage *image = [UIImage imageWithCGImage:cgImage scale:scale orientation: 0];
                CGImageRelease(cgImage);
                CGDataProviderRelease(provider);
                
                av_frame_unref(frame);
                avcodec_close(codec_c);
                avformat_close_input(&format_c);
                av_packet_unref(&packet);
                
                return image;
            }
        }
        av_packet_unref(&packet);
    }
    
cleanup:
    if (buffer != nil) av_free(buffer);
    if (frame_rgb != nil) av_frame_unref(frame_rgb);
    if (frame != nil) av_frame_unref(frame);
    if (codec_c != nil) avcodec_close(codec_c);
    if (format_c != nil) avformat_close_input(&format_c);
    return nil;
}

- (NSError *)spewErrorForCode:(int)code
{
    const char* err_str = av_err2str(code);
    NSString *cocoa_str = [NSString stringWithCString:err_str encoding:NSASCIIStringEncoding];
    return [NSError errorWithDomain:@"LRTStreamImageGrabber"
                               code:code
                           userInfo:@{NSLocalizedDescriptionKey: cocoa_str}];
}

- (NSError *)spewErrorWithDescription:(NSString *)desc
{
    return [NSError errorWithDomain:@"LRTStreamImageGrabber"
                               code:1
                           userInfo:@{NSLocalizedDescriptionKey: desc}];
}

@end
