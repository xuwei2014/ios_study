//
//  BookmarkViewController.m
//  Unity-iPhone
//
//  Created by 李晓剑 on 15-1-24.
//
//

#import "BookmarkViewController.h"
#import "SqlService.h"

#define INFO_TITLE @"灵墨视界"
#define INFO_URL @"http://huituzhixin.com:6688/jianpai/About/index.html"

@interface BookmarkViewController ()

@property NSMutableArray *items;
@property UIBarButtonItem *backItem;
@property SqlService *sqlSer;

@end

@implementation BookmarkViewController

-(void)loadView
{
    self.view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.view.backgroundColor = [UIColor colorWithWhite:0.9f alpha:1.0f];
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidLoad {
    self.title = @"Bookmarks";

    
    self.backItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemReply target:self action:@selector(backAction)];
    self.navigationItem.leftBarButtonItem = self.backItem;
    //[super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.sqlSer = [[SqlService alloc] init];
  
    if ([self.sqlSer multiplyBM:INFO_URL] ==  NO) {
        BookmarkItem *item = [[BookmarkItem alloc] init];
        item.bName = INFO_TITLE;
        item.bURL = INFO_URL;
        if ([self.sqlSer insertBM:item]) {
            NSLog(@"insert the default info page!");
        }
        [item release];
    }
    
    _items = [self.sqlSer getBM];
    NSLog(@"total count: %d", _items.count);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)backAction {
    //[self.delegate passValue:@"http://bing.com"];
    [self.presentingViewController dismissViewControllerAnimated:YES completion:self.modalCompletionHandler];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma - Data Source 

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[self items] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *tableCellIdentifier = @"TableViewCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:tableCellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:tableCellIdentifier];
    }
    
    BookmarkItem *item = [self.items objectAtIndex:indexPath.row];
    cell.textLabel.text = item.bName;
    
    return cell;
}

#pragma - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    BookmarkItem *tappedItem = [self.items objectAtIndex:indexPath.row];
    [self.delegate passValue:tappedItem.bURL];
    [self.presentingViewController dismissViewControllerAnimated:YES completion:self.modalCompletionHandler];
}

#pragma - Editing

- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    [super setEditing:editing animated:animated];
    [self.tableView setEditing:editing animated:YES];
    
    if (editing) {
        self.navigationItem.leftBarButtonItem = nil;
    } else {
        self.navigationItem.leftBarButtonItem = self.backItem;
    }
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // delete item in the DB
        [self.sqlSer delBM:[self.items objectAtIndex:indexPath.row]];
        [self.items removeObjectAtIndex:indexPath.row];

        [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

@end
