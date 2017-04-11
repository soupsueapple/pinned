//
//  TagInfoTableViewController.swift
//  pinned
//
//  Created by 汤坤 on 2017/4/10.
//  Copyright © 2017年 Kun Soup. All rights reserved.
//

import UIKit
import MJRefresh
import SafariServices

class TagInfoTableViewController: BaseTableViewController {
    
    let cellIdentity = "TagInfoCell"
    
    var tag = ""
    
    var datas: Array<Dictionary<String, String>> = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = tag
        
        self.tableView.estimatedRowHeight = 44
        self.tableView.rowHeight = UITableViewAutomaticDimension
        
        self.tableView.mj_header = MJRefreshNormalHeader(refreshingBlock: {
            
            if self.datas.count > 0{
                self.datas.removeAll()
            }
            self.tableView.reloadData()
            
            self.doAllRequest()
            self.tableView.mj_header.endRefreshing()
        })
        
        self.tableView.mj_header.beginRefreshing()
    }
    
    // MARK: 请求列表数据
    func doAllRequest(){
        
        let paramters = ["tag": tag]
        
        AFAppDotNetAPIClient.shareAFAppDotNetAPIClient().getRequest(url: "posts/all", paramters: paramters, block: {(json: Any?, error: Error?) -> Void in
            
            if AFAppDotNetAPIClient.shareAFAppDotNetAPIClient().httpError(error: error) {
                self.showAlert(text: error?.localizedDescription)
                
                return
            }
            
            let data = json as! Data
            
            let jsonData = try?JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions(rawValue: UInt(0)))
            
            if let jsonArr: Array = jsonData as? Array<Dictionary<String, String>> {
                self.datas = jsonArr
                
                self.tableView.reloadData()
            }
            
        })
    }
    
    // MARK: 删除 URL
    func doDelRequest(url: String){
        
        AFAppDotNetAPIClient.shareAFAppDotNetAPIClient().getRequest(url: "posts/delete", paramters: ["url": url], block: {(json: Any?, error: Error?) -> Void in
            
            if AFAppDotNetAPIClient.shareAFAppDotNetAPIClient().httpError(error: error) {
                self.showAlert(text: error?.localizedDescription)
                
                return
            }
            
        })
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
        return datas.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentity, for: indexPath) as! TagInfoTableViewCell
        
        let dic = self.datas[indexPath.row]
        
        if let description: String = dic["description"]{
            cell.description_lb.text = description
        }
        
        if let extended: String = dic["extended"]{
            cell.extended_lb.text = extended;
        }

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        
        let dic = self.datas[indexPath.row]
        
        if let href: String = dic["href"]{
            let safariViewController = SFSafariViewController(url: URL(string: href)!)
            
            present(safariViewController, animated: true, completion: {() -> Void in
                
                
                
            })
        }
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let dic = self.datas[indexPath.row]
        
        let shareAction = UITableViewRowAction(style: .normal, title: "Share", handler: { (action, indexPath ) -> Void in
            let defaultText = "Share URL"
            
            if let href: String = dic["href"]{
                let url = URL(string: href)
                
                let activityController = UIActivityViewController(activityItems: [defaultText, url!], applicationActivities: nil)
                
                self.present(activityController, animated: true, completion: nil)
            }
        })
        
        let deleteAction = UITableViewRowAction(style: .default, title: "Delete", handler: { (action, indexPath ) -> Void in
            self.datas.remove(at: indexPath.row)
            
            tableView.deleteRows(at: [indexPath], with: .fade)
            
            if let href: String = dic["href"]{
                self.doDelRequest(url: href)
            }
        })
        
        shareAction.backgroundColor = UIColor(red: 48.0/255.0, green: 173.0/255.0, blue: 99.0/255.0, alpha: 1.0)
        deleteAction.backgroundColor = UIColor(red: 202.0/255.0, green: 202.0/255.0, blue: 203.0/255.0, alpha: 1.0)
        
        return [deleteAction, shareAction]
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
