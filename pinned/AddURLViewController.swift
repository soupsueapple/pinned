//
//  AddURLViewController.swift
//  pinned
//
//  Created by 汤坤 on 2017/4/11.
//  Copyright © 2017年 Kun Soup. All rights reserved.
//

import UIKit

class AddURLViewController: BaseViewController, UITextFieldDelegate, UITextViewDelegate{

    @IBOutlet weak var url_TF: UITextField!
    @IBOutlet weak var title_TF: UITextField!
    @IBOutlet weak var description_TV: UITextView!
    @IBOutlet weak var tags_TF: UITextField!
    @IBOutlet weak var private_SW: UISwitch!
    @IBOutlet weak var readLater_SW: UISwitch!
    
    var isRefreshMainTable = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        url_TF.delegate = self
        url_TF.tag = 1
        
        title_TF.delegate = self
        title_TF.tag = 2
        
        description_TV.delegate = self
        description_TV.tag = 3
        
        tags_TF.delegate = self
        tags_TF.tag = 4
    }

    @IBAction func doSaveURL(_ sender: Any) {
        
        doAddRequest()
        
    }
    
    @IBAction func doCancel(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    // MARK: Add Bookmark
    func doAddRequest(){
        
        if url_TF.text?.length == 0{
            self.showAlert(text: "Place input URL")
            
            return
        }
        
        if title_TF.text?.length == 0{
            self.showAlert(text: "Place input description")
            
            return
        }
        
        let privateStr = private_SW.isOn ? "yes":"no"
        let readLaterStr = readLater_SW.isOn ? "yes":"no"
        
        let paramters = ["url": url_TF.text!, "description": title_TF.text!, "tags": tags_TF.text!,"extended": description_TV.text!, "shared": privateStr, "toread": readLaterStr]
        
        AFAppDotNetAPIClient.shareAFAppDotNetAPIClient().getRequest(url: "posts/add", paramters: paramters, block: {(json: Any?, error: Error?) -> Void in
            
            if AFAppDotNetAPIClient.shareAFAppDotNetAPIClient().httpError(error: error) {
                self.showAlert(text: error?.localizedDescription)
                
                return
            }
            
            let data = json as! Data
            
            let jsonData = try?JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions(rawValue: UInt(0)))
            
            if let jsonDic: Dictionary = jsonData as? Dictionary<String, String> {
                
                if let result_code = jsonDic["result_code"]{
                    
                    if result_code == "done"{
                        
                        self.url_TF.text = ""
                        self.title_TF.text = ""
                        self.description_TV.text = ""
                        self.tags_TF.text = ""
                        
                        self.private_SW.setOn(false, animated: true)
                        self.readLater_SW.setOn(false, animated: true)
                        
                    }else{
                        self.showAlert(text: "result_code")
                    }
                    
                }
            }
            
        })
    }
    
    // MARK: TextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField.tag == 1{
            title_TF.becomeFirstResponder()
        }else if textField.tag == 2{
            description_TV.becomeFirstResponder()
        }else if textField.tag == 4{
            tags_TF.resignFirstResponder()
        }
        
        return true
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "Description"{
            textView.text = ""
            textView.textColor = UIColor.black
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n"{
            tags_TF.becomeFirstResponder()
        }
        
        return true
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
