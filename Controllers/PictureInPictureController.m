#import "PictureInPictureController.h"

@interface PictureInPictureController ()
@end

@implementation PictureInPictureController

AVPlayer *player;
AVPlayerLayer *playerLayer;
AVPictureInPictureController *pictureInPictureController;

- (void)loadView {
	[super loadView];

    [self.navigationController setNavigationBarHidden:YES animated:NO];

    [self setupPictureInPictureControllerView];

    AVPlayerItem *playerItem = [[AVPlayerItem alloc] initWithURL:self.videoPath];
    player = [[AVPlayer alloc] initWithPlayerItem:playerItem];
    float newTimeFloat = [self.videoTime floatValue];
    CMTime newTime = CMTimeMakeWithSeconds(newTimeFloat, 1);
    [player seekToTime:newTime];

    [player addObserver:self forKeyPath:@"status" options:0 context:nil];
    [player addObserver:self forKeyPath:@"timeControlStatus" options:0 context:nil];

    playerLayer = [AVPlayerLayer playerLayerWithPlayer:player];
    playerLayer.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.width * 9 / 16);
    playerLayer.hidden = YES;

    [self.view.layer addSublayer:playerLayer];

    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button addTarget:self action:@selector(closePip) forControlEvents:UIControlEventTouchUpInside];
    button.frame = self.view.bounds;
    [button setTitle:@"Tap To Stop Picture-In-Picture" forState:UIControlStateNormal];
    [self.view addSubview:button];
}

- (void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection {
    [super traitCollectionDidChange:previousTraitCollection];
    [self setupPictureInPictureControllerView];
}

@end

@implementation PictureInPictureController(Privates)

- (void)setupPictureInPictureControllerView {
    if (self.traitCollection.userInterfaceStyle == UIUserInterfaceStyleLight) {
        self.view.backgroundColor = [UIColor colorWithRed:0.949 green:0.949 blue:0.969 alpha:1.0];
    }
    else {
        self.view.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:1.0];
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if (object == player && [keyPath isEqualToString:@"status"]) {
        if (player.status == AVPlayerStatusReadyToPlay) {
            if([AVPictureInPictureController isPictureInPictureSupported]) {
                pictureInPictureController = [[AVPictureInPictureController alloc] initWithPlayerLayer:playerLayer];
                pictureInPictureController.delegate = self;
                if ([pictureInPictureController respondsToSelector:@selector(setCanStartPictureInPictureAutomaticallyFromInline:)]) {
                    pictureInPictureController.canStartPictureInPictureAutomaticallyFromInline = YES;
                }
            }
            [player play];
        }
    } else if (object == player && [keyPath isEqualToString:@"timeControlStatus"]) {
        if (player.timeControlStatus == AVPlayerTimeControlStatusPlaying) {
            if([AVPictureInPictureController isPictureInPictureSupported]) {
                [pictureInPictureController startPictureInPicture];
            }
        }
    }
}

- (void)closePip {
    if ([pictureInPictureController isPictureInPictureActive]) {
        [pictureInPictureController stopPictureInPicture];
    }
    [player pause];
    [playerLayer removeFromSuperlayer];
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

@end