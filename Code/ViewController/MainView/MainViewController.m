//
//  MainViewController.m
//  PokeRecords
//
//  Created by benjenq on 2016/10/27.
//  Copyright 2016 benjenq . All rights reserved.
//

#import "MainViewController.h"
#import "ResultCell.h"

#import "EditorViewController.h"
@interface MainViewController () {
    IBOutlet UITableView *_tableView;
    IBOutlet UISearchBar *_searchBar;
    
    NSMutableArray *_dataSource;
}

@end

@implementation MainViewController

// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
/*
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization.
    }
    return self;
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]) {
        self.edgesForExtendedLayout = UIRectEdgeAll;
        self.automaticallyAdjustsScrollViewInsets = YES;
    }
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"EditorViewBG"]];
    
    self.title = NSLocalizedString(@"MAINVIEWTITLE", @"MAINVIEWTITLE");
    
    NSLog(@"%@",[UIApplication GetDocumentPath]);
    
    if (_tableView) {
        [_tableView setDataSource:(id<UITableViewDataSource> _Nullable)self];
        [_tableView setDelegate:(id<UITableViewDelegate> _Nullable)self];
    }
    
    if (_searchBar) {
        [_searchBar setDelegate:(id<UISearchBarDelegate> _Nullable)self];
        _searchBar.placeholder = NSLocalizedString(@"SEARCH_PLACEHOLDER", @"SEARCH_PLACEHOLDER");
    }
    
    UIBarButtonItem *addBtn = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addPKMRecord:)] autorelease];
    
    self.navigationItem.rightBarButtonItem = addBtn;
    
    UIBarButtonItem *pasteboardBtn = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(outputToPasteboard:)] autorelease];
    
    self.navigationItem.leftBarButtonItem = pasteboardBtn;
    
    [self renewDataSource];
    
}

- (void)renewDataSource{
    if (!_dataSource || _dataSource == nil) {
        _dataSource = [[NSMutableArray alloc] init];
    }
    else
    {
        [_dataSource removeAllObjects];
    }
    
    
}
- (void)viewDidAppear:(BOOL)animated{
    [FetchDataProc fetchPKMRecordArray:_dataSource keyword:_searchBar.text completion:^(BOOL success, NSMutableArray *resultArray) {
        [_tableView reloadData];
    }];
    
    
}
#pragma mark - @protocol UITableViewDataSource<NSObject>

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataSource.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell;
    //NSLog(@"cellForRowAtIndexPath");
    if (tableView == _tableView) {
        ResultCell *rcell = [tableView dequeueReusableCellWithIdentifier:@"ResultCell"];
        if (!rcell || rcell == nil) {
            [tableView registerNib:[UINib nibWithNibName:@"ResultCell" bundle:nil] forCellReuseIdentifier:@"ResultCell"];
            rcell = [tableView dequeueReusableCellWithIdentifier:@"ResultCell"];
        }
        
        PKMRecord *obj = [_dataSource objectAtIndex:indexPath.row];
        
        [rcell bindValueWithRecord:obj];
        
        cell = rcell;
    }
    return cell;
}

#pragma mark - UITableViewDelegate


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        PKMRecord *obj = [_dataSource objectAtIndex:indexPath.row];
        [obj deleteRec];
        [_dataSource removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationRight];
        //[tableView reloadData];
        
        NSLog(@"資料刪除...");
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [_searchBar setShowsCancelButton:NO animated:YES];
    [_searchBar resignFirstResponder];
    
    PKMRecord *obj = [_dataSource objectAtIndex:indexPath.row];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self gotoEditorViewController:obj];
    
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [_searchBar setShowsCancelButton:NO animated:YES];
    [_searchBar resignFirstResponder];
}

#pragma mark - keywordSearch @protocol UISearchBarDelegate <UIBarPositioningDelegate>

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    [searchBar setShowsCancelButton:YES animated:YES];
    return YES;
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    [searchBar setShowsCancelButton:NO animated:YES];
    [searchBar resignFirstResponder];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    [FetchDataProc fetchPKMRecordArray:_dataSource keyword:searchBar.text completion:^(BOOL success, NSMutableArray *resultArray) {
        if (!success) {
            return ;
        }
        
        [_tableView reloadData];
        
    }];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [searchBar setShowsCancelButton:NO animated:YES];
    [searchBar resignFirstResponder];
}

#pragma mark -

- (void)addPKMRecord:(id)sender{
    [self gotoEditorViewController:nil];
}

- (void)outputToPasteboard:(id)sender{
    [FetchDataProc toPasteboard:_dataSource keyword:_searchBar.text completion:^(BOOL success, NSMutableArray *resultArray) {
        if (!success) {
            return ;
        }
        UIAlertView *alt = [[UIAlertView alloc] initWithTitle:@""
                                                      message:NSLocalizedString(@"PASTEBOARDMSG", @"PASTEBOARDMSG")
                                                     delegate:nil
                                            cancelButtonTitle:NSLocalizedString(@"BTNOK", @"BTNOK")
                                            otherButtonTitles: nil];
        [alt show];
        [alt release];
    }];
}

- (void)gotoEditorViewController:(PKMRecord *)obj{
    EditorViewController *vc = [[EditorViewController alloc] initWithPKMRecord:obj];
    [self.navigationController pushViewController:vc animated:YES];
    [vc release];
}



/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}


@end
