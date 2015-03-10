//
//  PassValueDelegate.h
//  Unity-iPhone
//
//  Created by 李晓剑 on 15-1-24.
//
//

#ifndef Unity_iPhone_PassValueDelegate_h
#define Unity_iPhone_PassValueDelegate_h

#import <Foundation/Foundation.h>

@protocol PassValueDelegate <NSObject>

- (void)passValue:(NSString *)url;
- (void)passTappedBtn:(NSInteger)num;

@end

#endif
