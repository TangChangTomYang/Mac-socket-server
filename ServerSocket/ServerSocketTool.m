//
//  ServerSocketTool.m
//  ServerSocket
//
//  Created by yangrui on 2017/8/14.
//  Copyright © 2017年 yangrui. All rights reserved.
//

#import "ServerSocketTool.h"

@interface ServerSocketTool ()<GCDAsyncSocketDelegate>


@property(nonatomic, strong)GCDAsyncSocket *serverSocket;

@property(nonatomic, strong)NSMutableArray<GCDAsyncSocket *> *clientSockets;

@end



@implementation ServerSocketTool

-(NSMutableArray<GCDAsyncSocket *> *)clientSockets{
    if (!_clientSockets) {
        _clientSockets = [NSMutableArray array];
    }
    return _clientSockets;
}

-(void)start{

    
    GCDAsyncSocket *serverSocket = [[GCDAsyncSocket alloc]initWithDelegate:self delegateQueue:dispatch_get_global_queue(0, 0)];
    NSError *err = nil;
    
    self.serverSocket = serverSocket;
    
    //绑定和监听端口
    [serverSocket acceptOnPort:52880 error:&err];
    
    if (err == nil) {
        NSLog(@"启动 server socket  成功");
    }
    else{
    
     NSLog(@"启动 server socket 失败: %@",err);
    }
}

#pragma mark-  GCDAsyncSocketDelegate

// 当有新的 客户端socket 连接到服务器就会调用这个方法
-(void)socket:(GCDAsyncSocket *)serverSocket didAcceptNewSocket:(GCDAsyncSocket *)clientSocket{

    //1. 保存 新接入的socket 连接  否则长连接就会断开
    [self.clientSockets addObject:clientSocket];
    
    
    //1. 反馈客户端消息
    NSString *msg = [NSString stringWithFormat:@"你是第 %ld客户",self.clientSockets.count];
    [clientSocket writeData:[msg dataUsingEncoding:NSUTF8StringEncoding] withTimeout:-1 tag:0];
    
    //2. 开启监听 客户端的socket ,以便 监听客户端socket 数据写入
    [clientSocket readDataWithTimeout:-1 tag:0];
    
    
    NSLog(@"服务端 serverSocket : %@",serverSocket);
    
    NSLog(@"新接入 clientSocket : %@",clientSocket);
    
    
    clientSocket.connectedHost; // 通过这个属性可以获取客户端的ip地址
    clientSocket.connectedPort; // 通过这个属性可以获取到客户端的端口号
    
    
}


// 当监听到 有客户端写入数据就会调用这个代理方法
-(void)socket:(GCDAsyncSocket *)clientSocket didReadData:(NSData *)data withTag:(long)tag{

    NSString *msg = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    
    
    // 服务端就可以在这里 来区分 客户端传入的数据,根据接收到的不同的数据提供不同的服务 
    NSString *returnMsg = [NSString stringWithFormat:@"服务端收到数据: %@",msg];
    [clientSocket writeData:[returnMsg dataUsingEncoding:NSUTF8StringEncoding] withTimeout:-1 tag:0];
    
    // 继续监听客户端的数据写入
    [clientSocket readDataWithTimeout:-1 tag:0];

}

-(void)socketDidDisconnect:(GCDAsyncSocket *)clientSocket withError:(NSError *)err{


    for ( int i = 0; i < self.clientSockets.count; i++) {
        
        if ([self.clientSockets[i] isEqual:clientSocket]) {
            NSLog(@"第 : %d 客户掉线了",i+1);
            
            break;
        }
    }
    
    [self.clientSockets removeObject:clientSocket];
}















































































@end
