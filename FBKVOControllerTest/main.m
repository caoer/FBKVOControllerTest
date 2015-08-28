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
@property (nonatomic, strong) Person *child;
@end

@implementation Person
//- (void)dealloc {
//    [self.KVOControllerNonRetaining unobserveAll];
//}
- (void)dealloc {
    [self fb_unobserveAll];
    NSLog(@"I got deallocaed, my name is %@", self.name);
}
@end


int main(int argc, const char * argv[]) {
    @autoreleasepool {
        Person *p1 = [Person new];
       p1.name = @"p1";
        // EXAMPLE 1
        {
            Person *p2 = [Person new];
            p2.name = @"p2";
            [p2.KVOControllerNonRetaining observe:p2 keyPath:@"name" options:0 block:^(id observer, id object, NSDictionary *change) {
                NSLog(@"p2 changed!");
            }];
        }
        
        // EXAMPLE 2 [CRASH] observer has no link to observee, if observee got dealloc first, it will cause crash.
        // See example 2A compared to 2B
//        {
//            Person *p3 = [Person new];
//            [p1.KVOControllerNonRetaining observe:p3 keyPath:@"name" options:0 block:^(id observer, id object, NSDictionary *change) {
//                NSLog(@"p3 changed!");
//            }];
//        }
        // Example 2A [CRASH]
//        {
//            Person *p4 = [Person new];
//            Person *p5 = [Person new];
//            [p4.KVOControllerNonRetaining observe:p5 keyPath:@"name" options:0 block:^(id observer, id object, NSDictionary *change) {
//                NSLog(@"p5 changed");
//            }];
//        }

        //Example 2B
        {
            Person *p4 = [Person new];
            p4.name = @"P4";
            Person *p5 = [Person new];
            p5.name = @"P5";
            [p5.KVOControllerNonRetaining observe:p4 keyPath:@"name" options:0 block:^(id observer, id object, NSDictionary *change) {
                NSLog(@"p5 changed");
            }];
        }
        // EXAMPLE 4
        {
            Person *parent = [Person new];
            Person *child = [Person new];
            parent.child = child;
            
            [parent.KVOControllerNonRetaining observe:parent keyPath:@"name" options:0 block:^(id observer, id object, NSDictionary *change) {
                NSLog(@"parent got change");
            }];
            [parent.KVOControllerNonRetaining observe:child keyPath:@"name" options:0 block:^(id observer, id object, NSDictionary *change) {
                NSLog(@"parent observe child and child got change");
            }];
            [parent.KVOControllerNonRetaining observe:parent keyPath:@"child.name" options:0 block:^(id observer, id object, NSDictionary *change) {
                NSLog(@"parent observe parent and child got change");
            }];
            parent.name = @"parent";
            child.name = @"child";
        }
    }
    return 0;
}
