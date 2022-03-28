#import "CreditsController.h"
#import "../iOS15Fix.h"

static int __isOSVersionAtLeast(int major, int minor, int patch) { NSOperatingSystemVersion version; version.majorVersion = major; version.minorVersion = minor; version.patchVersion = patch; return [[NSProcessInfo processInfo] isOperatingSystemAtLeastVersion:version]; }

@interface CreditsController ()
@end

@implementation CreditsController

- (void)loadView {
	[super loadView];

    self.title = @"Credits";
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
    return 3;
}

- (NSInteger)tableView:(UITableView *)theTableView numberOfRowsInSection:(NSInteger)section {
    if(section == 0) {
        return 1;
    }
    if(section == 1) {
        return 1;
    }
    if(section == 2) {
        return 13;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"CreditsTableViewCell";
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
        if(indexPath.section == 0) {
            if(indexPath.row == 0) {
                cell.textLabel.text = @"Lillie";
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }
        }
        if(indexPath.section == 1) {
            if(indexPath.row == 0) {
                cell.textLabel.text = @"Alpha_Stream";
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }
        }
        if(indexPath.section == 2) {
            if(indexPath.row == 0) {
                cell.textLabel.text = @"Binny";
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }
            if(indexPath.row == 1) {
                cell.textLabel.text = @"Cameren";
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }
            if(indexPath.row == 2) {
                cell.textLabel.text = @"Capt Inc";
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }
            if(indexPath.row == 3) {
                cell.textLabel.text = @"Emma";
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }
            if(indexPath.row == 4) {
                cell.textLabel.text = @"Emy";
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }
            if(indexPath.row == 5) {
                cell.textLabel.text = @"hmuy";
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }
            if(indexPath.row == 6) {
                cell.textLabel.text = @"Lans";
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }
            if(indexPath.row == 7) {
                cell.textLabel.text = @"PoomSmart";
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }
            if(indexPath.row == 8) {
                cell.textLabel.text = @"Rick";
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }
            if(indexPath.row == 9) {
                cell.textLabel.text = @"Rosie";
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }
            if(indexPath.row == 10) {
                cell.textLabel.text = @"Sarah";
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }
            if(indexPath.row == 11) {
                cell.textLabel.text = @"Sloopie";
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }
            if(indexPath.row == 12) {
                cell.textLabel.text = @"Worf";
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }
        }
    }
    return cell;
}

- (void)tableView:(UITableView *)theTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [theTableView deselectRowAtIndexPath:indexPath animated:YES];
    if(indexPath.section == 0) {
        if(indexPath.row == 0) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://github.com/LillieWeeb001"] options:@{} completionHandler:nil];
        }
    }
    if(indexPath.section == 1) {
        if(indexPath.row == 0) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://twitter.com/Kutarin_"] options:@{} completionHandler:nil];
        }
    }
    if(indexPath.section == 2) {
        if(indexPath.row == 0) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://twitter.com/drama_binny"] options:@{} completionHandler:nil];
        }
        if(indexPath.row == 1) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://twitter.com/cameren0"] options:@{} completionHandler:nil];
        }
        if(indexPath.row == 2) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://github.com/captinc"] options:@{} completionHandler:nil];
        }
        if(indexPath.row == 3) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://twitter.com/nikoyagamer"] options:@{} completionHandler:nil];
        }
        if(indexPath.row == 4) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://github.com/Emy"] options:@{} completionHandler:nil];
        }
        if(indexPath.row == 5) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://twitter.com/hmuy0608"] options:@{} completionHandler:nil];
        }
        if(indexPath.row == 6) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://twitter.com/imlans10"] options:@{} completionHandler:nil];
        }
        if(indexPath.row == 7) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://twitter.com/PoomSmart"] options:@{} completionHandler:nil];
        }
        if(indexPath.row == 8) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://twitter.com/sahmoee"] options:@{} completionHandler:nil];
        }
        if(indexPath.row == 9) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://twitter.com/deluxe_rosie"] options:@{} completionHandler:nil];
        }
        if(indexPath.row == 10) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://github.com/Banaantje04"] options:@{} completionHandler:nil];
        }
        if(indexPath.row == 11) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://twitter.com/Sloooopie"] options:@{} completionHandler:nil];
        }
        if(indexPath.row == 12) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://github.com/Worf1337"] options:@{} completionHandler:nil];
        }
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return @"Developers";
    }
    if (section == 1) {
        return @"Icon Designer";
    }
    if (section == 2) {
        return @"Special Thanks";
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
    if (self.traitCollection.userInterfaceStyle == UIUserInterfaceStyleLight) {
        view.tintColor = [UIColor colorWithRed:0.949 green:0.949 blue:0.969 alpha:1.0];
    }
    else {
        view.tintColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:1.0];
    }
    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
    [header.textLabel setTextColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"tableSection"]]];
    [header.textLabel setFont:[UIFont systemFontOfSize:14]];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0 || section == 1 || section == 2) {
        return 50;
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [UIView new];
}

- (CGFloat)tableView:(UITableView*)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 2) {
        return 50;
    }
    return 0;
}

@end

@implementation CreditsController(Privates)

- (void)done {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

@end