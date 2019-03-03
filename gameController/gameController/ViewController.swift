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

class ViewController: UIViewController, WebSocketDelegate, UITextFieldDelegate {
    
    // Object for managing the web socket.
    var socket: WebSocket?
    
    // setup user ID text field
    var userInput: UITextField!
    // setup user ID submit button
    var submit: UIButton!
    // setup user ID label
    var userIDLabel: UILabel!
    // setup error label
    var errorLabel: UILabel!
    var errorLabelAppeared: Bool! = false
    // setup disconnect button
    var disconnect: UIButton!
    // setup guide label
    var guideLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // set background color
        view.backgroundColor = UIColor(red:0.95, green:0.93, blue:0.93, alpha:1.0)
        
        // Web socket setup
        // URL of the websocket server.
        let urlString = "wss://gameserver.mobilelabclass.com"
        // create the websocket
        socket = WebSocket(url: URL(string: urlString)!)
        // Assign WebSocket delegate to self
        socket?.delegate = self
        
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
        
        // include user ID text field
        userInput = UITextField(frame: CGRect(x: self.view.frame.width/2 - (2*self.view.frame.width/3)/2 , y: self.view.frame.height/2 - (60/2), width: 2*self.view.frame.width/3, height: 60))
        userInput.placeholder = "type your player ID"
        userInput.font = UIFont.systemFont(ofSize: 30)
        userInput.borderStyle = .roundedRect
        userInput.returnKeyType = UIReturnKeyType.done
        userInput.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
        userInput.clearButtonMode = UITextField.ViewMode.whileEditing;
        userInput.delegate = self
        //userInput.addTarget(self, action: #selector(donePressed), for: .allEditingEvents)
        self.view.addSubview(userInput)
        
        // include a submit button
        submit = UIButton(frame: CGRect(x: self.view.frame.width/2 - (100/2), y: 3*self.view.frame.height/4 - (30/2), width: 100, height: 30))
        submit.backgroundColor = .black
        submit.layer.cornerRadius = 10
        submit.setTitle("submit", for: .normal)
        submit.addTarget(self, action: #selector(submitPressed), for: .touchUpInside)
        self.view.addSubview(submit)
        
        // include guide label
        guideLabel = UILabel(frame: CGRect(x: 0, y: self.view.frame.height/2 - (25/2), width: self.view.frame.width, height: 30))
        guideLabel.text = "Swipe in any direction to move"
        guideLabel.textAlignment = .center
        guideLabel.textColor = .gray
        guideLabel.font = UIFont.systemFont(ofSize: 25)
        self.view.addSubview(guideLabel)
        guideLabel.isHidden = true
        
        
    }
    
    //when a swipe gesture is detected
    @objc func respondToSwipe(gesture: UIGestureRecognizer){
        if let swipeGesture = gesture as? UISwipeGestureRecognizer{
            switch swipeGesture.direction{
            case UISwipeGestureRecognizer.Direction.right:  // swipe right
                print("Swiped right")
                setDirectionMessage(.right)
                view.backgroundColor = UIColor(red:0.62, green:0.71, blue:0.78, alpha:1.0)
                guideLabel.textColor = .white
                guideLabel.text = "right"
            case UISwipeGestureRecognizer.Direction.left: // swipe left
                print("Swiped left")
                setDirectionMessage(.left)
                view.backgroundColor = UIColor(red:0.30, green:0.49, blue:0.54, alpha:1.0)
                guideLabel.textColor = .white
                guideLabel.text = "left"
            case UISwipeGestureRecognizer.Direction.up: // swipe up
                print("Swiped Up")
                setDirectionMessage(.up)
                view.backgroundColor = UIColor(red:0.53, green:0.91, blue:0.72, alpha:1.0)
                guideLabel.textColor = .white
                guideLabel.text = "up"
            case UISwipeGestureRecognizer.Direction.down: // swipe down
                print("Swiped Down")
                setDirectionMessage(.down)
                view.backgroundColor = UIColor(red:0.27, green:0.71, blue:0.61, alpha:1.0)
                guideLabel.textColor = .white
                guideLabel.text = "down"
            default:
                break
            }
        }
    }
    
   // when done is pressed, dismiss the keyboard
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return false
    }
    
    // when the submit button is pressed
    @objc func submitPressed(){
        // store the current user Input string
        let userID = userInput.text
        
        // hide the text field and the button
        if(userID == ""){ // check if the user ID was input
            print("not a valid player ID")
            // add a label that says not a valid user ID
            errorLabel = UILabel(frame: CGRect(x: 0, y: self.view.frame.height/12, width: self.view.frame.width, height: 60))
            errorLabel.text = "Not a valid user ID"
            errorLabel.textAlignment = .center
            errorLabel.font = UIFont.systemFont(ofSize: 30)
            self.view.addSubview(errorLabel)
            errorLabelAppeared = true;
        } else{  // if the user ID was input, continue
            // hide the intro page
            self.submit.isHidden = true
            self.userInput.isHidden = true
            if(errorLabelAppeared){
                self.errorLabel.isHidden = true
            }
    
            // add and display user id label at the top
            userIDLabel = UILabel(frame: CGRect(x: 0, y: self.view.frame.height/12, width: self.view.frame.width, height: 60))
            userIDLabel.text = "Player ID: " + userID!
            userIDLabel.textAlignment = .center
            userIDLabel.font = UIFont.systemFont(ofSize: 30)
            self.view.addSubview(userIDLabel)
            
            // add a disconnect button
            disconnect = UIButton(frame: CGRect(x: self.view.frame.width/2 - (200/2), y: self.view.frame.height - self.view.frame.height/12, width: 200, height: 30))
            disconnect.backgroundColor = .black
            disconnect.layer.cornerRadius = 10
            disconnect.setTitle("leave the game", for: .normal)
            disconnect.addTarget(self, action: #selector(disconnectPressed), for: .touchUpInside)
            self.view.addSubview(disconnect)
            
            // show guide label
            guideLabel.isHidden = false
            guideLabel.textColor = .gray
            
            
            // Connect to the web socket
            socket?.connect()
        }
    }
    
    // when the disconnect button is pressed
    @objc func disconnectPressed(){
        
        // set background color
        view.backgroundColor = UIColor(red:0.95, green:0.93, blue:0.93, alpha:1.0)
        
        // Disconnect from the web socket
        socket?.disconnect()
        
        // re-define the error label
        errorLabelAppeared = false
        
        // hide the user ID Label
        userIDLabel.isHidden = true
        // hide the disconnect button
        disconnect.isHidden = true
        // hide the guide and set it back to the origin value
        guideLabel.isHidden = true
        guideLabel.text = "Swipe in any direction to move"
        // show the submit button
        submit.isHidden = false
        // show text field
        userInput.isHidden = false
        userInput.text = ""
        
        
    }
    
    // set direction message
    func setDirectionMessage(_ code: DirectionCode){
        // Get the raw string value from the DirectionCode enum that we created at the top of this program.
        sendMessage(code.rawValue)
        
    }
    
    // send message to the websocket
    func sendMessage(_ message: String){
        // check if there is a valid player id set
        guard let playerID = userInput.text else{
            print("not a valid player ID")
            return
        }
        
        // prepare server message
        let message = "\(playerID), \(message)"
        // send message to the websocket
        socket?.write(string: message){
            print("this message was send to the server:", message)
        }
        
    }
//
//        // Construct server message and write to socket. ///////////
//        let message = "\(playerId), \(message)"
//        socket?.write(string: message) {
//            // This is a completion block.
//            // We can write custom code here that will run once the message is sent.
//            print("⬆️ sent message to server: ", message)
//        }
//        ///////////////////////////////////////////////////////////
//    }
    
    // Web Socket Methods
    func websocketDidConnect(socket: WebSocketClient) {
        print("socket connected")
    }
    
    func websocketDidDisconnect(socket: WebSocketClient, error: Error?) {
        print("socket disconnected", error ?? "No message")
    }
    
    func websocketDidReceiveMessage(socket: WebSocketClient, text: String) {
        // print("socket recieved message", text)
    }
    
    func websocketDidReceiveData(socket: WebSocketClient, data: Data) {
        //print("socket recieved data", data)
    }
    


}

