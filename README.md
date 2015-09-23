        [self.KVOController observe:self keyPath:@"name" options:NSKeyValueObservingOptionInitial|NSKeyValueObservingOptionNew block:^(id observer, id object, NSDictionary *change) {
            NSLog(@"got change %@", change);
            NSLog(@"self'name is %@", self.name);
        }];

Above code has two issues. 
1. If using self.KVOController or self.KVOControllerNonRetaining observe 'self'. It needs to use KVOControllerNonRetaining instead of KVOController to avoid retain cycle. 
2. When using self.KVOController, 'self' inside the block will create a retain cycle as well. need to weakify self. 

        [self.KVOControllerNonRetaining observe:self keyPath:@"name" options:NSKeyValueObservingOptionInitial|NSKeyValueObservingOptionNew block:^(id observer, id object, NSDictionary *change) {
            NSLog(@"got change %@", change);
        }];

After change it to KVOControllerNonRetaining, 'self' is responsible for unobserving it. otherwise, it will crash. However, there is a related PR to improve it: 
https://github.com/facebook/KVOController/pull/67

When using KVOControllerNonRetaining, it is unsafe to call unobserveAll in dealloc method. Due to it is lazyly initilized, it will crash by the time of calling dealloc, if KVOControllerNonRetaining hasn't initilized. A workaround is placed in https://github.com/caoer/KVOController/commit/6c4faa846a3b0634867850aec7b488538cd81913. Related issue discussion: https://github.com/facebook/KVOController/issues/46


other example see : ![https://github.com/caoer/FBKVOControllerTest/blob/master/FBKVOControllerTest/main.m](https://github.com/caoer/FBKVOControllerTest/blob/master/FBKVOControllerTest/main.m)
