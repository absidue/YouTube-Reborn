#import <AVFoundation/AVFoundation.h>
#import <AVKit/AVKit.h>
#import <UIKit/UIKit.h>
#import <MobileVLCKit/MobileVLCKit.h>

@interface DownloadsVLCPlayerController : UIViewController <VLCMediaPlayerDelegate>

@property (nonatomic, assign) NSURL *videoPath;

@end