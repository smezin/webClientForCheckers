//
//  ViewController.swift
//  webClientForCheckers

import UIKit
import SocketIO
import Foundation

class ViewController: UIViewController {
    let myUrl = "http://localhost:3000/users"
    var me: [String: Any] = [:]
    let user: [String: Any] = ["userName": "iPhoneSE",
                               "password": "abcd1234"]
    let manager = SocketManager(socketURL: URL(string: "http://localhost:3000")!, config: [.log(false), .compress])
    
    @IBOutlet weak var outputText: UITextView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        socketConnect()
  //      self.createUser(user)
    }
    
    
    @IBAction func LogoutFunc(_ sender: Any) {
        self.logout()
    }
    @IBAction func LoginFunc(_ sender: Any) {
        self.login(user)
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
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in

            if let error = error {
                print("Error took place \(error)")
                return
            }
            
            if let response = response as? HTTPURLResponse {
                print("Response HTTP Status code: \(response.statusCode)")
            }

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
                    let response = self.stringify(json: responseJSON)
                    DispatchQueue.main.async {
                        self.outputText.text = response
                        print("from createUser: ", response)
                    }
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
            if let error = error {
                print("Error took place \(error)")
                return
            }
            let responseJSON = try? JSONSerialization.jsonObject(with: data!, options: [])
                if let responseJSON = responseJSON as? [String: Any] {
                    self.me = responseJSON
                    let response = self.stringify(json: responseJSON)
                    DispatchQueue.main.async {
                        self.outputText.text = response
                        print("from login: ", response)
                    }
                }
        }
        task.resume()
    }
    
    func logout () {
        // Prepare URL
        let url = URL(string: "http://localhost:3000/users/logout")
        guard let requestUrl = url else { fatalError() }

        var request = URLRequest(url: requestUrl)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
       
        let jsonData = try? JSONSerialization.data(withJSONObject: self.me, options: .prettyPrinted)
        self.me = [:]
        // Set HTTP Request Body
        request.httpBody = jsonData
                
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print("Error took place \(error)")
                return
            }
            let responseJSON = try? JSONSerialization.jsonObject(with: data!, options: [])
                if let responseJSON = responseJSON as? [String: Any] {
                    let response = self.stringify(json: responseJSON)
                    DispatchQueue.main.async {
                        self.outputText.text = response
                        print("from logout: ", response)
                    }
                }
        }
        task.resume()
    }
    
    @IBAction func socketButton(_ sender: Any) {
        print("me: ", self.me)
        enterIdleUsersRoom()
    }
    
    func socketConnect () {
        let socket = manager.defaultSocket
         socket.on("connect") {data, ack in
            print("socket connected")
            socket.emit("hello", "iOS client says: connected")
        }

        socket.on("hello") {data, ack in
            print("from emit hello", data[0])
        }
        socket.connect()
     //   CFRunLoopRun()
    }
    
    func enterIdleUsersRoom () {
        let socket = manager.defaultSocket
        socket.emit("enterAsIdlePlayer",self.me)
        print("thats me", self.me)
    }
    
    func stringify (json:[String: Any]) -> String {
        var convertedString:String = ""
        do {
            let data1 =  try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
            convertedString = String(data: data1, encoding: String.Encoding.utf8) ?? "Conversion error"
              } catch let myJSONError {
                  print("from stringify", myJSONError)
              }
        return convertedString
    }
}
