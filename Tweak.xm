#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <AFNetworking/AFNetworking.h>
#import "Controllers/RootOptionsController.h"
#import "Controllers/PictureInPictureController.h"
#import "Jailbreak-Detection-Lib/JailbreakDetectionLib.h"
// #import "MobileFFmpeg/MobileFFmpegConfig.h"
// #import "MobileFFmpeg/MobileFFmpeg.h"
#import "Tweak.h"

#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)

UIColor *hexColour() {
    NSData *colorData = [[NSUserDefaults standardUserDefaults] objectForKey:@"kYTRebornColourOptionsVThree"];
    NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingFromData:colorData error:nil];
    [unarchiver setRequiresSecureCoding:NO];
    return [unarchiver decodeObjectForKey:NSKeyedArchiveRootObjectKey];
}

YTLocalPlaybackController *playingVideoID;

%hook YTLocalPlaybackController
- (NSString *)currentVideoID {
    playingVideoID = self;
    return %orig;
}
%end

YTMainAppVideoPlayerOverlayViewController *resultOut;
YTMainAppVideoPlayerOverlayViewController *layoutOut;
YTMainAppVideoPlayerOverlayViewController *stateOut;

%hook YTMainAppVideoPlayerOverlayViewController
- (CGFloat)mediaTime {
    resultOut = self;
    return %orig;
}
- (int)playerViewLayout {
    layoutOut = self;
    return %orig;
}
- (NSInteger)playerState {
    stateOut = self;
    return %orig;
}
%end

%hook YTRightNavigationButtons
%property (strong, nonatomic) YTQTMButton *youtubeRebornButton;
- (NSMutableArray *)buttons {
	NSString *tweakBundlePath = [[NSBundle mainBundle] pathForResource:@"YouTubeReborn" ofType:@"bundle"];
    NSString *youtubeRebornLightSettingsPath;
    NSString *youtubeRebornDarkSettingsPath;
    if (tweakBundlePath) {
        NSBundle *tweakBundle = [NSBundle bundleWithPath:tweakBundlePath];
        youtubeRebornLightSettingsPath = [tweakBundle pathForResource:@"ytrebornbuttonwhite" ofType:@"png"];
		youtubeRebornDarkSettingsPath = [tweakBundle pathForResource:@"ytrebornbuttonblack" ofType:@"png"];
    } else {
		youtubeRebornLightSettingsPath = @"/Library/Application Support/YouTubeReborn.bundle/ytrebornbuttonwhite.png";
        youtubeRebornDarkSettingsPath = @"/Library/Application Support/YouTubeReborn.bundle/ytrebornbuttonblack.png";
    }
    NSMutableArray *retVal = %orig.mutableCopy;
    [self.youtubeRebornButton removeFromSuperview];
    [self addSubview:self.youtubeRebornButton];
    if (!self.youtubeRebornButton) {
        self.youtubeRebornButton = [%c(YTQTMButton) iconButton];
        self.youtubeRebornButton.frame = CGRectMake(0, 0, 24, 24);
        
        if ([%c(YTPageStyleController) pageStyle] == 0) {
            [self.youtubeRebornButton setImage:[UIImage imageWithContentsOfFile:youtubeRebornDarkSettingsPath] forState:UIControlStateNormal];
        }
        else if ([%c(YTPageStyleController) pageStyle] == 1) {
            [self.youtubeRebornButton setImage:[UIImage imageWithContentsOfFile:youtubeRebornLightSettingsPath] forState:UIControlStateNormal];
        }
        
        [self.youtubeRebornButton addTarget:self action:@selector(rootOptionsAction) forControlEvents:UIControlEventTouchUpInside];
        [retVal insertObject:self.youtubeRebornButton atIndex:0];
    }
    return retVal;
}
- (NSMutableArray *)visibleButtons {
    NSMutableArray *retVal = %orig.mutableCopy;
    [self setLeadingPadding:+10];
    if (self.youtubeRebornButton) {
        [self.youtubeRebornButton removeFromSuperview];
        [self addSubview:self.youtubeRebornButton];
        [retVal insertObject:self.youtubeRebornButton atIndex:0];
    }
    return retVal;
}
%new;
- (void)rootOptionsAction {
    RootOptionsController *rootOptionsController = [[RootOptionsController alloc] init];
    UINavigationController *rootOptionsControllerView = [[UINavigationController alloc] initWithRootViewController:rootOptionsController];
    rootOptionsControllerView.modalPresentationStyle = UIModalPresentationFullScreen;

    UIViewController *rootPrefsViewController = self._viewControllerForAncestor;
    [rootPrefsViewController presentViewController:rootOptionsControllerView animated:YES completion:nil];
}
%end

%hook SSOKeychain
+ (id)accessGroup {
    if (![JailbreakDetectionLib isJailbroken]) {
        NSDictionary *query = [NSDictionary dictionaryWithObjectsAndKeys:
                            (__bridge NSString *)kSecClassGenericPassword, (__bridge NSString *)kSecClass,
                            @"bundleSeedID", kSecAttrAccount,
                            @"", kSecAttrService,
                            (id)kCFBooleanTrue, kSecReturnAttributes,
                            nil];
        CFDictionaryRef result = nil;
        OSStatus status = SecItemCopyMatching((__bridge CFDictionaryRef)query, (CFTypeRef *)&result);
        if (status == errSecItemNotFound)
            status = SecItemAdd((__bridge CFDictionaryRef)query, (CFTypeRef *)&result);
            if (status != errSecSuccess)
                return nil;
        NSString *accessGroup = [(__bridge NSDictionary *)result objectForKey:(__bridge NSString *)kSecAttrAccessGroup];
        
        return accessGroup;
    }
    return %orig;
}
+ (id)sharedAccessGroup {
    if (![JailbreakDetectionLib isJailbroken]) {
        NSDictionary *query = [NSDictionary dictionaryWithObjectsAndKeys:
                            (__bridge NSString *)kSecClassGenericPassword, (__bridge NSString *)kSecClass,
                            @"bundleSeedID", kSecAttrAccount,
                            @"", kSecAttrService,
                            (id)kCFBooleanTrue, kSecReturnAttributes,
                            nil];
        CFDictionaryRef result = nil;
        OSStatus status = SecItemCopyMatching((__bridge CFDictionaryRef)query, (CFTypeRef *)&result);
        if (status == errSecItemNotFound)
            status = SecItemAdd((__bridge CFDictionaryRef)query, (CFTypeRef *)&result);
            if (status != errSecSuccess)
                return nil;
        NSString *accessGroup = [(__bridge NSDictionary *)result objectForKey:(__bridge NSString *)kSecAttrAccessGroup];
        
        return accessGroup;
    }
    return %orig;
}
%end

NSString *videoTime;
NSURL *bestURL;

%hook YTMainAppControlsOverlayView

%property(retain, nonatomic) UIButton *overlayButtonOne;

- (id)initWithDelegate:(id)delegate {
    self = %orig;
    if (self) {
        self.overlayButtonOne = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [self.overlayButtonOne addTarget:self action:@selector(optionsAction) forControlEvents:UIControlEventTouchUpInside];
        [self.overlayButtonOne setTitle:@"OP" forState:UIControlStateNormal];
        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"kShowStatusBarInOverlay"] == YES) {
            if ([[NSUserDefaults standardUserDefaults] boolForKey:@"kEnableiPadStyleOniPhone"] == YES) {
                self.overlayButtonOne.frame = CGRectMake(40, 9, 40.0, 30.0);
            } else {
                self.overlayButtonOne.frame = CGRectMake(40, 24, 40.0, 30.0);
            }
        } else {
            self.overlayButtonOne.frame = CGRectMake(40, 9, 40.0, 30.0);
        }
        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"kHideRebornOPButtonVTwo"] == YES) {
            self.overlayButtonOne.hidden = YES;
        }
        [self addSubview:self.overlayButtonOne];
    }
    return self;
}

- (void)setTopOverlayVisible:(BOOL)visible isAutonavCanceledState:(BOOL)canceledState {
    if (canceledState) {
        if (!self.overlayButtonOne.hidden) {
            self.overlayButtonOne.alpha = 0.0;
        }
    } else {
        if (!self.overlayButtonOne.hidden) {
            int rotation = [layoutOut playerViewLayout];
            if (rotation == 2) {
                self.overlayButtonOne.alpha = visible ? 1.0 : 0.0;
            } else {
                self.overlayButtonOne.alpha = 0.0;
            }
        }
    }
    %orig;
}

%new;
- (void)optionsAction {
    NSInteger videoStatus = [stateOut playerState];
    if (videoStatus == 3) {
        [self didPressPause:[self playPauseButton]];
    }

    NSString *videoIdentifier = [playingVideoID currentVideoID];

    UIAlertController *alertMenu = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];

    [alertMenu addAction:[UIAlertAction actionWithTitle:@"Download Audio" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self artworkDownloader:@"audio":0:videoIdentifier];
    }]];

    [alertMenu addAction:[UIAlertAction actionWithTitle:@"Download Video" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        // [self videoDownloaderOptions:videoIdentifier];
    }]];

    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"14.0")) {
        [alertMenu addAction:[UIAlertAction actionWithTitle:@"Picture In Picture (Beta)" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            // [self pictureInPicture:videoIdentifier];
        }]];
    }

    [alertMenu addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
    }]];

    [alertMenu setModalPresentationStyle:UIModalPresentationPopover];
    UIPopoverPresentationController *popPresenter = [alertMenu popoverPresentationController];
    popPresenter.sourceView = self;
    popPresenter.sourceRect = self.bounds;

    UIViewController *menuViewController = self._viewControllerForAncestor;
    [menuViewController presentViewController:alertMenu animated:YES completion:nil];
}

%new;
- (void)artworkDownloader:(NSString *)downloader :(NSInteger)quality :(NSString *)videoID {
}

%new;
- (void)audioDownloader:(NSString *)videoID {
}

%new;
- (void)videoDownloaderOptions:(NSString *)videoID {
}

%new;
- (void)videoDownloader:(NSInteger)quality :(NSString *)videoID {
}

%new;
- (void)pictureInPicture:(NSString *)videoID {
}
%end

%group gNoVideoAds
%hook YTAdsInnerTubeContextDecorator
- (void)decorateContext:(id)arg1 {
}
%end
%hook YTInnerTubeContextDecorator
- (void)decorateContext:(id)arg1 {
}
%end
%hook YTIPlayerResponse
- (BOOL)isMonetized {
    return NO;
}
%end
%hook YTDataUtils
+ (id)spamSignalsDictionary {
    return NULL;
}
%end
%end

%group gBackgroundPlayback
%hook YTIPlayerResponse
- (BOOL)isPlayableInBackground {
    return YES;
}
%end
%hook YTSingleVideo
- (BOOL)isPlayableInBackground {
    return YES;
}
%end
%hook YTSingleVideoMediaData
- (BOOL)isPlayableInBackground {
    return YES;
}
%end
%hook YTPlaybackData
- (BOOL)isPlayableInBackground {
    return YES;
}
%end
%hook YTIPlayabilityStatus
- (BOOL)isPlayableInBackground {
    return YES;
}
%end
%hook YTPlaybackBackgroundTaskController
- (BOOL)isContentPlayableInBackground {
    return YES;
}
- (void)setContentPlayableInBackground:(BOOL)arg1 {
    arg1 = YES;
	%orig;
}
%end
%hook YTBackgroundabilityPolicy
- (BOOL)isBackgroundableByUserSettings {
    return YES;
}
%end
%end

%group gExtraSpeedOptions
%hook YTVarispeedSwitchController
- (void *)init {
    void *ret = (void *)%orig;

    NSMutableArray *ytSpeedOptions = [NSMutableArray new];
    [ytSpeedOptions addObject:[[NSClassFromString(@"YTVarispeedSwitchControllerOption") alloc] initWithTitle:@"0.1x" rate:0.1]];
    [ytSpeedOptions addObject:[[NSClassFromString(@"YTVarispeedSwitchControllerOption") alloc] initWithTitle:@"0.25x" rate:0.25]];
    [ytSpeedOptions addObject:[[NSClassFromString(@"YTVarispeedSwitchControllerOption") alloc] initWithTitle:@"0.5x" rate:0.5]];
    [ytSpeedOptions addObject:[[NSClassFromString(@"YTVarispeedSwitchControllerOption") alloc] initWithTitle:@"0.75x" rate:0.75]];
    [ytSpeedOptions addObject:[[NSClassFromString(@"YTVarispeedSwitchControllerOption") alloc] initWithTitle:@"Normal" rate:1]];
    [ytSpeedOptions addObject:[[NSClassFromString(@"YTVarispeedSwitchControllerOption") alloc] initWithTitle:@"1.25x" rate:1.25]];
    [ytSpeedOptions addObject:[[NSClassFromString(@"YTVarispeedSwitchControllerOption") alloc] initWithTitle:@"1.5x" rate:1.5]];
    [ytSpeedOptions addObject:[[NSClassFromString(@"YTVarispeedSwitchControllerOption") alloc] initWithTitle:@"1.75x" rate:1.75]];
    [ytSpeedOptions addObject:[[NSClassFromString(@"YTVarispeedSwitchControllerOption") alloc] initWithTitle:@"2x" rate:2]];
    [ytSpeedOptions addObject:[[NSClassFromString(@"YTVarispeedSwitchControllerOption") alloc] initWithTitle:@"2.5x" rate:2.5]];
    [ytSpeedOptions addObject:[[NSClassFromString(@"YTVarispeedSwitchControllerOption") alloc] initWithTitle:@"3x" rate:3]];
    [ytSpeedOptions addObject:[[NSClassFromString(@"YTVarispeedSwitchControllerOption") alloc] initWithTitle:@"3.5x" rate:3.5]];
    [ytSpeedOptions addObject:[[NSClassFromString(@"YTVarispeedSwitchControllerOption") alloc] initWithTitle:@"4x" rate:4]];
    [ytSpeedOptions addObject:[[NSClassFromString(@"YTVarispeedSwitchControllerOption") alloc] initWithTitle:@"5x" rate:5]];
    MSHookIvar<NSArray *>(self, "_options") = [ytSpeedOptions copy];

    return ret;
}
%end
%hook MLHAMQueuePlayer
- (void)setRate:(float)rate {
	MSHookIvar<float>(self, "_rate") = rate;

	id ytPlayer = MSHookIvar<HAMPlayerInternal *>(self, "_player");
	[ytPlayer setRate:rate];

	[self.playerEventCenter broadcastRateChange:rate];
}
%end
%end

%group gNoCastButton
%hook YTSettings
- (BOOL)disableMDXDeviceDiscovery {
    return YES;
} 
%end
%hook YTRightNavigationButtons
- (void)layoutSubviews {
	%orig();
	if(![[self MDXButton] isHidden]) [[self MDXButton] setHidden:YES];
}
%end
%hook YTMainAppControlsOverlayView
- (void)layoutSubviews {
	%orig();
	if(![[self playbackRouteButton] isHidden]) [[self playbackRouteButton] setHidden:YES];
}
%end
%end

%group gNoNotificationButton
%hook YTNotificationPreferenceToggleButton
- (void)setHidden:(BOOL)arg1 {
    arg1 = YES;
    %orig;
}
%end
%hook YTNotificationMultiToggleButton
- (void)setHidden:(BOOL)arg1 {
    arg1 = YES;
    %orig;
}
%end
%hook YTRightNavigationButtons
- (void)layoutSubviews {
	%orig();
	if(![[self notificationButton] isHidden]) [[self notificationButton] setHidden:YES];
}
%end
%end

%group gAllowHDOnCellularData
%hook YTUserDefaults
- (BOOL)disableHDOnCellular {
	return NO;
}
- (void)setDisableHDOnCellular:(BOOL)arg1 {
    arg1 = NO;
    %orig;
}
%end
%hook YTSettings
- (BOOL)disableHDOnCellular {
	return NO;
}
- (void)setDisableHDOnCellular:(BOOL)arg1 {
    arg1 = NO;
    %orig;
}
%end
%end

%group gShowStatusBarInOverlay
%hook YTSettings
- (BOOL)showStatusBarWithOverlay {
    return YES;
}
%end
%end

%group gDisableRelatedVideosInOverlay
%hook YTRelatedVideosViewController
- (BOOL)isEnabled {
    return NO;
}
- (void)setEnabled:(BOOL)arg1 {
    arg1 = NO;
	%orig;
}
%end
%hook YTFullscreenEngagementOverlayView
- (BOOL)isEnabled {
    return NO;
} 
- (void)setEnabled:(BOOL)arg1 {
    arg1 = NO;
    %orig;
} 
%end
%hook YTFullscreenEngagementOverlayController
- (BOOL)isEnabled {
    return NO;
}
- (void)setEnabled:(BOOL)arg1 {
    arg1 = NO;
    %orig;
}
%end
%hook YTMainAppVideoPlayerOverlayView
- (void)setInfoCardButtonHidden:(BOOL)arg1 {
    arg1 = YES;
    %orig;
}
- (void)setInfoCardButtonVisible:(BOOL)arg1 {
    arg1 = NO;
    %orig;
}
%end
%hook YTMainAppVideoPlayerOverlayViewController
- (void)adjustPlayerBarPositionForRelatedVideos {
}
%end
%end

%group gDisableVideoEndscreenPopups
%hook YTCreatorEndscreenView
- (id)initWithFrame:(CGRect)arg1 {
    return NULL;
}
%end
%end

%group gDisableYouTubeKids
%hook YTWatchMetadataAppPromoCell
- (id)initWithFrame:(CGRect)arg1 {
    return NULL;
}
%end
%hook YTHUDMessageView
- (id)initWithMessage:(id)arg1 dismissHandler:(id)arg2 {
    return NULL;
}
%end
%hook YTNGWatchMiniBarViewController
- (id)miniplayerRenderer {
    return NULL;
}
%end
%hook YTWatchMiniBarViewController
- (id)miniplayerRenderer {
    return NULL;
}
%end
%end

%group gDisableVoiceSearch
%hook YTSearchTextField
- (void)setVoiceSearchEnabled:(BOOL)arg1 {
    arg1 = NO;
	%orig;
}
%end
%hook YTSearchViewController
- (void)viewDidLoad {
    %orig();
    MSHookIvar<UIButton *>(self, "_voiceButton").enabled = NO;
    MSHookIvar<UIButton *>(self, "_voiceButton").frame = CGRectMake(0, 0, 0, 0);
}
%end
%end

%group gDisableHints
%hook YTSettings
- (BOOL)areHintsDisabled {
	return YES;
}
- (void)setHintsDisabled:(BOOL)arg1 {
    arg1 = YES;
    %orig;
}
%end
%hook YTUserDefaults
- (BOOL)areHintsDisabled {
	return YES;
}
- (void)setHintsDisabled:(BOOL)arg1 {
    arg1 = YES;
    %orig;
}
%end
%end

%group gHideExploreTab
%hook YTPivotBarView
- (void)layoutSubviews {
	%orig();
	MSHookIvar<YTPivotBarItemView *>(self, "_itemView2").hidden = YES;
}
- (YTPivotBarItemView *)itemView2 {
	return 1 ? 0 : %orig;
}
%end
%end

%group gHideUploadTab
%hook YTPivotBarView
- (void)layoutSubviews {
	%orig();
	MSHookIvar<YTPivotBarItemView *>(self, "_itemView3").hidden = YES;
}
- (YTPivotBarItemView *)itemView3 {
	return 1 ? 0 : %orig;
}
%end
%end

%group gHideSubscriptionsTab
%hook YTPivotBarView
- (void)layoutSubviews {
	%orig();
	MSHookIvar<YTPivotBarItemView *>(self, "_itemView4").hidden = YES;
}
- (YTPivotBarItemView *)itemView4 {
	return 1 ? 0 : %orig;
}
%end
%end

%group gHideLibraryTab
%hook YTPivotBarView
- (void)layoutSubviews {
	%orig();
	MSHookIvar<YTPivotBarItemView *>(self, "_itemView5").hidden = YES;
}
- (YTPivotBarItemView *)itemView5 {
	return 1 ? 0 : %orig;
}
%end
%end

%group gDisableDoubleTapToSkip
%hook YTDoubleTapToSeekController
- (void)enableDoubleTapToSeek:(BOOL)arg1 {
    arg1 = NO;
    %orig;
}
- (void)showDoubleTapToSeekEducationView:(BOOL)arg1 {
    arg1 = NO;
    %orig;
}
%end
%hook YTSettings
- (BOOL)doubleTapToSeekEnabled {
    return NO;
}
%end
%end

%group gHideOverlayDarkBackground
%hook YTMainAppVideoPlayerOverlayView
- (void)setBackgroundVisible:(BOOL)arg1 {
    arg1 = NO;
	%orig;
}
%end
%end

%group gAlwaysShowPlayerBar
%hook YTPlayerBarController
- (void)setPlayerViewLayout:(int)arg1 {
    arg1 = 2;
    %orig;
} 
%end
%hook YTRelatedVideosViewController
- (BOOL)isEnabled {
    return NO;
}
- (void)setEnabled:(BOOL)arg1 {
    arg1 = NO;
	%orig;
}
%end
%hook YTFullscreenEngagementOverlayView
- (BOOL)isEnabled {
    return NO;
} 
- (void)setEnabled:(BOOL)arg1 {
    arg1 = NO;
    %orig;
} 
%end
%hook YTFullscreenEngagementOverlayController
- (BOOL)isEnabled {
    return NO;
}
- (void)setEnabled:(BOOL)arg1 {
    arg1 = NO;
    %orig;
}
%end
%hook YTMainAppVideoPlayerOverlayView
- (void)setInfoCardButtonHidden:(BOOL)arg1 {
    arg1 = YES;
    %orig;
}
- (void)setInfoCardButtonVisible:(BOOL)arg1 {
    arg1 = NO;
    %orig;
}
%end
%hook YTMainAppVideoPlayerOverlayViewController
- (void)adjustPlayerBarPositionForRelatedVideos {
}
%end
%end

%group gEnableiPadStyleOniPhone
%hook UIDevice
- (long long)userInterfaceIdiom {
    return YES;
} 
%end
%hook UIStatusBarStyleAttributes
- (long long)idiom {
    return NO;
} 
%end
%hook UIKBTree
- (long long)nativeIdiom {
    return NO;
} 
%end
%hook UIKBRenderer
- (long long)assetIdiom {
    return NO;
} 
%end
%end

%group gHidePreviousButtonInOverlay
%hook YTMainAppControlsOverlayView
- (void)layoutSubviews {
	%orig();
	MSHookIvar<YTMainAppControlsOverlayView *>(self, "_previousButton").hidden = YES;
}
%end
%end

%group gHideNextButtonInOverlay
%hook YTMainAppControlsOverlayView
- (void)layoutSubviews {
	%orig();
	MSHookIvar<YTMainAppControlsOverlayView *>(self, "_nextButton").hidden = YES;
}
%end
%end

%group gDisableVideoAutoPlay
%hook YTPlaybackConfig
- (void)setStartPlayback:(BOOL)arg1 {
	arg1 = NO;
	%orig;
}
%end
%end

%group gHideAutoPlaySwitchInOverlay
%hook YTMainAppControlsOverlayView
- (void)layoutSubviews {
	%orig();
	if(![[self autonavSwitch] isHidden]) [[self autonavSwitch] setHidden:YES];
}
%end
%end

%group gHideCaptionsSubtitlesButtonInOverlay
%hook YTMainAppControlsOverlayView
- (void)layoutSubviews {
	%orig();
    if(![[self closedCaptionsOrSubtitlesButton] isHidden]) [[self closedCaptionsOrSubtitlesButton] setHidden:YES];
}
%end
%end

%group gDisableVideoInfoCards
%hook YTInfoCardDarkTeaserContainerView
- (id)initWithFrame:(CGRect)arg1 {
    return NULL;
}
- (BOOL)isVisible {
    return NO;
}
%end
%hook YTInfoCardTeaserContainerView
- (id)initWithFrame:(CGRect)arg1 {
    return NULL;
}
- (BOOL)isVisible {
    return NO;
}
%end
%hook YTSimpleInfoCardDarkTeaserView
- (id)initWithFrame:(CGRect)arg1 {
    return NULL;
}
%end
%hook YTSimpleInfoCardTeaserView
- (id)initWithFrame:(CGRect)arg1 {
    return NULL;
}
%end
%hook YTPaidContentViewController
- (id)initWithParentResponder:(id)arg1 paidContentRenderer:(id)arg2 enableNewPaidProductDisclosure:(BOOL)arg3 {
    arg2 = NULL;
    arg3 = NO;
    return %orig;
}
%end
%hook YTPaidContentOverlayView
- (id)initWithParentResponder:(id)arg1 paidContentRenderer:(id)arg2 enableNewPaidProductDisclosure:(BOOL)arg3 {
    arg2 = NULL;
    arg3 = NO;
    return %orig;
}
%end
%end

%group gNoSearchButton
%hook YTRightNavigationButtons
- (void)layoutSubviews {
	%orig();
	if(![[self searchButton] isHidden]) [[self searchButton] setHidden:YES];
}
%end
%end

%group gHideTabBarLabels
%hook YTPivotBarItemView
- (void)layoutSubviews {
    %orig();
    [[self navigationButton] setTitle:@"" forState:UIControlStateNormal];
    [[self navigationButton] setTitle:@"" forState:UIControlStateSelected];
}
%end
%end

%group gHideChannelWatermark
%hook YTAnnotationsViewController
- (void)loadFeaturedChannelWatermark {
}
%end
%end

%group gHideShortsCameraButton
%hook YTReelWatchPlaybackOverlayView
- (void)layoutSubviews {
	%orig();
	MSHookIvar<YTQTMButton *>(self, "_cameraOrSearchButton").hidden = YES;
}
%end
%end

%group gHideShortsMoreActionsButton
%hook YTReelWatchPlaybackOverlayView
- (void)layoutSubviews {
	%orig();
	MSHookIvar<YTQTMButton *>(self, "_overflowButton").hidden = YES;
}
%end
%end

%group gHideShortsLikeButton
%hook YTReelWatchPlaybackOverlayView
- (void)layoutSubviews {
	%orig();
	MSHookIvar<YTQTMButton *>(self, "_reelLikeButton").hidden = YES;
}
%end
%end

%group gHideShortsDislikeButton
%hook YTReelWatchPlaybackOverlayView
- (void)layoutSubviews {
	%orig();
	MSHookIvar<YTQTMButton *>(self, "_reelDislikeButton").hidden = YES;
}
%end
%end

%group gHideShortsCommentsButton
%hook YTReelWatchPlaybackOverlayView
- (void)layoutSubviews {
	%orig();
	MSHookIvar<YTQTMButton *>(self, "_viewCommentButton").hidden = YES;
}
%end
%end

%group gHideShortsShareButton
%hook YTReelWatchPlaybackOverlayView
- (void)layoutSubviews {
	%orig();
	MSHookIvar<YTQTMButton *>(self, "_shareButton").hidden = YES;
}
%end
%end

%group gColourOptions
%hook UIView
- (void)setBackgroundColor:(UIColor *)color {
    if([self.nextResponder isKindOfClass:NSClassFromString(@"YTPivotBarView")]) {
        color = hexColour();
    }
    if([self.nextResponder isKindOfClass:NSClassFromString(@"YTSlideForActionsView")]) {
        color = hexColour();
    }
    if([self.nextResponder isKindOfClass:NSClassFromString(@"YTChipCloudCell")]) {
        color = hexColour();
    }
    if([self.nextResponder isKindOfClass:NSClassFromString(@"YTEngagementPanelView")]) {
        color = hexColour();
    }
    if([self.nextResponder isKindOfClass:NSClassFromString(@"YTPlaylistPanelProminentThumbnailVideoCell")]) {
        color = hexColour();
    }
    if([self.nextResponder isKindOfClass:NSClassFromString(@"YTPlaylistHeaderView")]) {
        color = hexColour();
    }
    if([self.nextResponder isKindOfClass:NSClassFromString(@"YTAsyncCollectionView")]) {
        color = hexColour();
    }
    if([self.nextResponder isKindOfClass:NSClassFromString(@"YTLinkCell")]) {
        color = hexColour();
    }
    if([self.nextResponder isKindOfClass:NSClassFromString(@"YTMessageCell")]) {
        color = hexColour();
    }
    if([self.nextResponder isKindOfClass:NSClassFromString(@"YTSearchView")]) {
        color = hexColour();
    }
    if([self.nextResponder isKindOfClass:NSClassFromString(@"YTDrawerAvatarCell")]) {
        color = hexColour();
    }
    if([self.nextResponder isKindOfClass:NSClassFromString(@"YTFeedHeaderView")]) {
        color = hexColour();
    }
    if([self.nextResponder isKindOfClass:NSClassFromString(@"YCHLiveChatTextCell")]) {
        color = hexColour();
    }
    if([self.nextResponder isKindOfClass:NSClassFromString(@"YCHLiveChatViewerEngagementCell")]) {
        color = hexColour();
    }
    if([self.nextResponder isKindOfClass:NSClassFromString(@"YTCommentsHeaderView")]) {
        color = hexColour();
    }
    if([self.nextResponder isKindOfClass:NSClassFromString(@"YCHLiveChatView")]) {
        color = hexColour();
    }
    if([self.nextResponder isKindOfClass:NSClassFromString(@"YCHLiveChatTickerViewController")]) {
        color = hexColour();
    }
    %orig;
}
- (void)layoutSubviews {
    %orig();
    if([self.nextResponder isKindOfClass:NSClassFromString(@"_ASDisplayView")]) {
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.0];
    }
}
%end
%hook YTAsyncCollectionView
- (void)setBackgroundColor:(UIColor *)color {
    if([self.nextResponder isKindOfClass:NSClassFromString(@"YTRelatedVideosCollectionViewController")]) {
        color = [[UIColor blackColor] colorWithAlphaComponent:0.0];
    } else if([self.nextResponder isKindOfClass:NSClassFromString(@"YTFullscreenMetadataHighlightsCollectionViewController")]) {
        color = [[UIColor blackColor] colorWithAlphaComponent:0.0];
    } else {
        color = hexColour();
    }
    %orig;
}
%end
%hook YTPivotBarView
- (void)setBackgroundColor:(UIColor *)color {
    color = hexColour();
    %orig;
}
%end
%hook YTHeaderView
- (void)setBackgroundColor:(UIColor *)color {
    color = hexColour();
    %orig;
}
%end
%hook YTSubheaderContainerView
- (void)setBackgroundColor:(UIColor *)color {
    color = hexColour();
    %orig;
}
%end
%hook YTAppView
- (void)setBackgroundColor:(UIColor *)color {
    color = hexColour();
    %orig;
}
%end
%hook YTChannelListSubMenuView
- (void)setBackgroundColor:(UIColor *)color {
    color = hexColour();
    %orig;
}
%end
%hook YTSlideForActionsView
- (void)setBackgroundColor:(UIColor *)color {
    color = hexColour();
    %orig;
}
%end
%hook YTPageView
- (void)setBackgroundColor:(UIColor *)color {
    color = hexColour();
    %orig;
}
%end
%hook YTWatchView
- (void)setBackgroundColor:(UIColor *)color {
    color = hexColour();
    %orig;
}
%end
%hook YTPlaylistMiniBarView
- (void)setBackgroundColor:(UIColor *)color {
    color = hexColour();
    %orig;
}
%end
%hook YTEngagementPanelHeaderView
- (void)setBackgroundColor:(UIColor *)color {
    color = hexColour();
    %orig;
}
%end
%hook YTPlaylistPanelControlsView
- (void)setBackgroundColor:(UIColor *)color {
    color = hexColour();
    %orig;
}
%end
%hook YTHorizontalCardListView
- (void)setBackgroundColor:(UIColor *)color {
    color = hexColour();
    %orig;
}
%end
%hook YTWatchMiniBarView
- (void)setBackgroundColor:(UIColor *)color {
    color = hexColour();
    %orig;
}
%end
%hook YTCreateCommentAccessoryView
- (void)setBackgroundColor:(UIColor *)color {
    color = hexColour();
    %orig;
}
%end
%hook YTCreateCommentTextView
- (void)setBackgroundColor:(UIColor *)color {
    color = hexColour();
    %orig;
}
%end
%hook YTSearchView
- (void)setBackgroundColor:(UIColor *)color {
    color = hexColour();
    %orig;
}
%end
%hook YTVideoView
- (void)setBackgroundColor:(UIColor *)color {
    color = hexColour();
    %orig;
}
%end
%hook YTSearchBoxView
- (void)setBackgroundColor:(UIColor *)color {
    color = hexColour();
    %orig;
}
%end
%hook YTTabTitlesView
- (void)setBackgroundColor:(UIColor *)color {
    color = hexColour();
    %orig;
}
%end
%hook YTPrivacyTosFooterView
- (void)setBackgroundColor:(UIColor *)color {
    color = hexColour();
    %orig;
}
%end
%hook YTOfflineStorageUsageView
- (void)setBackgroundColor:(UIColor *)color {
    color = hexColour();
    %orig;
}
%end
%hook YTInlineSignInView
- (void)setBackgroundColor:(UIColor *)color {
    color = hexColour();
    %orig;
}
%end
%hook YTFeedChannelFilterHeaderView
- (void)setBackgroundColor:(UIColor *)color {
    color = hexColour();
    %orig;
}
%end
%hook YCHLiveChatView
- (void)setBackgroundColor:(UIColor *)color {
    color = hexColour();
    %orig;
}
%end
%hook YCHLiveChatActionPanelView
- (void)setBackgroundColor:(UIColor *)color {
    color = hexColour();
    %orig;
}
%end
%hook YTEmojiTextView
- (void)setBackgroundColor:(UIColor *)color {
    color = hexColour();
    %orig;
}
%end
%hook YTTopAlignedView
- (void)setBackgroundColor:(UIColor *)color {
    color = hexColour();
    %orig;
}
- (void)layoutSubviews {
    %orig();
    MSHookIvar<YTTopAlignedView *>(self, "_contentView").backgroundColor = hexColour();
}
%end
%hook GOODialogView
- (void)setBackgroundColor:(UIColor *)color {
    color = hexColour();
    %orig;
}
%end
%hook YTNavigationBar
- (void)setBackgroundColor:(UIColor *)color {
    color = hexColour();
    %orig;
}
- (void)setBarTintColor:(UIColor *)color {
    color = hexColour();
    %orig;
}
%end
%hook YTChannelMobileHeaderView
- (void)setBackgroundColor:(UIColor *)color {
    color = hexColour();
    %orig;
}
%end
%hook YTChannelSubMenuView
- (void)setBackgroundColor:(UIColor *)color {
    color = hexColour();
    %orig;
}
%end
%hook YTWrapperSplitView
- (void)setBackgroundColor:(UIColor *)color {
    color = hexColour();
    %orig;
}
%end
%hook YTReelShelfCell
- (void)setBackgroundColor:(UIColor *)color {
    color = hexColour();
    %orig;
}
%end
%hook YTReelShelfItemView
- (void)setBackgroundColor:(UIColor *)color {
    color = hexColour();
    %orig;
}
%end
%hook YTReelShelfView
- (void)setBackgroundColor:(UIColor *)color {
    color = hexColour();
    %orig;
}
%end
%hook YTCommentView
- (void)setBackgroundColor:(UIColor *)color {
    color = hexColour();
    %orig;
}
%end
%hook YTChannelListSubMenuAvatarView
- (void)setBackgroundColor:(UIColor *)color {
    color = hexColour();
    %orig;
}
%end
%hook YCHLiveChatBannerCell
- (void)layoutSubviews {
	%orig();
	MSHookIvar<UIImageView *>(self, "_bannerContainerImageView").hidden = YES;
    MSHookIvar<UIView *>(self, "_bannerContainerView").backgroundColor = hexColour();
}
%end
%hook YTSearchSuggestionCollectionViewCell
- (void)updateColors {
}
%end
%end

%group gAutoFullScreen
%hook YTPlayerViewController
- (void)loadWithPlayerTransition:(id)arg1 playbackConfig:(id)arg2 {
    %orig();
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.75 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        YTWatchController *watchController = [self valueForKey:@"_UIDelegate"];
        [watchController showFullScreen];
    });
}
%end
%end

%group gHideYouTubeLogo
%hook YTHeaderLogoController
- (YTHeaderLogoController *)init {
    return NULL;
}
%end
%end

%group gEnableEnhancedSearchBar
%hook YTColdConfig
- (BOOL)isEnhancedSearchBarEnabled {
    return YES;
}
%end
%end

%group gHideTabBar
%hook YTPivotBarView
- (BOOL)isHidden {
    return YES;
}
- (void)layoutSubviews {
	%orig();
    MSHookIvar<YTPivotBarItemView *>(self, "_itemView1").hidden = YES;
    MSHookIvar<YTPivotBarItemView *>(self, "_itemView2").hidden = YES;
    MSHookIvar<YTPivotBarItemView *>(self, "_itemView3").hidden = YES;
    MSHookIvar<YTPivotBarItemView *>(self, "_itemView4").hidden = YES;
	MSHookIvar<YTPivotBarItemView *>(self, "_itemView5").hidden = YES;
}
- (YTPivotBarItemView *)itemView1 {
	return 1 ? 0 : %orig;
}
- (YTPivotBarItemView *)itemView2 {
	return 1 ? 0 : %orig;
}
- (YTPivotBarItemView *)itemView3 {
	return 1 ? 0 : %orig;
}
- (YTPivotBarItemView *)itemView4 {
	return 1 ? 0 : %orig;
}
- (YTPivotBarItemView *)itemView5 {
	return 1 ? 0 : %orig;
}
%end
%end

BOOL sponsorBlockEnabled;
NSMutableArray *jsonSponsorValues = [[NSMutableArray alloc] init];
NSMutableArray *jsonSelfPromoValues = [[NSMutableArray alloc] init];
NSMutableArray *jsonInteractionValues = [[NSMutableArray alloc] init];
NSMutableArray *jsonIntroValues = [[NSMutableArray alloc] init];
NSMutableArray *jsonOutroValues = [[NSMutableArray alloc] init];
NSMutableArray *jsonPreviewValues = [[NSMutableArray alloc] init];
NSMutableArray *jsonMusicOffTopicValues = [[NSMutableArray alloc] init];

%hook YTPlayerViewController
- (void)playbackController:(id)arg1 didActivateVideo:(id)arg2 withPlaybackData:(id)arg3 {
    sponsorBlockEnabled = 0;
    [jsonSponsorValues removeAllObjects];
    [jsonSelfPromoValues removeAllObjects];
    [jsonInteractionValues removeAllObjects];
    [jsonIntroValues removeAllObjects];
    [jsonOutroValues removeAllObjects];
    [jsonPreviewValues removeAllObjects];
    [jsonMusicOffTopicValues removeAllObjects];
    %orig();
    NSURLSessionConfiguration *dataConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *dataManager = [[AFURLSessionManager alloc] initWithSessionConfiguration:dataConfiguration];

    NSString *options = @"[%22sponsor%22,%22selfpromo%22,%22interaction%22,%22intro%22,%22outro%22,%22preview%22,%22music_offtopic%22]";
    NSString *apiUrl = [NSString stringWithFormat:@"https://sponsor.ajay.app/api/skipSegments?videoID=%@&categories=%@", self.currentVideoID, options];
    NSURL *dataUrl = [NSURL URLWithString:apiUrl];
    NSURLRequest *apiRequest = [NSURLRequest requestWithURL:dataUrl];

    NSURLSessionDataTask *dataTask = [dataManager dataTaskWithRequest:apiRequest uploadProgress:nil downloadProgress:nil completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        if (!error) {
            NSMutableDictionary *jsonResponse = responseObject;
            if ([NSJSONSerialization isValidJSONObject:jsonResponse]) {
                sponsorBlockEnabled = 1;
                for (NSMutableDictionary *jsonDictionary in jsonResponse) {
                    if ([[jsonDictionary objectForKey:@"category"] isEqual:@"sponsor"]) {
                        [jsonSponsorValues addObject:[NSNumber numberWithFloat:[[jsonDictionary objectForKey:@"segment"][0] floatValue]]];
                        [jsonSponsorValues addObject:[NSNumber numberWithFloat:[[jsonDictionary objectForKey:@"segment"][1] floatValue]]];
                    }
                    if ([[jsonDictionary objectForKey:@"category"] isEqual:@"selfpromo"]) {
                        [jsonSelfPromoValues addObject:[NSNumber numberWithFloat:[[jsonDictionary objectForKey:@"segment"][0] floatValue]]];
                        [jsonSelfPromoValues addObject:[NSNumber numberWithFloat:[[jsonDictionary objectForKey:@"segment"][1] floatValue]]];
                    }
                    if ([[jsonDictionary objectForKey:@"category"] isEqual:@"interaction"]) {
                        [jsonInteractionValues addObject:[NSNumber numberWithFloat:[[jsonDictionary objectForKey:@"segment"][0] floatValue]]];
                        [jsonInteractionValues addObject:[NSNumber numberWithFloat:[[jsonDictionary objectForKey:@"segment"][1] floatValue]]];
                    }
                    if ([[jsonDictionary objectForKey:@"category"] isEqual:@"intro"]) {
                        [jsonIntroValues addObject:[NSNumber numberWithFloat:[[jsonDictionary objectForKey:@"segment"][0] floatValue]]];
                        [jsonIntroValues addObject:[NSNumber numberWithFloat:[[jsonDictionary objectForKey:@"segment"][1] floatValue]]];
                    }
                    if ([[jsonDictionary objectForKey:@"category"] isEqual:@"outro"]) {
                        [jsonOutroValues addObject:[NSNumber numberWithFloat:[[jsonDictionary objectForKey:@"segment"][0] floatValue]]];
                        [jsonOutroValues addObject:[NSNumber numberWithFloat:[[jsonDictionary objectForKey:@"segment"][1] floatValue]]];
                    }
                    if ([[jsonDictionary objectForKey:@"category"] isEqual:@"preview"]) {
                        [jsonPreviewValues addObject:[NSNumber numberWithFloat:[[jsonDictionary objectForKey:@"segment"][0] floatValue]]];
                        [jsonPreviewValues addObject:[NSNumber numberWithFloat:[[jsonDictionary objectForKey:@"segment"][1] floatValue]]];
                    }
                    if ([[jsonDictionary objectForKey:@"category"] isEqual:@"music_offtopic"]) {
                        [jsonMusicOffTopicValues addObject:[NSNumber numberWithFloat:[[jsonDictionary objectForKey:@"segment"][0] floatValue]]];
                        [jsonMusicOffTopicValues addObject:[NSNumber numberWithFloat:[[jsonDictionary objectForKey:@"segment"][1] floatValue]]];
                    }
                }
            } else {
                sponsorBlockEnabled = 0;
            }
        }
    }];
    [dataTask resume];
}
- (void)singleVideo:(id)video currentVideoTimeDidChange:(YTSingleVideoTime *)time {
    %orig();
    if (sponsorBlockEnabled == 1) {
        @try {
            if ([[NSUserDefaults standardUserDefaults] integerForKey:@"kSponsorSegmentedInt"]) {
                if ([[NSUserDefaults standardUserDefaults] integerForKey:@"kSponsorSegmentedInt"] == 1) {
                    if (self.currentVideoMediaTime >= [[jsonSponsorValues objectAtIndex:0] floatValue] && self.currentVideoMediaTime <= [[jsonSponsorValues objectAtIndex:1] floatValue]) {
                        [self scrubToTime:[[jsonSponsorValues objectAtIndex:1] floatValue]];
                    }
                }
            }
        }
        @catch (NSException *exception) {
        }
        @try {
            if ([[NSUserDefaults standardUserDefaults] integerForKey:@"kSelfPromoSegmentedInt"]) {
                if ([[NSUserDefaults standardUserDefaults] integerForKey:@"kSelfPromoSegmentedInt"] == 1) {
                    if (self.currentVideoMediaTime >= [[jsonSelfPromoValues objectAtIndex:0] floatValue] && self.currentVideoMediaTime <= [[jsonSelfPromoValues objectAtIndex:1] floatValue]) {
                        [self scrubToTime:[[jsonSelfPromoValues objectAtIndex:1] floatValue]];
                    }
                }
            }
        }
        @catch (NSException *exception) {
        }
        @try {
            if ([[NSUserDefaults standardUserDefaults] integerForKey:@"kInteractionSegmentedInt"]) {
                if ([[NSUserDefaults standardUserDefaults] integerForKey:@"kInteractionSegmentedInt"] == 1) {
                    if (self.currentVideoMediaTime >= [[jsonInteractionValues objectAtIndex:0] floatValue] && self.currentVideoMediaTime <= [[jsonInteractionValues objectAtIndex:1] floatValue]) {
                        [self scrubToTime:[[jsonInteractionValues objectAtIndex:1] floatValue]];
                    }
                }
            }
        }
        @catch (NSException *exception) {
        }
        @try {
            if ([[NSUserDefaults standardUserDefaults] integerForKey:@"kIntroSegmentedInt"]) {
                if ([[NSUserDefaults standardUserDefaults] integerForKey:@"kIntroSegmentedInt"] == 1) {
                    if (self.currentVideoMediaTime >= [[jsonIntroValues objectAtIndex:0] floatValue] && self.currentVideoMediaTime <= [[jsonIntroValues objectAtIndex:1] floatValue]) {
                        [self scrubToTime:[[jsonIntroValues objectAtIndex:1] floatValue]];
                    }
                }
            }
        }
        @catch (NSException *exception) {
        }
        @try {
            if ([[NSUserDefaults standardUserDefaults] integerForKey:@"kOutroSegmentedInt"]) {
                if ([[NSUserDefaults standardUserDefaults] integerForKey:@"kOutroSegmentedInt"] == 1) {
                    if (self.currentVideoMediaTime >= [[jsonOutroValues objectAtIndex:0] floatValue] && self.currentVideoMediaTime <= [[jsonOutroValues objectAtIndex:1] floatValue]) {
                        [self scrubToTime:[[jsonOutroValues objectAtIndex:1] floatValue]];
                    }
                }
            }
        }
        @catch (NSException *exception) {
        }
        @try {
            if ([[NSUserDefaults standardUserDefaults] integerForKey:@"kPreviewSegmentedInt"]) {
                if ([[NSUserDefaults standardUserDefaults] integerForKey:@"kPreviewSegmentedInt"] == 1) {
                    if (self.currentVideoMediaTime >= [[jsonPreviewValues objectAtIndex:0] floatValue] && self.currentVideoMediaTime <= [[jsonPreviewValues objectAtIndex:1] floatValue]) {
                        [self scrubToTime:[[jsonPreviewValues objectAtIndex:1] floatValue]];
                    }
                }
            }
        }
        @catch (NSException *exception) {
        }
        @try {
            if ([[NSUserDefaults standardUserDefaults] integerForKey:@"kMusicOffTopicSegmentedInt"]) {
                if ([[NSUserDefaults standardUserDefaults] integerForKey:@"kMusicOffTopicSegmentedInt"] == 1) {
                    if (self.currentVideoMediaTime >= [[jsonMusicOffTopicValues objectAtIndex:0] floatValue] && self.currentVideoMediaTime <= [[jsonMusicOffTopicValues objectAtIndex:1] floatValue]) {
                        [self scrubToTime:[[jsonMusicOffTopicValues objectAtIndex:1] floatValue]];
                    }
                }
            }
        }
        @catch (NSException *exception) {
        }
    }
}
%end

int selectedTabIndex = 0;

%hook YTPivotBarViewController
- (void)viewDidAppear:(BOOL)animated {
    %orig();
    if ([[NSUserDefaults standardUserDefaults] integerForKey:@"kStartupPageInt"]) {
        int selectedTab = [[NSUserDefaults standardUserDefaults] integerForKey:@"kStartupPageInt"];
        if (selectedTab == 0 && selectedTabIndex == 0) {
            [self selectItemWithPivotIdentifier:@"FEwhat_to_watch"];
            selectedTabIndex = 1;
        }
        if (selectedTab == 1 && selectedTabIndex == 0) {
            [self selectItemWithPivotIdentifier:@"FEexplore"];
            selectedTabIndex = 1;
        }
        if (selectedTab == 2 && selectedTabIndex == 0) {
            [self selectItemWithPivotIdentifier:@"FEshorts"];
            selectedTabIndex = 1;
        }
        if (selectedTab == 3 && selectedTabIndex == 0) {
            [self selectItemWithPivotIdentifier:@"FEuploads"];
            selectedTabIndex = 1;
        }
        if (selectedTab == 4 && selectedTabIndex == 0) {
            [self selectItemWithPivotIdentifier:@"FEsubscriptions"];
            selectedTabIndex = 1;
        }
        if (selectedTab == 5 && selectedTabIndex == 0) {
            [self selectItemWithPivotIdentifier:@"FElibrary"];
            selectedTabIndex = 1;
        }
        if (selectedTab == 6 && selectedTabIndex == 0) {
            [self selectItemWithPivotIdentifier:@"FEtrending"];
            selectedTabIndex = 1;
        }
    }
}
%end

%hook YTColdConfig
- (BOOL)shouldUseAppThemeSetting {
    return YES;
}
- (BOOL)enableYouthereCommandsOnIos {
    return NO;
}
%end

%hook YTYouThereController
- (BOOL)shouldShowYouTherePrompt {
    return NO;
}
%end

%hook YTCommerceEventGroupHandler
- (void)addEventHandlers {
}
%end

%hook YTInterstitialPromoEventGroupHandler
- (void)addEventHandlers {
}
%end

%hook YTIShowFullscreenInterstitialCommand
- (BOOL)shouldThrottleInterstitial {
    return YES;
}
%end

%hook YTSettings
- (BOOL)allowAudioOnlyManualQualitySelection {
    return YES;
}
%end

%hook YTUpsell
- (BOOL)isCounterfactual {
    return YES;
}
%end

%ctor {
    @autoreleasepool {
        if ([[NSUserDefaults standardUserDefaults] objectForKey:@"kEnableNoVideoAds"] == nil) {
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"kEnableNoVideoAds"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"kEnableNoVideoAds"] == YES) %init(gNoVideoAds);
        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"kEnableBackgroundPlayback"] == YES) %init(gBackgroundPlayback);
        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"kNoCastButton"] == YES) %init(gNoCastButton);
        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"kNoNotificationButton"] == YES) %init(gNoNotificationButton);
        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"kAllowHDOnCellularData"] == YES) %init(gAllowHDOnCellularData);
        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"kDisableVideoEndscreenPopups"] == YES) %init(gDisableVideoEndscreenPopups);
        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"kDisableYouTubeKidsPopup"] == YES) %init(gDisableYouTubeKids);
        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"kEnableExtraSpeedOptions"] == YES) %init(gExtraSpeedOptions);
        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"kDisableVoiceSearch"] == YES) %init(gDisableVoiceSearch);
        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"kDisableHints"] == YES) %init(gDisableHints);
        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"kHideTabBarLabels"] == YES) %init(gHideTabBarLabels);
        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"kHideExploreTab"] == YES) %init(gHideExploreTab);
        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"kHideUploadTab"] == YES) %init(gHideUploadTab);
        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"kHideSubscriptionsTab"] == YES) %init(gHideSubscriptionsTab);
        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"kHideLibraryTab"] == YES) %init(gHideLibraryTab);
        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"kDisableDoubleTapToSkip"] == YES) %init(gDisableDoubleTapToSkip);
        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"kHideOverlayDarkBackground"] == YES) %init(gHideOverlayDarkBackground);
        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"kHidePreviousButtonInOverlay"] == YES) %init(gHidePreviousButtonInOverlay);
        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"kHideNextButtonInOverlay"] == YES) %init(gHideNextButtonInOverlay);
        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"kDisableVideoAutoPlay"] == YES) %init(gDisableVideoAutoPlay);
        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"kHideAutoPlaySwitchInOverlay"] == YES) %init(gHideAutoPlaySwitchInOverlay);
        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"kHideCaptionsSubtitlesButtonInOverlay"] == YES) %init(gHideCaptionsSubtitlesButtonInOverlay);
        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"kDisableVideoInfoCards"] == YES) %init(gDisableVideoInfoCards);
        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"kNoSearchButton"] == YES) %init(gNoSearchButton);
        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"kHideChannelWatermark"] == YES) %init(gHideChannelWatermark);
        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"kHideShortsCameraButton"] == YES) %init(gHideShortsCameraButton);
        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"kHideShortsMoreActionsButton"] == YES) %init(gHideShortsMoreActionsButton);
        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"kHideShortsLikeButton"] == YES) %init(gHideShortsLikeButton);
        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"kHideShortsDislikeButton"] == YES) %init(gHideShortsDislikeButton);
        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"kHideShortsCommentsButton"] == YES) %init(gHideShortsCommentsButton);
        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"kHideShortsShareButton"] == YES) %init(gHideShortsShareButton);
        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"kAutoFullScreen"] == YES) %init(gAutoFullScreen);
        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"kHideYouTubeLogo"] == YES) %init(gHideYouTubeLogo);
        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"kEnableEnhancedSearchBar"] == YES) %init(gEnableEnhancedSearchBar);
        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"kHideTabBar"] == YES) %init(gHideTabBar);
        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"kEnableiPadStyleOniPhone"] == NO & [[NSUserDefaults standardUserDefaults] boolForKey:@"kShowStatusBarInOverlay"] == YES) {
            %init(gShowStatusBarInOverlay);
        }
        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"kShowStatusBarInOverlay"] == YES & [[NSUserDefaults standardUserDefaults] boolForKey:@"kEnableiPadStyleOniPhone"] == YES or [[NSUserDefaults standardUserDefaults] boolForKey:@"kEnableiPadStyleOniPhone"] == YES & [[NSUserDefaults standardUserDefaults] boolForKey:@"kShowStatusBarInOverlay"] == NO) {
            %init(gEnableiPadStyleOniPhone);
        }
        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"kAlwaysShowPlayerBar"] == NO & [[NSUserDefaults standardUserDefaults] boolForKey:@"kDisableRelatedVideosInOverlay"] == YES) {
            %init(gDisableRelatedVideosInOverlay);
        }
        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"kAlwaysShowPlayerBar"] == YES & [[NSUserDefaults standardUserDefaults] boolForKey:@"kDisableRelatedVideosInOverlay"] == YES or [[NSUserDefaults standardUserDefaults] boolForKey:@"kAlwaysShowPlayerBar"] == YES & [[NSUserDefaults standardUserDefaults] boolForKey:@"kDisableRelatedVideosInOverlay"] == NO) {
            %init(gAlwaysShowPlayerBar);
        }
        NSData *colorData = [[NSUserDefaults standardUserDefaults] objectForKey:@"kYTRebornColourOptionsVThree"];
        NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingFromData:colorData error:nil];
        [unarchiver setRequiresSecureCoding:NO];
        NSString *hexString = [unarchiver decodeObjectForKey:NSKeyedArchiveRootObjectKey];
        if(hexString != nil) {
            %init(gColourOptions);
        }
        %init(_ungrouped);
    }
}