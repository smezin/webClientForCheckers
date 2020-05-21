//
//  ViewController.swift
//  webClientForCheckers

import UIKit
import SocketIO
import Foundation

class ViewController: UIViewController {
    var me: [String: Any] = [:]
    let scheme = "http"
    let port = 3000
    let host = "localhost"
    
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
    @IBAction func toSE(_ sender: Any) {
        self.emitToOther()
    }
    
    func createUser (_ user: [String: Any]) {
        
        let url = self.setURLWithPath(path: "/users")
        var request = self.setRequestTypeWithHeaders(method: "POST", url: url)
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

        let url = self.setURLWithPath(path: "/users/login")
        var request = self.setRequestTypeWithHeaders(method: "POST", url: url)
        let jsonData = try? JSONSerialization.data(withJSONObject: user, options: .prettyPrinted)
        request.httpBody = jsonData

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
 
        let url = self.setURLWithPath(path: "/users/logout")
        var request = self.setRequestTypeWithHeaders(method: "POST", url: url)
        let jsonData = try? JSONSerialization.data(withJSONObject: self.me, options: .prettyPrinted)
        self.me = [:]

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
        enterIdleUsersRoom()
    }
    
    func socketConnect () {
        let socket = manager.defaultSocket
         socket.on("connect") {data, ack in
            print("socket connected")
            socket.emit("hello", "iOS client says: connected")
        }
        socket.on("IdlePlayers") {data, ack in
            print("players in the room:", data[0])
        }
        socket.on("reply") {data, ack in
            print("msg from any:", data[0])
        }
        
        socket.connect()
     //   CFRunLoopRun()
    }
    
    func enterIdleUsersRoom () {
        let socket = manager.defaultSocket
        socket.emit("enterAsIdlePlayer",self.me)
    }
    func emitToOther () {
        let socket = manager.defaultSocket
        socket.emit("play",[self.me, "hello from myself"])
    }
   
    
                                            //utility funcs//
    
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
    func setURLWithPath (path:String) -> URL {
        var components = URLComponents()
        components.scheme = scheme
        components.host = host
        components.port = port
        components.path = path
        return components.url!
    }
    func setRequestTypeWithHeaders (method:String, url:URL) -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        return request
    }
}

/*
 
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
   
 */
