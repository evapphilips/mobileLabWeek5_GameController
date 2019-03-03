//
//  ViewController.swift
//  gameController
//
//  Created by Eva Philips on 3/2/19.
//  Copyright © 2019 evaphilips. All rights reserved.
//

import UIKit
// include the Cocoa pod socket library
import Starscream

// direction commands
enum DirectionCode: String {
    case up = "0"
    case right = "1"
    case down = "2"
    case left = "3"
}

class ViewController: UIViewController, WebSocketDelegate {
    
    // Object for managing the web socket.
    var socket: WebSocket?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Web socket setup
        // URL of the websocket server.
        let urlString = "wss://gameserver.mobilelabclass.com"
        // create the websocket
        socket = WebSocket(url: URL(string: urlString)!)
        // Assign WebSocket delegate to self
        socket?.delegate = self
        // Connect to the web socket
        socket?.connect()
    }
    
    // Web Socket Method
    func websocketDidConnect(socket: WebSocketClient) {
        print("socket connected")
    }
    
    func websocketDidDisconnect(socket: WebSocketClient, error: Error?) {
        print("socket disconnected", error ?? "No message")
    }
    
    func websocketDidReceiveMessage(socket: WebSocketClient, text: String) {
        print("socket recieved message", text)
    }
    
    func websocketDidReceiveData(socket: WebSocketClient, data: Data) {
        print("socket recieved data", data)
    }
    


}

