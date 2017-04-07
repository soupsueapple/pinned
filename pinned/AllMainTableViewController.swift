//
//  AllMainTableViewController.swift
//  pinned
//
//  Created by 汤坤 on 2017/4/5.
//  Copyright © 2017年 Kun Soup. All rights reserved.
//

import UIKit
import MJRefresh

class AllMainTableViewController: BaseTableViewController {
    
    var datas: Array<Dictionary<String, String>> = []
    
    var index = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        self.tableView.estimatedRowHeight = 44
        self.tableView.rowHeight = UITableViewAutomaticDimension
        
        self.tableView.mj_header = MJRefreshNormalHeader(refreshingBlock: {
            self.index = 0
            if self.datas.count > 0{
                self.datas.removeAll()
            }
            self.tableView.reloadData()
            
            self.doAllRequest()
            self.tableView.mj_header.endRefreshing()
        })
        
        self.tableView.mj_footer = MJRefreshAutoNormalFooter(refreshingBlock: {
            self.doAllRequest()
            self.tableView.mj_footer.endRefreshing()
        })
        
        self.tableView.mj_header.beginRefreshing()
        
//        self.doAllRequest()
    }
    
    // MARK: 请求列表数据
    func doAllRequest(){
        let parmaters = ["start": "\(index)", "results": "20"]
        
        AFAppDotNetAPIClient.shareAFAppDotNetAPIClient().getRequest(url: "posts/all", paramters: parmaters, block: {(json: Any?, error: Error?) -> Void in
        
            if AFAppDotNetAPIClient.shareAFAppDotNetAPIClient().httpError(error: error) {
                self.showAlert(text: error?.localizedDescription)
                
                return
            }
            
            let data = json as! Data
            
            let jsonData = try?JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions(rawValue: UInt(0)))
            
            if let jsonArr: Array = jsonData as? Array<Dictionary<String, String>> {
//                self.datas = jsonArr
                self.datas += jsonArr
                self.index += 20
                
                self.tableView.reloadData()
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
        return self.datas.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AllTableCell", for: indexPath) as! AllMainTableViewCell

        let dic = self.datas[indexPath.row]
        
        if let description: String = dic["description"]{
            cell.description_lb.text = description
        }
        
        if let extended: String = dic["extended"]{
            cell.extended_lb.text = extended;
        }
        
        if let tags: String = dic["tags"]{
            
            let arrTags = tags.components(separatedBy: " ")
            
            cell.collectionViewDataSourceDelegate(tags: arrTags)
        }

        return cell
    }
    
    
//    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 80
//    }


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
