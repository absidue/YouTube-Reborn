#import "SearchOptionsController.h"
#import "../iOS15Fix.h"

static int __isOSVersionAtLeast(int major, int minor, int patch) { NSOperatingSystemVersion version; version.majorVersion = major; version.minorVersion = minor; version.patchVersion = patch; return [[NSProcessInfo processInfo] isOperatingSystemAtLeastVersion:version]; }

@interface SearchOptionsController ()
@end

@implementation SearchOptionsController

- (void)loadView {
	[super loadView];

    self.title = @"Search Options";
    if (self.traitCollection.userInterfaceStyle == UIUserInterfaceStyleLight) {
        self.view.backgroundColor = [UIColor colorWithRed:0.949 green:0.949 blue:0.969 alpha:1.0];
        [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor]}];
    }
    else {
        self.view.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:1.0];
        [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
        self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    }

    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(done)];
    self.navigationItem.rightBarButtonItem = doneButton;

    if (@available(iOS 15.0, *)) {
    	[self.tableView setSectionHeaderTopPadding:0.0f];
	}
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)theTableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)theTableView numberOfRowsInSection:(NSInteger)section {
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"kEnableEnhancedSearchBar"]) {
        return 2;
    } else {
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"SearchTableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:nil];
        cell.textLabel.adjustsFontSizeToFitWidth = true;
        if (self.traitCollection.userInterfaceStyle == UIUserInterfaceStyleLight) {
            cell.backgroundColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];
            cell.textLabel.textColor = [UIColor blackColor];
        }
        else {
            cell.backgroundColor = [UIColor colorWithRed:0.110 green:0.110 blue:0.118 alpha:1.0];
            cell.textLabel.textColor = [UIColor whiteColor];
        }
        if(indexPath.row == 0) {
            cell.textLabel.text = @"Enable Enhanced Search Bar";
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            UISwitch *enableEnhancedSearchBar = [[UISwitch alloc] initWithFrame:CGRectZero];
            [enableEnhancedSearchBar addTarget:self action:@selector(toggleEnableEnhancedSearchBar:) forControlEvents:UIControlEventValueChanged];
            enableEnhancedSearchBar.on = [[NSUserDefaults standardUserDefaults] boolForKey:@"kEnableEnhancedSearchBar"];
            cell.accessoryView = enableEnhancedSearchBar;
        }
        if(indexPath.row == 1) {
            cell.textLabel.text = @"Disable Voice Search";
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            UISwitch *disableVoiceSearch = [[UISwitch alloc] initWithFrame:CGRectZero];
            [disableVoiceSearch addTarget:self action:@selector(toggleDisableVoiceSearch:) forControlEvents:UIControlEventValueChanged];
            disableVoiceSearch.on = [[NSUserDefaults standardUserDefaults] boolForKey:@"kDisableVoiceSearch"];
            cell.accessoryView = disableVoiceSearch;
        }
    }
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {        
    return [UIView new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10;
}

@end

@implementation SearchOptionsController(Privates)

- (void)done {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)toggleEnableEnhancedSearchBar:(UISwitch *)sender {
    if ([sender isOn]) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"kEnableEnhancedSearchBar"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [self.tableView reloadData];
    } else {
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"kEnableEnhancedSearchBar"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [self.tableView reloadData];
    }
}

- (void)toggleDisableVoiceSearch:(UISwitch *)sender {
    if ([sender isOn]) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"kDisableVoiceSearch"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    } else {
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"kDisableVoiceSearch"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

@end