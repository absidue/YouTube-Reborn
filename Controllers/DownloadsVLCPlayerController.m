#import "DownloadsVLCPlayerController.h"

@interface DownloadsVLCPlayerController ()
{
    VLCMediaPlayer *_mediaplayer;
}
@end

@implementation DownloadsVLCPlayerController

- (void)loadView {
	[super loadView];

    // [self setupLightDarkModeVideoView];

    _mediaplayer = [[VLCMediaPlayer alloc] init];
    _mediaplayer.delegate = self;
    _mediaplayer.drawable = self.movieView;

    /* create a media object and give it to the player */
    _mediaplayer.media = [VLCMedia mediaWithURL:[NSURL URLWithString:@"http://streams.videolan.org/streams/mp4/Mr_MrsSmith-h264_aac.mp4"]];
}

- (IBAction)playandPause:(id)sender
{
    if (_mediaplayer.isPlaying)
        [_mediaplayer pause];

    [_mediaplayer play];
}


- (void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection {
    [super traitCollectionDidChange:previousTraitCollection];
    // [self setupLightDarkModeVideoView];
}

@end

@implementation DownloadsVLCPlayerController(Privates)

- (void)setupLightDarkModeVideoView {
    if (self.traitCollection.userInterfaceStyle == UIUserInterfaceStyleLight) {
        self.view.backgroundColor = [UIColor colorWithRed:0.949 green:0.949 blue:0.969 alpha:1.0];
    }
    else {
        self.view.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:1.0];
    }
}

@end