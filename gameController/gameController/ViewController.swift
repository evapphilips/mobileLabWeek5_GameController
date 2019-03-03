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
        
        // Set up swipe gestures
        // swipe right
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipe))
        swipeRight.direction = UISwipeGestureRecognizer.Direction.right
        self.view.addGestureRecognizer(swipeRight)
        // swipe left
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipe))
        swipeLeft.direction = UISwipeGestureRecognizer.Direction.left
        self.view.addGestureRecognizer(swipeLeft)
        // swipe up
        let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipe))
        swipeUp.direction = UISwipeGestureRecognizer.Direction.up
        self.view.addGestureRecognizer(swipeUp)
        // swipe down
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipe))
        swipeDown.direction = UISwipeGestureRecognizer.Direction.down
        self.view.addGestureRecognizer(swipeDown)
        
    }
    
    //when a swipe gesture is detected
    @objc func respondToSwipe(gesture: UIGestureRecognizer){
        if let swipeGesture = gesture as? UISwipeGestureRecognizer{
            switch swipeGesture.direction{
            case UISwipeGestureRecognizer.Direction.right:  // swipe right
                print("Swiped right")
            case UISwipeGestureRecognizer.Direction.left: // swipe left
                print("Swiped left")
            case UISwipeGestureRecognizer.Direction.up: // swipe up
                print("Swiped Up")
            case UISwipeGestureRecognizer.Direction.down: // swipe down
                print("Swiped Down")
            default:
                break
            }
        }
    }
    
    // Web Socket Methods
    func websocketDidConnect(socket: WebSocketClient) {
        print("socket connected")
    }
    
    func websocketDidDisconnect(socket: WebSocketClient, error: Error?) {
        print("socket disconnected", error ?? "No message")
    }
    
    func websocketDidReceiveMessage(socket: WebSocketClient, text: String) {
        //print("socket recieved message", text)
    }
    
    func websocketDidReceiveData(socket: WebSocketClient, data: Data) {
        //print("socket recieved data", data)
    }
    


}

