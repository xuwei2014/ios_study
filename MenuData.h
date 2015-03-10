//
//  Memu.h
//  Unity-iPhone
//
//  Created by 李晓剑 on 15-2-6.
//
//

#import <Foundation/Foundation.h>
#import "PassValueDelegate.h"

#define TableViewCellHeight 44

@interface MenuData : NSObject <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, assign) NSObject<PassValueDelegate> *delegate;

@end
