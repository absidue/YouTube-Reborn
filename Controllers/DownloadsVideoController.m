#import "DownloadsVideoController.h"
#import "DownloadsVLCPlayerController.h"
#import <Photos/Photos.h>
#import "../TheosLinuxFix.h"
#import "../iOS15Fix.h"

NSURL *downloadsPathURL;

@interface DownloadsVideoController ()
@end

@implementation DownloadsVideoController

NSString *documentsDirectory;
NSMutableArray *filePathsVideoArray;
NSMutableArray *filePathsVideoArtworkArray;

- (void)loadView {
	[super loadView];

    [self setupLightDarkModeVideoView];

    if (@available(iOS 15.0, *)) {
    	[self.tableView setSectionHeaderTopPadding:0.0f];
	}

    [self setupVideoArrays];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [filePathsVideoArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"VideoDownloadsTableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:nil];
        cell.textLabel.adjustsFontSizeToFitWidth = true;
        cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
        if (self.traitCollection.userInterfaceStyle == UIUserInterfaceStyleLight) {
            cell.backgroundColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];
            cell.textLabel.textColor = [UIColor blackColor];
        }
        else {
            cell.backgroundColor = [UIColor colorWithRed:0.110 green:0.110 blue:0.118 alpha:1.0];
            cell.textLabel.textColor = [UIColor whiteColor];
        }
        cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
    }
    cell.textLabel.text = [filePathsVideoArray objectAtIndex:indexPath.row];
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {        
    return [UIView new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    NSString *currentFileName = filePathsVideoArray[indexPath.row];
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:currentFileName];
    downloadsPathURL = [NSURL fileURLWithPath:filePath];

    UIAlertController *alertPlayer = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleAlert];

    [alertPlayer addAction:[UIAlertAction actionWithTitle:@"AVPlayer" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        AVPlayerViewController *playerViewController = [AVPlayerViewController new];
        playerViewController.player = [AVPlayer playerWithURL:[NSURL fileURLWithPath:filePath]];
        playerViewController.allowsPictureInPicturePlayback = YES;
        if ([playerViewController respondsToSelector:@selector(setCanStartPictureInPictureAutomaticallyFromInline:)]) {
            playerViewController.canStartPictureInPictureAutomaticallyFromInline = NO;
        }
        [playerViewController.player play];

        [self presentViewController:playerViewController animated:YES completion:nil];
    }]];
    
    [alertPlayer addAction:[UIAlertAction actionWithTitle:@"VLC" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        DownloadsVLCPlayerController *downloadsVLCPlayerController = [[DownloadsVLCPlayerController alloc] init];
        downloadsVLCPlayerController.videoPath = downloadsPathURL;
        UINavigationController *downloadsVLCPlayerControllerView = [[UINavigationController alloc] initWithRootViewController:downloadsVLCPlayerController];
        downloadsVLCPlayerControllerView.modalPresentationStyle = UIModalPresentationFullScreen;

        [self presentViewController:downloadsVLCPlayerControllerView animated:YES completion:nil];
    }]];

    [alertPlayer addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
    }]];

    [self presentViewController:alertPlayer animated:YES completion:nil];
}

- (void)tableView:(UITableView*)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath*)indexPath {
    NSString *currentFileName = filePathsVideoArray[indexPath.row];
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:currentFileName];

    UIAlertController *alertMenu = [UIAlertController alertControllerWithTitle:@"Options" message:nil preferredStyle:UIAlertControllerStyleAlert];

    [alertMenu addAction:[UIAlertAction actionWithTitle:@"Import Video To Camera Roll" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
            NSURL *fileURL = [NSURL fileURLWithPath:filePath];
            [PHAssetChangeRequest creationRequestForAssetFromVideoAtFileURL:fileURL];
        } completionHandler:^(BOOL success, NSError *error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (success) {
                    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Notice" message:@"Video Saved To Camera Roll" preferredStyle:UIAlertControllerStyleAlert];
                                        
                    [alert addAction:[UIAlertAction actionWithTitle:@"Okay" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                    }]];

                    [self presentViewController:alert animated:YES completion:nil];
                } else{
                    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Notice" message:@"Save To Camera Roll Failed \nMake Sure To Give Camera Roll Permission To YouTube In The iOS Settings App" preferredStyle:UIAlertControllerStyleAlert];
                                        
                    [alert addAction:[UIAlertAction actionWithTitle:@"Okay" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                    }]];

                    [self presentViewController:alert animated:YES completion:nil];
                }
            });
        }];
    }]];

    [alertMenu addAction:[UIAlertAction actionWithTitle:@"Delete Video" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        NSFileManager *fm = [[NSFileManager alloc] init];
        [fm removeItemAtPath:filePath error:nil];

        UIAlertController *alertDeleted = [UIAlertController alertControllerWithTitle:@"Notice" message:@"Video Successfully Deleted" preferredStyle:UIAlertControllerStyleAlert];

        [alertDeleted addAction:[UIAlertAction actionWithTitle:@"Okay" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [filePathsVideoArray removeAllObjects];
            [filePathsVideoArtworkArray removeAllObjects];
            [self setupVideoArrays];
            [self.tableView reloadData];
        }]];

        [self presentViewController:alertDeleted animated:YES completion:nil];
    }]];

    [alertMenu addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
    }]];

    [self presentViewController:alertMenu animated:YES completion:nil];
}

- (void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection {
    [super traitCollectionDidChange:previousTraitCollection];
    [self setupLightDarkModeVideoView];
    [self.tableView reloadData];
}

@end

@implementation DownloadsVideoController(Privates)

- (void)setupLightDarkModeVideoView {
    if (self.traitCollection.userInterfaceStyle == UIUserInterfaceStyleLight) {
        self.view.backgroundColor = [UIColor colorWithRed:0.949 green:0.949 blue:0.969 alpha:1.0];
    }
    else {
        self.view.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:1.0];
    }
}

- (void)setupVideoArrays {
    NSFileManager *fm = [[NSFileManager alloc] init];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    documentsDirectory = [paths objectAtIndex:0];

    NSArray *filePathsList = [[NSFileManager defaultManager] subpathsOfDirectoryAtPath:documentsDirectory error:nil];
    filePathsVideoArray = [[NSMutableArray alloc] init];
    filePathsVideoArtworkArray = [[NSMutableArray alloc] init];
    for (id object in filePathsList) {
        [filePathsVideoArray addObject:object];
    }
}

@end