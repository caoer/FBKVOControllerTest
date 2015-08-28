//
//  main.m
//  FBKVOControllerTest
//
//  Created by Zitao Xiong on 8/28/15.
//  Copyright (c) 2015 Zitao Xiong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSObject+FBKVOController.h"

@interface Person : NSObject

@property (strong) NSString *name;

@end

@implementation Person
//- (void)dealloc {
//    [self.KVOControllerNonRetaining unobserveAll];
//}
- (void)dealloc {
    [self.KVOControllerNonRetaining unobserveAll];
    NSLog(@"I got deallocaed");
}
@end


int main(int argc, const char * argv[]) {
    @autoreleasepool {
        Person *p1 = [Person new];
//        p1.KVOControllerNonRetaining;
        
        // EXAMPLE 1
        {
            Person *p2 = [Person new];
            [p2.KVOControllerNonRetaining observe:p2 keyPath:@"name" options:0 block:^(id observer, id object, NSDictionary *change) {
                NSLog(@"p2 changed!");
            }];
        }
        
        // EXAMPLE 2
//        {
//            Person *p3 = [Person new];
//            [p1.KVOControllerNonRetaining observe:p3 keyPath:@"name" options:0 block:^(id observer, id object, NSDictionary *change) {
//                NSLog(@"p3 changed!");
//            }];
//        }
    }
    return 0;
}
