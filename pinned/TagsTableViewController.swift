//
//  TagsTableViewController.swift
//  pinned
//
//  Created by 汤坤 on 2017/4/10.
//  Copyright © 2017年 Kun Soup. All rights reserved.
//

import UIKit
import MJRefresh

class TagsTableViewController: BaseTableViewController {
    
    let cellIdentity = "TagsCell"
    
    let tagsSegueIdentity = "TagsSegue"
    
    var tags: Array<String> = []
    var numbers: Array<String> = []
    
    var inputTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        self.tableView.estimatedRowHeight = 44
        self.tableView.rowHeight = UITableViewAutomaticDimension
        
        self.tableView.mj_header = MJRefreshNormalHeader(refreshingBlock: {
            
            if self.tags.count > 0{
                self.tags.removeAll()
            }
            
            if self.numbers.count > 0{
                self.numbers.removeAll()
            }
            
            self.tableView.reloadData()
            
            self.doTagsReuqest()
            self.tableView.mj_header.endRefreshing()
        })
        
        self.tableView.mj_header.beginRefreshing()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if Constant.SelectTag {
            
            Constant.SelectTag = false
            
            self.performSegue(withIdentifier: tagsSegueIdentity, sender: Constant.SelectTagName)
            
        }
    }
    
    func doTagsReuqest() -> Void{
        AFAppDotNetAPIClient.shareAFAppDotNetAPIClient().getRequest(url: "tags/get", paramters: nil, block: {(json: Any?, error: Error?) -> Void in
            
            if AFAppDotNetAPIClient.shareAFAppDotNetAPIClient().httpError(error: error) {
                self.showAlert(text: error?.localizedDescription)
                
                return
            }
            
            let data = json as! Data
            
            let jsonData = try?JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions(rawValue: UInt(0)))
            
            if let jsonDic: Dictionary = jsonData as? Dictionary<String, String> {
                let datas = jsonDic
                
                for (key, value) in datas{
                    self.tags.append(key)
                    self.numbers.append(value)
                }
                
                self.tableView.reloadData()
            }
            
        })
    }
    
    // MARK: 删除 URL
    func doDelRequest(tag: String){
        
        AFAppDotNetAPIClient.shareAFAppDotNetAPIClient().getRequest(url: "tags/delete", paramters: ["tag": tag], block: {(json: Any?, error: Error?) -> Void in
            
            if AFAppDotNetAPIClient.shareAFAppDotNetAPIClient().httpError(error: error) {
                self.showAlert(text: error?.localizedDescription)
                
                return
            }
        })
    }
    
    // MARK: Tag Rename
    func doRenameRequest(old: String, new: String){
        
        AFAppDotNetAPIClient.shareAFAppDotNetAPIClient().getRequest(url: "tags/rename", paramters: ["old": old, "new": new], block: {(json: Any?, error: Error?) -> Void in
            
            if AFAppDotNetAPIClient.shareAFAppDotNetAPIClient().httpError(error: error) {
                self.showAlert(text: error?.localizedDescription)
                
                return
            }
            
            let data = json as! Data
            
            let jsonData = try?JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions(rawValue: UInt(0)))
            
            if let jsonDic: Dictionary = jsonData as? Dictionary<String, String> {
                let datas = jsonDic
                
                if let result = datas["result"]{
                    if result == "done" {
                        self.tableView.mj_header.beginRefreshing()
                    }else {
                        self.showAlert(text: result)
                    }
                }
                
            }
            
        })
    }
    
    func renameAlert(old: String) {
        
        let alert = UIAlertController(title: "Tag Rename", message: "", preferredStyle: UIAlertControllerStyle.alert)
        
        
        alert.addTextField(configurationHandler: {(textField: UITextField!) in
            textField.placeholder = "Input the new name"
            self.inputTextField = textField
        })
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { (action) -> Void in
            
            if (self.inputTextField.text?.length)! > 0{
                self.doRenameRequest(old: old, new: self.inputTextField.text!)
            }
            
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.tags.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentity, for: indexPath) as! TagsTableViewCell
        
        let tag = tags[indexPath.row]
        let number = numbers[indexPath.row]
        
        cell.tag_lb.text = tag
        cell.number_lb.text = number
        
       

        return cell
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
    
        let tag = tags[indexPath.row]
        
        let shareAction = UITableViewRowAction(style: .normal, title: "Rename", handler: { (action, indexPath ) -> Void in
            self.renameAlert(old: tag)
        })
        
        let deleteAction = UITableViewRowAction(style: .default, title: "Delete", handler: { (action, indexPath ) -> Void in
            self.tags.remove(at: indexPath.row)
            self.numbers.remove(at: indexPath.row)
            
            tableView.deleteRows(at: [indexPath], with: .fade)
            
            let tag = self.tags[indexPath.row]
            
            self.doDelRequest(tag: tag)
        })
        
        shareAction.backgroundColor = UIColor(red: 48.0/255.0, green: 173.0/255.0, blue: 99.0/255.0, alpha: 1.0)
        deleteAction.backgroundColor = UIColor(red: 202.0/255.0, green: 202.0/255.0, blue: 203.0/255.0, alpha: 1.0)
        
        return [deleteAction, shareAction]
    }
    
//    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        tableView.deselectRow(at: indexPath, animated: false)
//        
//        let tag = tags[indexPath.row]
//        
//        let tagInfoTableViewController = TagInfoTableViewController()
//        tagInfoTableViewController.tag = tag
//        self.navigationController?.pushViewController(tagInfoTableViewController, animated: true)
//    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == tagsSegueIdentity {
            
            if let tagNmae: String = sender as? String{
                
                let tagInfoTableViewController = segue.destination as! TagInfoTableViewController
                tagInfoTableViewController.tag = tagNmae
                
            }else{
                let tag = tags[(self.tableView.indexPathForSelectedRow?.row)!]
                
                let tagInfoTableViewController = segue.destination as! TagInfoTableViewController
                tagInfoTableViewController.tag = tag
                
            }
            
            
        }
    }
 

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
