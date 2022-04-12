#import "DownloadsController.h"
#import "DownloadsVideoController.h"
#import "DownloadsAudioController.h"
#import "../TheosLinuxFix.h"
#import "../iOS15Fix.h"

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

@end

@implementation DownloadsController(Privates)

- (void)done {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

@end