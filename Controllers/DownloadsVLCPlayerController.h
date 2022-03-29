#import <AVFoundation/AVFoundation.h>
#import <AVKit/AVKit.h>
#import <UIKit/UIKit.h>
#import <MobileVLCKit/MobileVLCKit.h>

@interface DownloadsVLCPlayerController : UIViewController <VLCMediaPlayerDelegate>

@property (nonatomic, strong) IBOutlet UIView *movieView;

- (IBAction)playandPause:(id)sender;

- (void)setupLightDarkModeVideoView;

@end