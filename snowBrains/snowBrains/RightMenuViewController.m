//
//  SideMenuViewController.m
//  MFSideMenu
//
//  Created by Michael Frederick on 3/19/12.

#import "RightMenuViewController.h"
#import "MFSideMenu.h"

#import "SettingsViewController.h"

@interface RightMenuViewController()
@property(nonatomic, strong) UIView *menuLogo;
@end

@implementation RightMenuViewController

@synthesize sideMenu;
@synthesize menuLogo;

- (void) viewDidLoad {
    [super viewDidLoad];
    
    CGRect menuLogoFrame = CGRectMake(0, 0, self.tableView.frame.size.width, 45.0);
    UIImage *menuLogoImage=[UIImage imageNamed:@"sideBarHeader"];
    UIImageView *menuLogoView =[[UIImageView alloc]initWithImage:menuLogoImage];
    self.menuLogo = [[UIView alloc]initWithFrame:menuLogoFrame];
    [menuLogo addSubview:menuLogoView];
    self.tableView.bounces=NO;
    self.tableView.tableHeaderView = self.menuLogo;
}


#pragma mark -
#pragma mark - UITableViewDataSource

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [NSString stringWithFormat:@"Section %d", section];
}
//-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
//    return[[UIImageView alloc]initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"section%d",section]]];
//}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"buttonBackground"]];
    [cell.contentView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"buttonBackground"]]];
    cell.textLabel.text = [NSString stringWithFormat:@"Item %d", indexPath.row];
    cell.textLabel.backgroundColor=[UIColor clearColor];
    
    return cell;
}


#pragma mark -
#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    SettingsViewController *viewController = [[SettingsViewController alloc]init];
    viewController.showDoneButton=NO;
//    UIBarButtonItem *backButton = [[UIBarButtonItem alloc]
//                                   initWithTitle: @"Back"
//                                   style: UIBarButtonItemStyleBordered
//                                   target: nil action: nil];
//    
//    [viewController.navigationItem setBackBarButtonItem:backButton];
    
    [self.sideMenu.navigationController pushViewController:viewController animated:NO];
//    NSMutableArray *controllers = [self.sideMenu.navigationController.viewControllers mutableCopy];
//    [controllers addObject:viewController];
//    self.sideMenu.navigationController.viewControllers=controllers;
    [self.sideMenu setMenuState:MFSideMenuStateClosed];
}

@end
