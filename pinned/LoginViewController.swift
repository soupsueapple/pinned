//
//  LoginViewController.swift
//  pinned
//
//  Created by 汤坤 on 2017/3/31.
//  Copyright © 2017年 Kun Soup. All rights reserved.
//

import UIKit
import AFNetworking

class LoginViewController: BaseViewController, UITextFieldDelegate{
    
    @IBOutlet weak var usernameTF: UITextField!
    
    @IBOutlet weak var passwordTF: UITextField!
    
    @IBAction func doLogin(_ sender: UIButton) {
        loginPost()
    }

    @IBAction func doFogetPassword(_ sender: UIButton) {
    }
    
    @IBAction func do1Password(_ sender: UIButton) {
    }
    
    @IBAction func doAPIToken(_ sender: UIButton) {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        usernameTF.delegate = self
        usernameTF.tag = 0;
        
        passwordTF.delegate = self
        passwordTF.tag = 1;
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loginPost(){
        if usernameTF.text?.length == 0 || passwordTF.text?.length == 0 {
            
            showAlert(text: "请输入用户名或密码")
            
            return
        }
        
        AFAppDotNetAPIClient.shareAFAppDotNetAPIClient().loginRequest(username: usernameTF.text, password: passwordTF.text)
        CacheData.saveCache(key: "username", value: usernameTF.text!)
        CacheData.saveCache(key: "password", value: passwordTF.text!)
        
        let mainViewController = MainViewController()
        present(mainViewController, animated: true, completion: {() -> Void in
        
            
            
        })
        
    }
    
    func postsUpdate(){
        
        AFAppDotNetAPIClient.shareAFAppDotNetAPIClient().getRequest(url: "posts/update", paramters: nil, block: {(json: Any?, error: Error?) -> Void in
            
            if AFAppDotNetAPIClient.shareAFAppDotNetAPIClient().httpError(error: error) {
                self.showAlert(text: error?.localizedDescription)
                
                return
            }
            
            let data = json as! Data
            
            let jsonData = try?JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions(rawValue: UInt(0)))
            
            let jsonDic: Dictionary = jsonData as! Dictionary<String, String>
            
            if let update_time = jsonDic["update_time"]{
                print(update_time)
            }
            
//            if let jsonStr = String(data: data, encoding: String.Encoding.utf8) {
//                print(jsonStr)
//            }
            
            
            
        })
    }
    
    // MARK: TextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField.tag == 0{
            passwordTF.becomeFirstResponder()
        }else if textField.tag == 1{
            passwordTF.resignFirstResponder()
            
            loginPost()
        }
        
        return true
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
