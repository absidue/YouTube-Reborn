#import "DownloadsController.h"
#import "DownloadsVideoController.h"
#import "DownloadsAudioController.h"
#import "../iOS15Fix.h"

static int __isOSVersionAtLeast(int major, int minor, int patch) { NSOperatingSystemVersion version; version.majorVersion = major; version.minorVersion = minor; version.patchVersion = patch; return [[NSProcessInfo processInfo] isOperatingSystemAtLeastVersion:version]; }

@interface DownloadsController ()
@end

@implementation DownloadsController

- (void)loadView {
	[super loadView];

    [self.navigationController setNavigationBarHidden:YES animated:NO];

    self.tabBar = [[UITabBarController alloc] init];

    DownloadsVideoController *videoViewController = [[DownloadsVideoController alloc] init];
    videoViewController.title = @"Video";

    DownloadsAudioController *audioViewController = [[DownloadsAudioController alloc] init];
    audioViewController.title = @"Audio";

    self.tabBar.viewControllers = [NSArray arrayWithObjects:videoViewController, audioViewController, nil];

    [self.view addSubview:self.tabBar.view];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
    [[AVAudioSession sharedInstance] setActive:YES error:nil];
}

@end

@implementation DownloadsController(Privates)

- (void)done {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

@end