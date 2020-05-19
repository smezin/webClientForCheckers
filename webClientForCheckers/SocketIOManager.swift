//
//  SocketIOManager.swift
//  webClientForCheckers
//
//  Created by hyperactive on 18/05/2020.
//  Copyright © 2020 hyperActive. All rights reserved.
//

import UIKit
import Foundation
import SocketIO

class SocketIOManager: NSObject {

    func socketConnect () {
        
        let manager = SocketManager(socketURL: URL(string: "http://localhost:8080")!, config: [.log(true), .compress])
        let socket = manager.defaultSocket

        socket.on("connect") {data, ack in
            print("socket connected")
            print("Type \"quit\" to stop")
        }

        socket.on("hello") {data, ack in
            print(data[0] as! String)
        }

        socket.connect()
      
        //CFRunLoopRun()
    }
}
