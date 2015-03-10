//
//  SqlService.h
//  Unity-iPhone
//
//  Created by 李晓剑 on 15-1-24.
//
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

#define dFilename @"lingmo.db"
@class BookmarkItem;
@interface SqlService : NSObject

@property (atomic) sqlite3 *database;

- (BOOL)createBM:(sqlite3 *)db;
- (BOOL)insertBM:(BookmarkItem *)insertItem;
- (BOOL)updateBM:(BookmarkItem *)updateItem;
- (NSMutableArray *)getBM;
- (BOOL)delBM:(BookmarkItem *)delItem;
- (BOOL)multiplyBM:(NSString *)searchString;

@end


@interface BookmarkItem : NSObject

@property (nonatomic) int bID;
@property (nonatomic, copy) NSString *bName;
@property (nonatomic, copy) NSString *bURL;

@end