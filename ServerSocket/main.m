//
//  main.m
//  ServerSocket
//
//  Created by yangrui on 2017/8/14.
//  Copyright © 2017年 yangrui. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ServerSocketTool.h"

int main(int argc, const char * argv[]) {
    @autoreleasepool {
       
        ServerSocketTool *serverTool = [[ServerSocketTool alloc]init];
        [serverTool start];
        
        [[NSRunLoop mainRunLoop] run];
        
    }
    return 0;
}
