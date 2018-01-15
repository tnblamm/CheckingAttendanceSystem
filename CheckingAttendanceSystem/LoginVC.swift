//
//  ViewController.swift
//  CheckingAttendanceSystem
//
//  Created by Lâm Trần Nguyễn Bảo on 11/22/17.
//  Copyright © 2017 Lâm Trần Nguyễn Bảo. All rights reserved.
//

import UIKit

class LoginVC: UIViewController {

    @IBOutlet weak var _username: UITextField!
    @IBOutlet weak var _password: UITextField!
    @IBOutlet weak var _btnLogin: UIButton!
    @IBOutlet weak var _btnContactUS: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let preferences = UserDefaults.standard
        if(preferences.object(forKey: "session") != nil)
        {
            LoginDone()
        }
        else
        {
            LoginToDo()
        }
    }


    @IBAction func _btnLoginPressed(_ sender: Any) {
        
        if(_btnLogin.titleLabel?.text == "Logout")
        {
            let preferences = UserDefaults.standard
            preferences.removeObject(forKey: "session")
            LoginToDo()
            return
        }
        
        let email = _username.text
        let password = _password.text
        if(email == "" || password == "")
        {
            return
        }
        DoLogin(email!, password!)
    }
        func DoLogin(_ email:String, _ password:String )
        {
            let url = URL(string: "https://iteccyle8.herokuapp.com/authenticate/login")
            let session = URLSession.shared
            let request = NSMutableURLRequest(url: url!)
            request.httpMethod = "POST"
            let paramToSend = "email" + email + "& password= " + password
            request.httpBody = paramToSend.data(using: String.Encoding.utf8)
            let task = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) in
                guard let _:Data = data else
                {
                    return
                }
                let json:Any?
                do
                {
                    json = try JSONSerialization.jsonObject(with: data!, options:[])
                }
                catch
                {
                    return
                }
                guard let server_response = json as? NSDictionary else
                {
                    return
                }
                if let data_block = server_response["data"] as? NSDictionary
                {
                    if let session_data = data_block["session"] as? String
                    {
                        let preferences = UserDefaults.standard
                        preferences.set(session_data, forKey: "session")
                        DispatchQueue.main.async (
                            execute:self.LoginDone
                        )
                    }
                }
            })
            task.resume()
        }
    
    func LoginToDo()
    {
        _username.isEnabled = true
        _password.isEnabled = true
        _btnLogin.setTitle("Login", for: .normal)
    }
    
    func LoginDone()
    {
        _username.isEnabled = false
        _password.isEnabled = false
        _btnLogin.setTitle("Logout", for: .normal)
    }
}
