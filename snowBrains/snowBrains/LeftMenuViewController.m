//
//  SideMenuViewController.m
//  MFSideMenu
//
//  Created by Michael Frederick on 3/19/12.

#import "LeftMenuViewController.h"
#import "MFSideMenu.h"
#import "ViewController.h"
#import "MenuCell.h"
#import "IASKAppSettingsViewController.h"
#import "InAppSettings.h"
enum {
    lMenuListMain = 0,
    lMenuListFavorites,
    lMenuListOther,
    lMenuListCount
};
//enum {
//    lLocationSquaw = 0,
//    lLocationJackson,
//    lLocationWhistler,
//    lLocationAlaska,
//    lLocationMore,
//    lLocationCount
//};
//enum {
//    lMoreUtah =0,
//    lMoreMammoth,
//    lMorePNW,
//    lMoreSouthAmerica,
//    lMoreJapan,
//    lMoreAlps,
//    lMoreCount
//};
//enum {
//    lVideoBrains = 0,
//    lVideoNonBrains,
//    lVideoTrailer,
//    lVideoCount
//};

@interface LeftMenuViewController(){
    NSMutableArray *sections;
    
    NSMutableArray *mainList;
    NSMutableArray *favoritesList;
    NSMutableArray *favoritesURLS;
    NSMutableArray *otherList;
    
    NSArray *mainItems;
    NSArray *locationItems;
    NSArray *moreItems;
    NSArray *videoItems;
    
}
@property(nonatomic, strong) UISearchBar *searchBar;
@end

@implementation LeftMenuViewController

@synthesize sideMenu;
//@synthesize searchBar;
- (id)init{
    if(self=[super init]){
        
        mainItems=[[NSArray alloc]initWithObjects:@"Home",@"Locations",@"Weather",@"Video",@"Gear",@"Brains", nil];
        locationItems=[[NSArray alloc]initWithObjects:@"Squaw",@"Jackson",@"Whistler",@"Alaska",@"More", nil];
        moreItems=[[NSArray alloc]initWithObjects:@"Utah",@"Mammoth",@"PNW",@"South America",@"Japan",@"Alps", nil];
        videoItems=[[NSArray alloc]initWithObjects:@"Brain Videos",@"Non-Brain Videos",@"Trailers", nil];
        mainList=[[NSMutableArray alloc]initWithArray:mainItems];
        favoritesList=[[NSMutableArray alloc]initWithObjects:@"Favorites dummy", nil];
        favoritesURLS=[[NSMutableArray alloc]initWithObjects:@"Favorites dummy", nil];
        otherList=[[NSMutableArray alloc]initWithObjects:@"Settings",@"Contact", nil];
        sections=[[NSMutableArray alloc]initWithObjects:mainItems,favoritesList,otherList, nil];
    }
    return self;
}
-(NSMutableArray *)loadFavorites{
    NSMutableArray *bookmarks=[[[NSUserDefaults standardUserDefaults] arrayForKey:@"Bookmarks"] mutableCopy];
    NSMutableArray *names=[[NSMutableArray alloc]init];
    NSMutableArray *urls=[[NSMutableArray alloc]init];
    for(NSDictionary *bookmark in bookmarks){
        [names addObject:[bookmark valueForKey:@"Name"]];
        [urls addObject:[bookmark valueForKey:@"URL"]];
    }
    favoritesURLS=urls;
    return names;
}

- (void) viewDidLoad {
    [super viewDidLoad];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    self.delegate=self.sideMenu.navigationController.delegate;
    CGRect searchBarFrame = CGRectMake(0, 0, self.tableView.frame.size.width, 45.0);
    self.searchBar = [[UISearchBar alloc] initWithFrame:searchBarFrame];
    self.searchBar.delegate = self;
    self.tableView.backgroundView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"buttonBackground"]];
    self.tableView.tableHeaderView = self.searchBar;
}
-(void)viewWillAppear:(BOOL)animated{
    favoritesList=[self loadFavorites];
    sections=[[NSMutableArray alloc]initWithObjects:mainItems,favoritesList,otherList, nil];
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:lMenuListFavorites] withRowAnimation:UITableViewRowAnimationAutomatic];
}


#pragma mark -
#pragma mark - UITableViewDataSource

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [self getSectionName:section];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return sections.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return ((NSMutableArray *)[sections objectAtIndex:section]).count;
    //return[self getSectionCount:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    MenuCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[MenuCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.textLabel.backgroundColor=[UIColor clearColor];
    cell.textLabel.text=[(NSMutableArray *)[sections objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    if([locationItems containsObject:cell.textLabel.text]||[videoItems containsObject:cell.textLabel.text]){
        cell.indentationLevel=4;
        cell.textLabel.font=[UIFont italicSystemFontOfSize:15];
    }else if([moreItems containsObject:cell.textLabel.text]){
        cell.indentationLevel=6;
        cell.textLabel.font=[UIFont boldSystemFontOfSize:12];
    }else{
        cell.indentationLevel=1;
        cell.textLabel.font=[UIFont systemFontOfSize:17];
    }
    if([cell.textLabel.text isEqualToString:@"Locations"]||[cell.textLabel.text isEqualToString:@"Video"]||[cell.textLabel.text isEqualToString:@"More"]){
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    }else{
        cell.accessoryType=UITableViewCellAccessoryNone;
    }
    cell.imageView.image=[UIImage imageNamed:@"flake"];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    
    
    return cell;
}
-(NSString *)getSectionName:(NSInteger)section{
    if(section==lMenuListMain)
        return @"Main";
    else if(section==lMenuListFavorites)
        return @"Favorites";
    else if (section==lMenuListOther)
        return @"Other";
    return nil;
}
-(int)getSectionCount:(NSInteger)section{
    if(section==lMenuListMain)
        return mainList.count;
    else if(section==lMenuListFavorites)
        return 0;
    else if (section==lMenuListOther)
        return 1;
    return -1;
}

#pragma mark -
#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell=[self.tableView.dataSource tableView:self.tableView cellForRowAtIndexPath:indexPath];
    NSString *selectedMenuItem=cell.textLabel.text;
    if(indexPath.section==lMenuListFavorites){
        [self.delegate bookmarkLoad:[favoritesURLS objectAtIndex:indexPath.row]];
    }else if([selectedMenuItem isEqualToString:@"Locations"]||[selectedMenuItem isEqualToString:@"More"]||[selectedMenuItem isEqualToString:@"Video"]){
        [self manageSubCells:cell];
        return;
    }else if([selectedMenuItem isEqualToString:@"Settings"]){
        InAppSettingsModalViewController *settings=[[InAppSettingsModalViewController alloc]init];
        [[self.sideMenu.navigationController.viewControllers objectAtIndex:0] presentModalViewController:settings animated:YES];
    }else{
        [self.delegate menuTap:selectedMenuItem];
    }
    [self.sideMenu setMenuState:MFSideMenuStateClosed];
    
    if(self.searchBar.isFirstResponder) [self.searchBar resignFirstResponder];
}
-(void)manageSubCells:(UITableViewCell *)cell{
    NSString *selection=cell.textLabel.text;
    if([[self.tableView.dataSource tableView:self.tableView cellForRowAtIndexPath:[self.tableView indexPathForSelectedRow]].textLabel.text isEqualToString:selection]){
        NSMutableArray *tempList=[[NSMutableArray alloc]initWithArray:mainList];
        if([selection isEqualToString:@"Locations"]){
            if([tempList containsObject:[locationItems objectAtIndex:0]]){
                [tempList removeObjectsInArray:locationItems];
                [tempList removeObjectsInArray:moreItems];
            }else{
                for(int i=0;i<locationItems.count;i++)
                    [tempList insertObject:[locationItems objectAtIndex:i] atIndex:[mainList indexOfObject:selection]+i+1];
            }
        }else if([selection isEqualToString:@"More"]){
            if([tempList containsObject:[moreItems objectAtIndex:0]]){
                [tempList removeObjectsInArray:moreItems];
            }
            else{
                for(int i=0;i<moreItems.count;i++)
                    [tempList insertObject:[moreItems objectAtIndex:i] atIndex:[mainList indexOfObject:selection]+i+1];
            }
        }else if([selection isEqualToString:@"Video"]){
            if([tempList containsObject:[videoItems objectAtIndex:0]]){
                [tempList removeObjectsInArray:videoItems];
            }else{
                for(int i=0;i<videoItems.count;i++)
                    [tempList insertObject:[videoItems objectAtIndex:i] atIndex:[mainList indexOfObject:selection]+i+1];
            }
        }
        mainList=[[NSMutableArray alloc]initWithArray:tempList];
        sections=[[NSMutableArray alloc]initWithObjects:mainList,favoritesList,otherList, nil];
        [self.tableView reloadData];
    }
    
}


#pragma mark - 
#pragma mark - UISearchBarDelegate

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    return YES;
}

- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar {
    return YES;
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [self.searchBar resignFirstResponder];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [self.searchBar resignFirstResponder];
    [self.delegate search:searchBar.text];
    [self.sideMenu setMenuState:MFSideMenuStateClosed];
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    [UIView beginAnimations:nil context:NULL];
    [self.sideMenu setMenuWidth:320.0f animated:NO];
    [self.searchBar layoutSubviews];
    [UIView commitAnimations];
    
    [self.searchBar setShowsCancelButton:YES animated:YES];
    
    self.sideMenu.panMode = MFSideMenuPanModeNone;
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
    [UIView beginAnimations:nil context:NULL];
    [self.sideMenu setMenuWidth:280.0f animated:NO];
    [self.searchBar layoutSubviews];
    [UIView commitAnimations];
    
    [self.searchBar setShowsCancelButton:NO animated:YES];
    
    self.sideMenu.panMode = MFSideMenuPanModeDefault;
}


@end
