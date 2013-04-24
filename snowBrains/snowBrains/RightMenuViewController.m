//
//  SideMenuViewController.m
//  MFSideMenu
//
//  Created by Michael Frederick on 3/19/12.

#import "RightMenuViewController.h"
#import "MFSideMenu.h"
#import "ViewController.h"

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
    
    self.tableView.tableHeaderView = self.menuLogo;
}


#pragma mark -
#pragma mark - UITableViewDataSource

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [NSString stringWithFormat:@"Section %d", section];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
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
    
    cell.textLabel.text = [NSString stringWithFormat:@"Item %d", indexPath.row];
    
    return cell;
}


#pragma mark -
#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ViewController *viewController = [[ViewController alloc] initWithNibName:@"ViewController" bundle:nil];
//    viewController.title = [NSString stringWithFormat:@" View Controller #%d-%d", indexPath.section, indexPath.row];
    
    NSArray *controllers = [NSArray arrayWithObject:viewController];
    self.sideMenu.navigationController.viewControllers = controllers;
    [self.sideMenu setMenuState:MFSideMenuStateClosed];
}

@end
