echo "Converting Tweak For JB Frameworks"
rm -rf "packages/youtubereborn" "packages/youtuberebornjb.deb"
dpkg-deb -R "packages/youtubereborn.deb" "packages/youtubereborn"
$THEOS/toolchain/linux/iphone/bin/install_name_tool -change @rpath/ffmpegkit.framework/ffmpegkit /Library/Frameworks/ffmpegkit.framework/ffmpegkit packages/youtubereborn/Library/MobileSubstrate/DynamicLibraries/YouTubeReborn.dylib
$THEOS/toolchain/linux/iphone/bin/install_name_tool -change @rpath/libavcodec.framework/libavcodec /Library/Frameworks/libavcodec.framework/libavcodec packages/youtubereborn/Library/MobileSubstrate/DynamicLibraries/YouTubeReborn.dylib
$THEOS/toolchain/linux/iphone/bin/install_name_tool -change @rpath/libavdevice.framework/libavdevice /Library/Frameworks/libavdevice.framework/libavdevice packages/youtubereborn/Library/MobileSubstrate/DynamicLibraries/YouTubeReborn.dylib
$THEOS/toolchain/linux/iphone/bin/install_name_tool -change @rpath/libavfilter.framework/libavfilter /Library/Frameworks/libavfilter.framework/libavfilter packages/youtubereborn/Library/MobileSubstrate/DynamicLibraries/YouTubeReborn.dylib
$THEOS/toolchain/linux/iphone/bin/install_name_tool -change @rpath/libavformat.framework/libavformat /Library/Frameworks/libavformat.framework/libavformat packages/youtubereborn/Library/MobileSubstrate/DynamicLibraries/YouTubeReborn.dylib
$THEOS/toolchain/linux/iphone/bin/install_name_tool -change @rpath/libavutil.framework/libavutil /Library/Frameworks/libavutil.framework/libavutil packages/youtubereborn/Library/MobileSubstrate/DynamicLibraries/YouTubeReborn.dylib
$THEOS/toolchain/linux/iphone/bin/install_name_tool -change @rpath/libswresample.framework/libswresample /Library/Frameworks/libswresample.framework/libswresample packages/youtubereborn/Library/MobileSubstrate/DynamicLibraries/YouTubeReborn.dylib
$THEOS/toolchain/linux/iphone/bin/install_name_tool -change @rpath/libswscale.framework/libswscale /Library/Frameworks/libswscale.framework/libswscale packages/youtubereborn/Library/MobileSubstrate/DynamicLibraries/YouTubeReborn.dylib
$THEOS/toolchain/linux/iphone/bin/install_name_tool -change @rpath/MobileVLCKit.framework/MobileVLCKit /Library/Frameworks/MobileVLCKit.framework/MobileVLCKit packages/youtubereborn/Library/MobileSubstrate/DynamicLibraries/YouTubeReborn.dylib
dpkg-deb -b -Zgzip "packages/youtubereborn" "packages/youtuberebornjb.deb"
rm -rf "packages/youtubereborn"
echo "Done"