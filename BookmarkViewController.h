//
//  BookmarkViewController.h
//  Unity-iPhone
//
//  Created by 李晓剑 on 15-1-24.
//
//

#import <UIKit/UIKit.h>
#import "PassValueDelegate.h"

@interface BookmarkViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) IBOutlet UITableView *tableView;
@property (nonatomic, copy)      void (^modalCompletionHandler)(void);

@property (nonatomic, assign) NSObject<PassValueDelegate> *delegate;

@end
