#import <AVFoundation/AVFoundation.h>
#import <AVKit/AVKit.h>
#import <UIKit/UIKit.h>

@interface DownloadsVideoController : UITableViewController <AVPlayerViewControllerDelegate>

- (void)setupDownloadsVideoControllerView;
- (void)setupVideoArrays;

@end

extern NSURL *downloadsPathURL;