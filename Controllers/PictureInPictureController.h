#import <AVFoundation/AVFoundation.h>
#import <AVKit/AVKit.h>
#import <UIKit/UIKit.h>

@interface PictureInPictureController : UIViewController <AVPlayerViewControllerDelegate, AVPictureInPictureControllerDelegate>

@property (nonatomic, assign) NSString *videoTime;
@property (nonatomic, assign) NSURL *videoPath;

- (void)setupLightDarkModeVideoView;
- (void)setupPictureInPicture;

@end