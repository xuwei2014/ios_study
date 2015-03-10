//
//  Memu.m
//  Unity-iPhone
//
//  Created by 李晓剑 on 15-2-6.
//
//

#import "MenuData.h"

@interface MenuData ()

@property (nonatomic, retain) NSArray *imageArray;
@property (nonatomic, retain) NSArray *strArray;

@end

@implementation MenuData

#pragma init
- (id) init {
    if (self = [super init]) {
        self.imageArray = @[[UIImage imageNamed:@"briefcase-50.png"],
                            [UIImage imageNamed:@"bookmark-50.png"],
                            [UIImage imageNamed:@"share-50.png"]];
        self.strArray = @[@"收藏夹", @"添加收藏", @"分享"];
    }
    
    return self;
}

#pragma - Data Source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.imageArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *tableCellIdentifier = @"TableViewCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:tableCellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:tableCellIdentifier];
    }
    
    cell.imageView.image = [self.imageArray objectAtIndex:indexPath.row];
    cell.textLabel.text = [self.strArray objectAtIndex:indexPath.row];
    
    return cell;
}

#pragma - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    [self.delegate passTappedBtn:indexPath.row];
}

@end
