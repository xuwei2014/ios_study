//
//  SqlService.m
//  Unity-iPhone
//
//  Created by 李晓剑 on 15-1-24.
//
//

#import "SqlService.h"

@implementation SqlService

- (id)init
{
    return self;
}

- (void)dealloc
{
    [super dealloc];
}

- (NSString *)dataFilePath {
    //NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentationDirectory, NSUserDomainMask, YES);
    //NSString *docDir = [paths objectAtIndex:0];
    NSString *docDir = NSHomeDirectory();
    docDir = [docDir stringByAppendingPathComponent:@"Documents"];
    NSLog(@"DB path dir : %@", docDir);
    return [docDir stringByAppendingPathComponent:dFilename];
}

- (BOOL)openDB {
    NSString *path = [self dataFilePath];
 
    NSLog(@"DB path:  %@", path);
        
    if (sqlite3_open([path UTF8String], &_database) != SQLITE_OK) {
        sqlite3_close(_database);
        NSLog(@"Error: open database fail!");
        return NO;
    }
        
    [self createBM:_database];
        
    return YES;
}

- (BOOL)createBM:(sqlite3 *)db {
    char *sql = "CREATE TABLE if not exists favorite (id INTEGER PRIMARY KEY, name TEXT NOT NULL, url TEXT NOT NULL)";
    sqlite3_stmt *stat;
    NSInteger sqlRet = sqlite3_prepare_v2(_database, sql, -1, &stat, nil);
    if (sqlRet != SQLITE_OK) {
        NSLog(@"Error: prepare creating the bookmarks table fail!");
        return NO;
    }
    
    int success = sqlite3_step(stat);
    sqlite3_finalize(stat);
    
    if (success != SQLITE_DONE) {
        NSLog(@"Error: create the bookmarks table fail!");
        return NO;
    }
    
    NSLog(@"Create the bookmarks table successful");
    return YES;
}


- (BOOL)insertBM:(BookmarkItem *)insertItem {
    if ([self openDB]) {
        static char *sql = "INSERT INTO favorite(id, name, url) VALUES(?, ?, ?)";
        sqlite3_stmt *stat;
        int success = sqlite3_prepare_v2(_database, sql, -1, &stat, nil);
        if (success != SQLITE_OK) {
            NSLog(@"Error: prepare failed: insert");
            sqlite3_close(_database);
            return NO;
        }
        
        sqlite3_bind_text(stat, 2, [insertItem.bName UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(stat, 3, [insertItem.bURL UTF8String], -1, SQLITE_TRANSIENT);
        
        success = sqlite3_step(stat);
        sqlite3_finalize(stat);
        
        if(success == SQLITE_ERROR) {
            NSLog(@"Error: fail to insert into bookmarks");
            sqlite3_close(_database);
            return NO;
        }
        
        sqlite3_close(_database);
        return YES;
    }
    return NO;
}

- (NSMutableArray*)getBM {
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:10];
    if ([self openDB]) {
        sqlite3_stmt *stat;
        char *sql = "SELECT id, name, url FROM favorite";
        if (sqlite3_prepare_v2(_database, sql, -1, &stat, nil) != SQLITE_OK) {
            NSLog(@"Error: failed to prepare getBM");
            return NO;
        } else {
            while (sqlite3_step(stat) == SQLITE_ROW) {
                BookmarkItem *item = [[BookmarkItem alloc] init];
                item.bID = sqlite3_column_int(stat, 0);
                item.bName = [NSString stringWithUTF8String:(char *)sqlite3_column_text(stat, 1)];
                item.bURL = [NSString stringWithUTF8String:(char *)sqlite3_column_text(stat, 2)];
                [array addObject:item];
                [item release];
            }
        }
        sqlite3_finalize(stat);
        sqlite3_close(_database);
    }
    return [array retain];
}

- (BOOL)updateBM:(BookmarkItem *)updateItem {
    return NO;
}

- (BOOL)delBM:(BookmarkItem *)delItem {
    if ([self openDB]) {
        sqlite3_stmt *stat;
        static char *sql = "delete from favorite where id = ?";
        
        int success = sqlite3_prepare_v2(_database, sql, -1, &stat, nil);
        if (success != SQLITE_OK) {
            NSLog(@"Error: failed to prepare delDB");
            sqlite3_close(_database);
            return NO;
        }
        
        sqlite3_bind_int(stat, 1, delItem.bID);
        
        success = sqlite3_step(stat);
        sqlite3_finalize(stat);
        if (success == SQLITE_ERROR) {
            NSLog(@"Error: failed to delete the database with message");
            sqlite3_close(_database);
            return NO;
        }
        sqlite3_close(_database);
        return YES;
    }
    return NO;
}

- (BOOL)multiplyBM:(NSString *)searchString {
    if ([self openDB]) {
        sqlite3_stmt *stat = nil;
        NSString *querySQL = [NSString stringWithFormat:@"SELECT * from favorite where url like \"%@\"", searchString];
        const char *sql = [querySQL UTF8String];
        if (sqlite3_prepare_v2(_database, sql, -1, &stat, nil) != SQLITE_OK) {
            NSLog(@"Error: failed to prepare searchBM");
        } else {
            while (sqlite3_step(stat) == SQLITE_ROW) {
                sqlite3_finalize(stat);
                sqlite3_close(_database);
                return YES;
            }
        }
        sqlite3_finalize(stat);
        sqlite3_close(_database);
    }
    
    return NO;
}

@end


@implementation BookmarkItem

- (id)init
{
    _bID = 0;
    _bName = @"";
    _bURL = @"";
    return self;
}

- (void) dealloc
{
    if ((_bName != nil) && (_bURL) != nil) {
        [_bName release];
        [_bURL release];
    }
    
    [super dealloc];
}

@end
