#import "RebornSettingsController.h"

@interface RebornSettingsController ()
- (void)setupRebornSettingsControllerView;
@end

@implementation RebornSettingsController

- (void)loadView {
	[super loadView];
    [self setupRebornSettingsControllerView];

    self.title = @"Reborn Options";

    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(done)];
    self.navigationItem.rightBarButtonItem = doneButton;

    if (@available(iOS 15.0, *)) {
    	[self.tableView setSectionHeaderTopPadding:0.0f];
	}
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }
    if (section == 1) {
        return 1;
    }
    if (section == 2) {
        return 2;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"TabBarTableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:nil];
        cell.textLabel.adjustsFontSizeToFitWidth = true;
        if (@available(iOS 13.0, *)) {
            if (self.traitCollection.userInterfaceStyle == UIUserInterfaceStyleLight) {
                cell.backgroundColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];
                cell.textLabel.textColor = [UIColor blackColor];
            } else {
                cell.backgroundColor = [UIColor colorWithRed:0.110 green:0.110 blue:0.118 alpha:1.0];
                cell.textLabel.textColor = [UIColor whiteColor];
            }
        } else {
            cell.backgroundColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];
            cell.textLabel.textColor = [UIColor blackColor];
        }
        if (indexPath.section == 0) {
            if (indexPath.row == 0) {
                cell.textLabel.text = @"Reset Colour Options";
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }
        }
        if (indexPath.section == 1) {
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            if (indexPath.row == 0) {
                cell.textLabel.text = @"I Have YouTube Premium";
                UISwitch *rebornIHaveYouTubePremiumButton = [[UISwitch alloc] initWithFrame:CGRectZero];
                [rebornIHaveYouTubePremiumButton addTarget:self action:@selector(toggleRebornIHaveYouTubePremiumButton:) forControlEvents:UIControlEventValueChanged];
                rebornIHaveYouTubePremiumButton.on = [[NSUserDefaults standardUserDefaults] boolForKey:@"kRebornIHaveYouTubePremium"];
                cell.accessoryView = rebornIHaveYouTubePremiumButton;
            }
        }
        if (indexPath.section == 2) {
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            if (indexPath.row == 0) {
                cell.textLabel.text = @"Hide Video Overlay 'OP' Button";
                UISwitch *hideRebornOPButton = [[UISwitch alloc] initWithFrame:CGRectZero];
                [hideRebornOPButton addTarget:self action:@selector(toggleHideRebornOPButton:) forControlEvents:UIControlEventValueChanged];
                hideRebornOPButton.on = [[NSUserDefaults standardUserDefaults] boolForKey:@"kHideRebornOPButtonVTwo"];
                cell.accessoryView = hideRebornOPButton;
            }
            if (indexPath.row == 1) {
                cell.textLabel.text = @"Hide Shorts Overlay 'OP' Button";
                UISwitch *hideRebornShortsOPButton = [[UISwitch alloc] initWithFrame:CGRectZero];
                [hideRebornShortsOPButton addTarget:self action:@selector(toggleHideRebornShortsOPButton:) forControlEvents:UIControlEventValueChanged];
                hideRebornShortsOPButton.on = [[NSUserDefaults standardUserDefaults] boolForKey:@"kHideRebornShortsOPButton"];
                cell.accessoryView = hideRebornShortsOPButton;
            }
        }
    }
    return cell;
}

- (void)tableView:(UITableView *)theTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [theTableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Notice" message:@"Are you sure you want to delete your set colour?" preferredStyle:UIAlertControllerStyleAlert];

            [alert addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            }]];

            [alert addAction:[UIAlertAction actionWithTitle:@"Okay" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"kYTRebornColourOptionsVThree"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                exit(0);
            }]];

            [self presentViewController:alert animated:YES completion:nil];
        }
    }
}

- (void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection {
    [super traitCollectionDidChange:previousTraitCollection];
    [self setupRebornSettingsControllerView];
    [self.tableView reloadData];
}

@end

@implementation RebornSettingsController (Privates)

- (void)done {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)setupRebornSettingsControllerView {
    if (@available(iOS 13.0, *)) {
        if (self.traitCollection.userInterfaceStyle == UIUserInterfaceStyleLight) {
            self.view.backgroundColor = [UIColor colorWithRed:0.949 green:0.949 blue:0.969 alpha:1.0];
            [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor]}];
            self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
        } else {
            self.view.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:1.0];
            [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
            self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
        }
    } else {
        self.view.backgroundColor = [UIColor colorWithRed:0.949 green:0.949 blue:0.969 alpha:1.0];
        [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor]}];
        self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
    }
}

- (void)toggleRebornIHaveYouTubePremiumButton:(UISwitch *)sender {
    if ([sender isOn]) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"kRebornIHaveYouTubePremium"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    } else {
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"kRebornIHaveYouTubePremium"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

- (void)toggleHideRebornOPButton:(UISwitch *)sender {
    if ([sender isOn]) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"kHideRebornOPButtonVTwo"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    } else {
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"kHideRebornOPButtonVTwo"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

- (void)toggleHideRebornShortsOPButton:(UISwitch *)sender {
    if ([sender isOn]) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"kHideRebornShortsOPButton"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    } else {
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"kHideRebornShortsOPButton"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

@end