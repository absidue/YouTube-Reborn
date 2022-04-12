#import "DownloadsVLCPlayerController.h"

@interface DownloadsVLCPlayerController ()
{
    VLCMediaPlayer *_mediaplayer;
}
@end

@implementation DownloadsVLCPlayerController

- (void)loadView {
    [super loadView];

    _mediaplayer = [[VLCMediaPlayer alloc] init];
    _mediaplayer.delegate = self;
    _mediaplayer.drawable = self.view;

    _mediaplayer.media = [VLCMedia mediaWithURL:self.videoPath];

    [_mediaplayer play];
}

@end