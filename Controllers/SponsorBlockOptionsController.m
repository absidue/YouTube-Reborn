#import "SponsorBlockOptionsController.h"
#import "../iOS15Fix.h"

static int __isOSVersionAtLeast(int major, int minor, int patch) { NSOperatingSystemVersion version; version.majorVersion = major; version.minorVersion = minor; version.patchVersion = patch; return [[NSProcessInfo processInfo] isOperatingSystemAtLeastVersion:version]; }

@interface SponsorBlockOptionsController ()
@end

@implementation SponsorBlockOptionsController

- (void)loadView {
	[super loadView];

    self.title = @"SponsorBlock Options";
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
    return 8;
}

- (NSInteger)tableView:(UITableView *)theTableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0 || section == 1 || section == 2 || section == 3 || section == 4 || section == 5 || section == 6 || section == 7) {
        return 1;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"TabBarTableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:nil];
        cell.textLabel.adjustsFontSizeToFitWidth = true;
        cell.accessoryType = UITableViewCellAccessoryNone;
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
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                NSArray *sponsorItemArray = [NSArray arrayWithObjects:@"Disable", @"Manual Skip", @"Auto Skip", nil];
                UISegmentedControl *sponsorSegmentedControl = [[UISegmentedControl alloc] initWithItems:sponsorItemArray];
                sponsorSegmentedControl.frame = CGRectMake(0, 5, self.view.bounds.size.width, cell.bounds.size.height - 10);
                sponsorSegmentedControl.selectedSegmentIndex = 0;
                [cell addSubview:sponsorSegmentedControl];
            }
        }
        if(indexPath.section == 1) {
            if(indexPath.row == 0) {
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                NSArray *selfpromoItemArray = [NSArray arrayWithObjects:@"Disable", @"Manual Skip", @"Auto Skip", nil];
                UISegmentedControl *selfpromoSegmentedControl = [[UISegmentedControl alloc] initWithItems:selfpromoItemArray];
                selfpromoSegmentedControl.frame = CGRectMake(0, 5, self.view.bounds.size.width, cell.bounds.size.height - 10);
                selfpromoSegmentedControl.selectedSegmentIndex = 0;
                [cell addSubview:selfpromoSegmentedControl];
            }
        }
        if(indexPath.section == 2) {
            if(indexPath.row == 0) {
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                NSArray *interactionItemArray = [NSArray arrayWithObjects:@"Disable", @"Manual Skip", @"Auto Skip", nil];
                UISegmentedControl *interactionSegmentedControl = [[UISegmentedControl alloc] initWithItems:interactionItemArray];
                interactionSegmentedControl.frame = CGRectMake(0, 5, self.view.bounds.size.width, cell.bounds.size.height - 10);
                interactionSegmentedControl.selectedSegmentIndex = 0;
                [cell addSubview:interactionSegmentedControl];
            }
        }
        if(indexPath.section == 3) {
            if(indexPath.row == 0) {
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                NSArray *introItemArray = [NSArray arrayWithObjects:@"Disable", @"Manual Skip", @"Auto Skip", nil];
                UISegmentedControl *introSegmentedControl = [[UISegmentedControl alloc] initWithItems:introItemArray];
                introSegmentedControl.frame = CGRectMake(0, 5, self.view.bounds.size.width, cell.bounds.size.height - 10);
                introSegmentedControl.selectedSegmentIndex = 0;
                [cell addSubview:introSegmentedControl];
            }
        }
        if(indexPath.section == 4) {
            if(indexPath.row == 0) {
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                NSArray *outroItemArray = [NSArray arrayWithObjects:@"Disable", @"Manual Skip", @"Auto Skip", nil];
                UISegmentedControl *outroSegmentedControl = [[UISegmentedControl alloc] initWithItems:outroItemArray];
                outroSegmentedControl.frame = CGRectMake(0, 5, self.view.bounds.size.width, cell.bounds.size.height - 10);
                outroSegmentedControl.selectedSegmentIndex = 0;
                [cell addSubview:outroSegmentedControl];
            }
        }
        if(indexPath.section == 5) {
            if(indexPath.row == 0) {
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                NSArray *previewItemArray = [NSArray arrayWithObjects:@"Disable", @"Manual Skip", @"Auto Skip", nil];
                UISegmentedControl *previewSegmentedControl = [[UISegmentedControl alloc] initWithItems:previewItemArray];
                previewSegmentedControl.frame = CGRectMake(0, 5, self.view.bounds.size.width, cell.bounds.size.height - 10);
                previewSegmentedControl.selectedSegmentIndex = 0;
                [cell addSubview:previewSegmentedControl];
            }
        }
        if(indexPath.section == 6) {
            if(indexPath.row == 0) {
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                NSArray *musicofftopicItemArray = [NSArray arrayWithObjects:@"Disable", @"Manual Skip", @"Auto Skip", nil];
                UISegmentedControl *musicofftopicSegmentedControl = [[UISegmentedControl alloc] initWithItems:musicofftopicItemArray];
                musicofftopicSegmentedControl.frame = CGRectMake(0, 5, self.view.bounds.size.width, cell.bounds.size.height - 10);
                musicofftopicSegmentedControl.selectedSegmentIndex = 0;
                [cell addSubview:musicofftopicSegmentedControl];
            }
        }
        if(indexPath.section == 7) {
            if(indexPath.row == 0) {
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                NSArray *fillerItemArray = [NSArray arrayWithObjects:@"Disable", @"Manual Skip", @"Auto Skip", nil];
                UISegmentedControl *fillerSegmentedControl = [[UISegmentedControl alloc] initWithItems:fillerItemArray];
                fillerSegmentedControl.frame = CGRectMake(0, 5, self.view.bounds.size.width, cell.bounds.size.height - 10);
                fillerSegmentedControl.selectedSegmentIndex = 0;
                [cell addSubview:fillerSegmentedControl];
            }
        }
    }
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return @"Sponsor";
    }
    if (section == 1) {
        return @"Selfpromo";
    }
    if (section == 2) {
        return @"Interaction";
    }
    if (section == 3) {
        return @"Intro";
    }
    if (section == 4) {
        return @"Outro";
    }
    if (section == 5) {
        return @"Preview";
    }
    if (section == 6) {
        return @"Music_offtopic";
    }
    if (section == 7) {
        return @"Filler";
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

- (CGFloat)tableView:(UITableView*)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0 || section == 1 || section == 2 || section == 3 || section == 4 || section == 5 || section == 6 || section == 7) {
        return 50;
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {        
    return [UIView new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 7) {
        return 10;
    }
}

@end

@implementation SponsorBlockOptionsController(Privates)

- (void)done {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

@end