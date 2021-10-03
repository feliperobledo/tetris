/**
 * This software is in the public domain. Where that dedication is not recognized,
 * you are granted a perpetual, irrevokable license to copy and modify this file
 * as you see fit.
 *
 * Requires SDL 2.0.4.
 * Devices that do not support Metal are not handled currently.
 **/

#import <UIKit/UIKit.h>
#import <Metal/Metal.h>
#import <QuartzCore/CAMetalLayer.h>

#include <SDL.h>
#include <SDL_syswm.h>

@interface MetalView : UIView

@property (nonatomic) CAMetalLayer *metalLayer;

@end

@implementation MetalView

+ (Class)layerClass
{
    return [CAMetalLayer class];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:frame])) {
        /* Resize properly when rotated. */
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;

        /* Use the screen's native scale (retina resolution, when available.) */
        self.contentScaleFactor = [UIScreen mainScreen].nativeScale;

        _metalLayer = (CAMetalLayer *) self.layer;
        _metalLayer.opaque = YES;
        _metalLayer.device = MTLCreateSystemDefaultDevice();

        [self updateDrawableSize];
    }

    return self;
}

/* Set the size of the metal drawables when the view is resized. */
- (void)layoutSubviews
{
    [super layoutSubviews];
    [self updateDrawableSize];
}

- (void)updateDrawableSize
{
    CGSize size  = self.bounds.size;
    size.width  *= self.contentScaleFactor;
    size.height *= self.contentScaleFactor;

    _metalLayer.drawableSize = size;
}

@end

int main(int argc, char *argv[])
{
    SDL_InitSubSystem(SDL_INIT_VIDEO);

    SDL_Window *window = SDL_CreateWindow("", 0, 0, 480, 320, SDL_WINDOW_RESIZABLE);

    SDL_SysWMinfo info;
    SDL_VERSION(&info.version);
    SDL_GetWindowWMInfo(window, &info);

    /**
     * As of SDL 2.0.4, a view and view controller is associated with a
     * window as soon as the window is created. In previous SDL versions
     * that didn't happen until SDL_GL_CreateContext(window) was called.
     **/
    UIView *sdlview = info.info.uikit.window.rootViewController.view;

    MetalView *metalview = [[MetalView alloc] initWithFrame:sdlview.frame];
    [sdlview addSubview:metalview];

    MTLRenderPassDescriptor *renderdesc = [MTLRenderPassDescriptor renderPassDescriptor];
    MTLRenderPassColorAttachmentDescriptor *colorattachment = renderdesc.colorAttachments[0];

    /* Clear to a red-orange color when beginning the render pass. */
    colorattachment.clearColor  = MTLClearColorMake(1.0, 0.3, 0.0, 1.0);
    colorattachment.loadAction  = MTLLoadActionClear;
    colorattachment.storeAction = MTLStoreActionStore;

    id <MTLCommandQueue> queue = [metalview.metalLayer.device newCommandQueue];

    while (1) {
        SDL_Event e;
        while (SDL_PollEvent(&e)) {
            /* Handle SDL events. */
        }

        @autoreleasepool {
            id <MTLCommandBuffer> cmdbuf = [queue commandBuffer];

            id <CAMetalDrawable> drawable = [metalview.metalLayer nextDrawable];
            colorattachment.texture = drawable.texture;

            /* The drawable's texture is cleared to the specified color here. */
            id <MTLRenderCommandEncoder> encoder = [cmdbuf renderCommandEncoderWithDescriptor:renderdesc];
            [encoder endEncoding];

            [cmdbuf presentDrawable:drawable];
            [cmdbuf commit];
        }
    }

    [metalview removeFromSuperview];

    SDL_DestroyWindow(window);
    SDL_QuitSubSystem(SDL_INIT_VIDEO);

    return 0;
}
