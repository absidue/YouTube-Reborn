TARGET := iphone:clang:14.4:13.0
INSTALL_TARGET_PROCESSES = YouTube
GO_EASY_ON_ME = 1

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = YouTubeReborn
YouTubeReborn_FILES = Tweak.xm $(shell find Controllers -name '*.m') $(shell find AFNetworking -name '*.m') $(shell find Jailbreak-Detection-Lib -name '*.m') $(shell find Alderis -name '*.swift')
YouTubeReborn_CFLAGS = -fobjc-arc
YouTubeReborn_FRAMEWORKS = UIKit Foundation AVFoundation AVKit Photos AudioToolbox CFNetwork CoreFoundation CoreGraphics CoreMedia CoreText CoreVideo OpenGLES QuartzCore Security VideoToolbox
YouTubeReborn_EXTRA_FRAMEWORKS = ffmpegkit libavcodec libavdevice libavfilter libavformat libavutil libswresample libswscale MobileVLCKit
ARCHS = arm64

include $(THEOS_MAKE_PATH)/tweak.mk
include $(THEOS_MAKE_PATH)/aggregate.mk
