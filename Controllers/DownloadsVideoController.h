#import <AVFoundation/AVFoundation.h>
#import <AVKit/AVKit.h>
#import <UIKit/UIKit.h>

@interface DownloadsVideoController : UITableViewController <AVPlayerViewControllerDelegate>

- (void)setupLightDarkModeVideoView;
- (void)setupVideoArrays;

@end

extern NSURL *downloadsPathURL;