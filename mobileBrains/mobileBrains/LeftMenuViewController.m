//
//  SideMenuViewController.m
//  MFSideMenu
//
//  Created by Michael Frederick on 3/19/12.

#import "LeftMenuViewController.h"
#import "MFSideMenu.h"
#import "ViewController.h"
#import "MenuCell.h"
#import "InAppSettings.h"
enum {
    lMenuListMain = 0,
    lMenuListBookmarks,
    lMenuListOther,
    lMenuListCount
};

@interface LeftMenuViewController(){
    NSMutableArray *sections;
    NSMutableArray *sectionNames;
    NSMutableDictionary *menuIcons;
    NSMutableDictionary *globalURLS;
    NSMutableArray *setup;
    
    NSMutableArray *mainList;
    NSMutableArray *bookmarksList;
    NSMutableArray *bookmarksURLS;
    NSMutableArray *otherList;
    
    NSMutableArray *mainItems;
    NSMutableArray *locationItems;
    NSMutableArray *moreItems;
    NSMutableArray *videoItems;
    
//    NSArray *mainItems;
//    NSArray *locationItems;
//    NSArray *moreItems;
//    NSArray *videoItems;
    
    bool locationSelect;
    bool moreSelect;
    bool videoSelect;
    
}
@property(nonatomic, strong) UISearchBar *searchBar;
@end

@implementation LeftMenuViewController

@synthesize sideMenu;
- (id)init{
    if(self=[super init]){
        
        NSArray *plist=[[NSUserDefaults standardUserDefaults] objectForKey:@"globalData"];
        sectionNames=[[NSMutableArray alloc]init];
        menuIcons=[[NSMutableDictionary alloc]init];
        globalURLS=[[NSMutableDictionary alloc]init];
        sections=[[NSMutableArray alloc]init];
        setup=[[NSMutableArray alloc]init];
        
        for(NSDictionary *sectionsList in plist){
            NSString *sectionName=[sectionsList valueForKey:@"section"];
            if(sectionName){
                [sectionNames addObject:sectionName];
                [self enumerateItems:[sectionsList valueForKey:@"items"] section:sectionName];
            }
        }
        [[NSUserDefaults standardUserDefaults] setObject:globalURLS forKey:@"globalURLS"];
        
        mainItems=[[NSMutableArray alloc]init];
        locationItems=[[NSMutableArray alloc]init];
        moreItems=[[NSMutableArray alloc]init];
        videoItems=[[NSMutableArray alloc]init];
        otherList=[[NSMutableArray alloc]init];
        for(NSDictionary *dict in setup){
            NSString *key=dict.keyEnumerator.nextObject;
            NSString *value=[dict valueForKey:key];
            if([value isEqualToString:@"Main"])
                [mainItems addObject:key];
            else if([value isEqualToString:@"Locations"])
                [locationItems addObject:key];
            else if([value isEqualToString:@"More"])
                [moreItems addObject:key];
            else if([value isEqualToString:@"Video"])
                [videoItems addObject:key];
            else if([value isEqualToString:@"Other"])
                [otherList addObject:key];
        }
        
//        mainItems=[[NSArray alloc]initWithObjects:NSLocalizedString(@"Home", @"Home name"),NSLocalizedString(@"Locations", @"Locations name"),NSLocalizedString(@"Weather", @"Weather name"),NSLocalizedString(@"Video", @"Video name"),NSLocalizedString(@"Gear", @"Gear name"),NSLocalizedString(@"Brains", @"Brains name"), nil];
//        locationItems=[[NSArray alloc]initWithObjects:NSLocalizedString(@"Squaw", @"Squaw name"),NSLocalizedString(@"Jackson",@"Jackson name"),NSLocalizedString(@"Whistler",@"Whistler name"),NSLocalizedString(@"Alaska",@"Alaska name"),NSLocalizedString(@"More",@"More name"), nil];
//        moreItems=[[NSArray alloc]initWithObjects:NSLocalizedString(@"Utah",@"Utah name"),NSLocalizedString(@"Mammoth",@"Mammoth name"),NSLocalizedString(@"PNW",@"PNW name"),NSLocalizedString(@"South America",@"South America name"),NSLocalizedString(@"Japan",@"Japan name"),NSLocalizedString(@"Alps",@"Alps name"), nil];
//        videoItems=[[NSArray alloc]initWithObjects:NSLocalizedString(@"Brain Videos",@"Brain Videos name"),NSLocalizedString(@"Non-Brain Videos",@"Non-Brain Videos name"),NSLocalizedString(@"Trailers",@"Trailers name"), nil];
        mainList=[[NSMutableArray alloc]initWithArray:mainItems];
        bookmarksList=[[NSMutableArray alloc]initWithObjects:@"Bookmarks dummy", nil];
        bookmarksURLS=[[NSMutableArray alloc]initWithObjects:@"Bookmarks dummy", nil];
//        otherList=[[NSMutableArray alloc]initWithObjects:NSLocalizedString(@"Settings",@"Settings name"),NSLocalizedString(@"Contact",@"Contact name"), nil];
        sections=[[NSMutableArray alloc]initWithObjects:mainItems,bookmarksList,otherList, nil];
        locationSelect=NO;
        moreSelect=NO;
        videoSelect=NO;
    }
    return self;
}
-(void)enumerateItems:(NSArray*) items section:(NSString*)section{
    if(items){
        for(NSDictionary *itemsList in items){
            NSString *name=[itemsList valueForKey:@"name"];
            NSString *url=[itemsList valueForKey:@"link"];
            NSString *icon=[itemsList valueForKey:@"icon"];
            if(name){
                [setup addObject:[NSDictionary dictionaryWithObject:section forKey:name]];
                if(url){
                    if(url)
                        [globalURLS setValue:url forKey:name];
                }
                if(icon)[menuIcons setValue:icon forKey:name];
            }
            BOOL subItems=[[itemsList valueForKey:@"subgroup"]boolValue];
            if(subItems){
                [self enumerateItems:[itemsList valueForKey:@"items"] section:name];
            }
        }
    }
}
-(NSMutableArray *)loadBookmarks{
    NSMutableArray *bookmarks=[[[NSUserDefaults standardUserDefaults] arrayForKey:@"Bookmarks"] mutableCopy];
    NSMutableArray *names=[[NSMutableArray alloc]init];
    NSMutableArray *urls=[[NSMutableArray alloc]init];
    for(NSDictionary *bookmark in bookmarks){
        [names addObject:[bookmark valueForKey:@"Name"]];
        [urls addObject:[bookmark valueForKey:@"URL"]];
    }
    bookmarksURLS=urls;
    return names;
}

- (void) viewDidLoad {
    [super viewDidLoad];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    self.delegate=self.sideMenu.navigationController.delegate;
    CGRect searchBarFrame = CGRectMake(0, 0, self.tableView.frame.size.width, 45.0);
    self.searchBar = [[UISearchBar alloc] initWithFrame:searchBarFrame];
    self.searchBar.delegate = self;
    self.tableView.backgroundView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:[[[NSUserDefaults standardUserDefaults]dictionaryForKey:@"globalImages"]valueForKey:@"buttonBackgroundColour"]]];
    self.tableView.tableHeaderView = self.searchBar;
    
    NSString *notificationName = @"InAppSettingsViewControllerDelegateWillDismissedNotification";
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(deselectSettings:)
     name:notificationName
     object:nil];
}
-(void)viewWillAppear:(BOOL)animated{
    bookmarksList=[self loadBookmarks];
//    sections=[[NSMutableArray alloc]initWithObjects:mainItems,bookmarksList,otherList, nil];
    [sections replaceObjectAtIndex:lMenuListBookmarks withObject:bookmarksList];
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:lMenuListBookmarks] withRowAnimation:UITableViewRowAnimationAutomatic];
//  [self.tableView reloadData];
}


#pragma mark -
#pragma mark - UITableViewDataSource

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [self getSectionName:section];
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
//    if ([tableView respondsToSelector:@selector(dequeueReusableHeaderFooterViewWithIdentifier:)]){
//        static NSString *headerReuseIdentifier = @"TableViewSectionHeaderViewIdentifier";
//        UITableViewHeaderFooterView *sectionHeaderView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:headerReuseIdentifier];
//        if(sectionHeaderView == nil){
//            sectionHeaderView = [[UITableViewHeaderFooterView alloc] initWithReuseIdentifier:headerReuseIdentifier];
//        }
//        
//        if(section==lMenuListBookmarks){
//            UIButton *edit=[UIButton buttonWithType:UIButtonTypeCustom];
//            [edit setTitle:@"Edit" forState:UIControlStateNormal];
//            [edit setTitle:@"Done" forState:UIControlStateSelected];
//            [edit.titleLabel setShadowColor:[UIColor darkGrayColor]];
////            [edit.titleLabel setShadowOffset:CGSizeMake(0, 1)];
//            [edit.titleLabel setFont:[UIFont boldSystemFontOfSize:18]];
//            [edit addTarget:self action:@selector(editSection:) forControlEvents:UIControlEventTouchDown];
//            edit.frame=CGRectMake(sectionHeaderView.frame.size.width-60, sectionHeaderView.textLabel.frame.origin.y, 50, sectionHeaderView.textLabel.frame.size.height);
//            [sectionHeaderView addSubview:edit];
//            sectionHeaderView.userInteractionEnabled=YES;
//        }
//        sectionHeaderView.textLabel.textColor=[UIColor whiteColor];
//        return sectionHeaderView;
//    }else{
        UIView* sectionHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, [self tableView:tableView heightForHeaderInSection:section])];
        sectionHeaderView.backgroundColor = [UIColor clearColor];
        
        UIImageView *headerImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"PlainTableViewSectionHeader"]];
        headerImage.contentMode = UIViewContentModeScaleToFill;
        headerImage.frame=sectionHeaderView.frame;
    
        [sectionHeaderView addSubview:headerImage];
        
        UILabel *sectionText = [[UILabel alloc] initWithFrame:CGRectMake(10, 2, tableView.bounds.size.width - 70, 18)];
        sectionText.text = [self tableView:tableView titleForHeaderInSection:section];
        sectionText.backgroundColor = [UIColor clearColor];
        sectionText.textColor = [UIColor whiteColor];
        sectionText.shadowColor = [UIColor darkGrayColor];
        sectionText.shadowOffset = CGSizeMake(1,1);
        sectionText.font = [UIFont boldSystemFontOfSize:18];
        
        [sectionHeaderView addSubview:sectionText];
        if(section==lMenuListBookmarks){
            UIButton *edit=[UIButton buttonWithType:UIButtonTypeCustom];
            edit.tag=69;
            
            [edit setTitle:NSLocalizedString(@"Edit", @"Edit button") forState:UIControlStateNormal];
            [edit setTitle:NSLocalizedString(@"Done", @"Done button") forState:UIControlStateSelected];
            [edit setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [edit setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
            [edit.titleLabel setShadowColor:[UIColor darkGrayColor]];
            [edit.titleLabel setShadowOffset:CGSizeMake(1, 1)];
            [edit.titleLabel setFont:[UIFont boldSystemFontOfSize:18]];
            [edit addTarget:self action:@selector(editSection:) forControlEvents:UIControlEventTouchDown];
            edit.frame=CGRectMake(sectionHeaderView.frame.size.width-60, sectionText.frame.origin.y, 50, sectionText.frame.size.height);
            if([self.tableView numberOfRowsInSection:lMenuListBookmarks]!=0) edit.enabled=YES;
            else edit.enabled=NO;
            [sectionHeaderView addSubview:edit];
            sectionHeaderView.userInteractionEnabled=YES;
        }
        
        return sectionHeaderView;
//    }
}
-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if(section==lMenuListBookmarks){
        if([self.tableView numberOfRowsInSection:lMenuListBookmarks]==0){
            static NSString *CellIdentifier = @"Cell";
            
            MenuCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cell == nil) {
                cell = [[MenuCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            }
            cell.textLabel.backgroundColor=[UIColor clearColor];
            cell.textLabel.text=NSLocalizedString(@"Your bookmarks will show here", @"Empty bookmark list footer");
            cell.textLabel.textColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"PlainTableViewSectionHeader"]];
            cell.textLabel.font=[UIFont italicSystemFontOfSize:12];
            cell.indentationLevel=2;
            cell.accessoryType=UITableViewCellAccessoryNone;
            cell.imageView.image=nil;
            return  cell;
        }return nil;
    }
    return nil;
}
-(float)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 20;
}
-(float)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if(section==lMenuListBookmarks&&bookmarksList.count==0) return 20;
    return 0;
}
-(IBAction)editSection:(id)sender{
    if([self.tableView isEditing]){
        [self.tableView setEditing:NO animated:YES];
        [(UIButton *)[self.tableView viewWithTag:69] setSelected:NO];
    }else{
        [(UIButton *)[self.tableView viewWithTag:69] setSelected:YES];
        [self.tableView setEditing:YES animated:YES];
    }
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section==lMenuListBookmarks)return YES;
    return NO;
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        NSMutableArray *bookmarks = [[[NSUserDefaults standardUserDefaults] arrayForKey:@"Bookmarks"] mutableCopy];
        [bookmarks removeObjectAtIndex:indexPath.row ];
        [bookmarksList removeObjectAtIndex:indexPath.row];
        [[NSUserDefaults standardUserDefaults] setObject:bookmarks forKey:@"Bookmarks"];
        // Animate the deletion
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationAutomatic];
        if([self.tableView numberOfRowsInSection:lMenuListBookmarks]==0){
            [self editSection:nil];
            [(UIButton *)[self.tableView viewWithTag:69] setEnabled:NO];
        }
    }
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return sections.count;
}
-(NSString *)getSectionName:(NSInteger)section{
    return[sectionNames objectAtIndex:section];
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
        cell.textLabel.font=[UIFont boldSystemFontOfSize:14];
    }else if([moreItems containsObject:cell.textLabel.text]){
        cell.indentationLevel=8;
        cell.textLabel.font=[UIFont boldSystemFontOfSize:12];
    }else{
        cell.indentationLevel=1;
        cell.textLabel.font=[UIFont systemFontOfSize:17];
    }
    if([cell.textLabel.text isEqualToString:NSLocalizedString(@"Locations", @"Locations name")]&&locationItems.count>0){
        if(locationSelect)
            cell.accessoryView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"menuDiscloseSelected"]];
        else
            cell.accessoryView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"menuDiscloseNormal"]];
    }else if([cell.textLabel.text isEqualToString:NSLocalizedString(@"Video", @"Video name")]&&videoItems.count>0){
        if(videoSelect)
            cell.accessoryView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"menuDiscloseSelected"]];
        else
            cell.accessoryView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"menuDiscloseNormal"]];
    }else if([cell.textLabel.text isEqualToString:NSLocalizedString(@"More", @"More name")]&&moreItems.count>0){
        if(moreSelect)
            cell.accessoryView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"menuDiscloseSelected"]];
        else
            cell.accessoryView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"menuDiscloseNormal"]];
    }else{
        cell.accessoryView=nil;
    }
    if(indexPath.section==lMenuListBookmarks)
        cell.imageView.image=[UIImage imageNamed:[NSString stringWithFormat:@"%@_bookmarkIcon",[[[NSUserDefaults standardUserDefaults]dictionaryForKey:@"globalImages"] valueForKey:@"name"]]];
    else
        cell.imageView.image=[UIImage imageNamed:[menuIcons valueForKey:cell.textLabel.text]];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    
    
    return cell;
}
-(void)deselectSettings:(NSNotification *)notification{
    [self.tableView deselectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:lMenuListOther] animated:YES];
}

#pragma mark -
#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell=[self.tableView.dataSource tableView:self.tableView cellForRowAtIndexPath:indexPath];
    NSString *selectedMenuItem=cell.textLabel.text;
    if(!self.tableView.isEditing){
    if(indexPath.section==lMenuListBookmarks){
        [self.delegate bookmarkLoad:[bookmarksURLS objectAtIndex:indexPath.row]];
    }else if((indexPath.section==lMenuListMain)&&(([selectedMenuItem isEqualToString:NSLocalizedString(@"Locations", @"Locations name")]&&locationItems.count>0)||([selectedMenuItem isEqualToString:NSLocalizedString(@"More", @"More name")]&&moreItems.count>0)||([selectedMenuItem isEqualToString:NSLocalizedString(@"Video", @"Video name")]&&videoItems.count>0))){
        [self manageSubCells:cell];
        return;
    }else if((indexPath.section==lMenuListOther)&&[selectedMenuItem isEqualToString:NSLocalizedString(@"Settings", @"Settings name")]){
        InAppSettingsModalViewController *settings=[[InAppSettingsModalViewController alloc]init];
        [[self.sideMenu.navigationController.viewControllers objectAtIndex:0] presentModalViewController:settings animated:YES];
    }else if((indexPath.section==lMenuListOther)&&[selectedMenuItem isEqualToString:NSLocalizedString(@"Contact", @"Contact name")]){
        [self sendMail];
    }else /*if(![indexPath isEqual: self.tableView.indexPathForSelectedRow])*/{
        [self.delegate menuTap:[NSURL URLWithString:[globalURLS valueForKey:selectedMenuItem]] menuItem:selectedMenuItem];
    }
    [self.sideMenu setMenuState:MFSideMenuStateClosed];
    
    if(self.searchBar.isFirstResponder) [self.searchBar resignFirstResponder];
    }
}
-(void)manageSubCells:(UITableViewCell *)cell{
    NSString *selection=cell.textLabel.text;
    if([[self.tableView.dataSource tableView:self.tableView cellForRowAtIndexPath:[self.tableView indexPathForSelectedRow]].textLabel.text isEqualToString:selection]){
        NSMutableArray *tempList=[[NSMutableArray alloc]initWithArray:mainList];
        if([selection isEqualToString:NSLocalizedString(@"Locations", @"Locations name")]){
            if([tempList containsObject:[locationItems objectAtIndex:0]]){
                [tempList removeObjectsInArray:locationItems];
                [tempList removeObjectsInArray:moreItems];
                locationSelect=NO;
                moreSelect=NO;
            }else{
                for(int i=0;i<locationItems.count;i++)
                    [tempList insertObject:[locationItems objectAtIndex:i] atIndex:[mainList indexOfObject:selection]+i+1];
                locationSelect=YES;
            }
        }else if([selection isEqualToString:NSLocalizedString(@"More", @"More name")]){
            if([tempList containsObject:[moreItems objectAtIndex:0]]){
                [tempList removeObjectsInArray:moreItems];
                moreSelect=NO;
            }else{
                for(int i=0;i<moreItems.count;i++)
                    [tempList insertObject:[moreItems objectAtIndex:i] atIndex:[mainList indexOfObject:selection]+i+1];
                moreSelect=YES;
            }
        }else if([selection isEqualToString:NSLocalizedString(@"Video", @"Video name")]){
            if([tempList containsObject:[videoItems objectAtIndex:0]]){
                [tempList removeObjectsInArray:videoItems];
                videoSelect=NO;
            }else{
                for(int i=0;i<videoItems.count;i++)
                    [tempList insertObject:[videoItems objectAtIndex:i] atIndex:[mainList indexOfObject:selection]+i+1];
                videoSelect=YES;
            }
        }
        mainList=[[NSMutableArray alloc]initWithArray:tempList];
        sections=[[NSMutableArray alloc]initWithObjects:mainList,bookmarksList,otherList, nil];
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
- (void)sendMail{
        if ([MFMailComposeViewController canSendMail])
        {
            MFMailComposeViewController *mailer = [[MFMailComposeViewController alloc] init];
            mailer.mailComposeDelegate = [self.sideMenu.navigationController.viewControllers objectAtIndex:0];
            [mailer setToRecipients:[NSArray arrayWithObjects:@"contact@snowbrains.com", nil]];
            [mailer setSubject:@"SnowBrains!"];
            [[self.sideMenu.navigationController.viewControllers objectAtIndex:0] presentModalViewController:mailer animated:YES];
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", @"Error for alerts")message:NSLocalizedString(@"Email unsupported, please check that you have setup an account", @"Email Error for alerts")delegate:nil cancelButtonTitle:NSLocalizedString(@"Ok", @"Ok button for alerts")otherButtonTitles: nil];
            [alert show];
        }
    [self.tableView deselectRowAtIndexPath:[NSIndexPath indexPathForRow:[otherList indexOfObject:@"Contact"] inSection:lMenuListOther] animated:YES];
}


@end
