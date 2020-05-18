//
//  ViewController.swift
//  webClientForCheckers

import UIKit
import SocketIO

//https://shahaf-mezin-chat-nodejs.herokuapp.com
class ViewController: UIViewController {
    let myUrl = "http://localhost:3000/users"
    var me: [String: Any] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let user: [String: Any] = ["userName": "liat580",
                    "password": "abcd1234"]
        login(user)
        do {
            sleep(5)
        }
        logout()
   //     getUserByUserName("liat530")
    }
    
    
    func getUserByUserName (_ userName: String) {
        // Create URL
        let url = URL(string: "http://localhost:3000/users/:liat510")
        guard let requestUrl = url else { fatalError() }
        // Create URL Request
        var request = URLRequest(url: requestUrl)
        // Specify HTTP Method to use
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
       
    
        // Send HTTP Request
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            // Check if Error took place
            if let error = error {
                print("Error took place \(error)")
                return
            }
            
            // Read HTTP Response Status code
            if let response = response as? HTTPURLResponse {
                print("Response HTTP Status code: \(response.statusCode)")
            }
            
            // Convert HTTP Response Data to a simple String
            if let data = data, let dataString = String(data: data, encoding: .utf8) {
                print("Response data string:\n \(dataString)")
            }
            
        }
        
        task.resume()
    }
    
    func createUser (_ user: [String: Any]) {
        // Prepare URL
        let url = URL(string: "http://localhost:3000/users")
        guard let requestUrl = url else { fatalError() }

        // Prepare URL Request Object
        var request = URLRequest(url: requestUrl)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
       
        
        let jsonData = try? JSONSerialization.data(withJSONObject: user, options: .prettyPrinted)
        
        // Set HTTP Request Body
        request.httpBody = jsonData
                
        // Perform HTTP Request
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                // Check for Error
                if let error = error {
                    print("Error took place \(error)")
                    return
                }
                let responseJSON = try? JSONSerialization.jsonObject(with: data!, options: [])
                    if let responseJSON = responseJSON as? [String: Any] {
                        self.me = responseJSON
                        print("Created:", responseJSON)
                    }
        }
        task.resume()
    }
    
    func login (_ user: [String: Any]) {
        // Prepare URL
        let url = URL(string: "http://localhost:3000/users/login")
        guard let requestUrl = url else { fatalError() }

        // Prepare URL Request Object
        var request = URLRequest(url: requestUrl)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
       
        
        let jsonData = try? JSONSerialization.data(withJSONObject: user, options: .prettyPrinted)
        
        // Set HTTP Request Body
        request.httpBody = jsonData
                
        // Perform HTTP Request
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                // Check for Error
                if let error = error {
                    print("Error took place \(error)")
                    return
                }
                let responseJSON = try? JSONSerialization.jsonObject(with: data!, options: [])
                    if let responseJSON = responseJSON as? [String: Any] {
                        self.me = responseJSON
                        print("Login: ", responseJSON)
                    }
        }
        task.resume()
    }
    
    func logout () {
        // Prepare URL
        let url = URL(string: "http://localhost:3000/users/logout")
        guard let requestUrl = url else { fatalError() }

        // Prepare URL Request Object
        var request = URLRequest(url: requestUrl)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
       

        let jsonData = try? JSONSerialization.data(withJSONObject: self.me, options: .prettyPrinted)

        // Set HTTP Request Body
        request.httpBody = jsonData
                
        // Perform HTTP Request
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                // Check for Error
                if let error = error {
                    print("Error took place \(error)")
                    return
                }
                let responseJSON = try? JSONSerialization.jsonObject(with: data!, options: [])
                    if let responseJSON = responseJSON as? [String: Any] {
                        print("Logout: ", responseJSON)
                    }
        }
        task.resume()
    }
    
}



/*
   /*
       let manager = SocketManager(socketURL: URL(string: "http://localhost:3000")!, config: [.log(false)])
       let socket = manager.defaultSocket
       
       socket.on(clientEvent: .connect) {data, ack in
           print("----------socket connected------------")
           socket.emit("hello", "Im connected")
       }
       socket.on("hello") {data, ack in
           print(data.description)
       }
       socket.connect()
        */
 */
