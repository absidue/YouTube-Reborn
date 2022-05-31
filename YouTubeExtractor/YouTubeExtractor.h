#import <Foundation/Foundation.h>

@interface YouTubeExtractor : NSObject
+ (NSMutableDictionary *)youtubeiAndroidPlayerRequest :(NSString *)videoID;
+ (NSMutableDictionary *)youtubeiAndroidSearchRequest :(NSString *)videoID;
+ (NSMutableDictionary *)youtubeiiOSPlayerRequest :(NSString *)videoID;
+ (NSMutableDictionary *)returnyoutubedislikesApiRequest :(NSString *)videoID;
@end